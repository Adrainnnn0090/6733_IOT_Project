import pandas as pd
import numpy as np
import torch.nn as nn
import torch.nn.functional as F
import torch
import os

from sklearn.metrics import classification_report, confusion_matrix, ConfusionMatrixDisplay
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
import torch
from torch.utils.data import Dataset, DataLoader
from sklearn.metrics import precision_recall_fscore_support, accuracy_score
from torch.optim.lr_scheduler import StepLR


class GestureCNNLSTM(nn.Module):
  def __init__(self, input_channels=9, hidden_dim=64, num_classes=4):
      super().__init__()

      # 卷积层
      self.conv1 = nn.Conv1d(input_channels, 32, kernel_size=3, padding=1)
      self.conv2 = nn.Conv1d(32, 64, kernel_size=3, padding=1)
      #self.conv3 = nn.Conv1d(64, 128, kernel_size=3, padding=1)


      self.relu = nn.ReLU()
      self.dropout = nn.Dropout(0.3)

      # LSTM
      self.lstm = nn.LSTM(input_size=64, hidden_size=hidden_dim, batch_first=True, bidirectional=True)

      self.fc1 = nn.Linear(hidden_dim * 2, 64)
      #self.fc2 = nn.Linear(128, 64)
      self.fc2 = nn.Linear(64, num_classes)


  def forward(self, x):
      x = x.permute(0, 2, 1)  # [B, C, T]
      x = self.relu(self.conv1(x))      # [B, 32, T]
      x = self.relu(self.conv2(x))      # [B, 64, T]

      # [B, T, 64]
      x = x.permute(0, 2, 1)
      _, (hn, _) = self.lstm(x)
      x = torch.cat((hn[0], hn[1]), dim=1)  # [B, 2H]

      x = self.relu(self.fc1(x))
      x = self.dropout(x)
      out = self.relu(self.fc2(x))

      return out
  




def predict_gesture(segment_100x9, model_path="best_model.pt"):
    # Initialize the model with the correct hidden_dim used during training
    model = GestureCNNLSTM(input_channels=9, hidden_dim=128, num_classes=4)
    model.load_state_dict(torch.load(model_path))
    model.eval()


    tensor = torch.tensor(segment_100x9, dtype=torch.float32).unsqueeze(0)
    with torch.no_grad():
        out = model(tensor)
        pred = torch.argmax(out, dim=1).item()
    return pred





# map action names 
gesture_map = {
    "Standing": 0,
    "Running": 1,
    "Walking": 2,
    "Climbing_stairs": 3
}
id_to_label = {v: k for k, v in gesture_map.items()}




def inference (IMUdata):
  # === Step 1: Loading IMU CSV data ===
  csv_path = "Data_Collection_Running.csv" 
  df = pd.read_csv(csv_path)

  # Remove the first column of timestamps and keep only the IMU 9-dimensional
  imu_data = df.values[:, 1:].astype(np.float32)

  # Make sure it is long enough for a segment (100 lines)
  for _ in range(100):
    if imu_data.shape[0] < 100:
        raise ValueError("❌ data is not long enough for a segment of 100 lines.")

    # only get the first 100 lines
    segment = imu_data[:100]  # shape: (100, 9)

    # Convert to tensor and add batch dimension → (1, 100, 9)
    input_tensor = torch.tensor(segment).unsqueeze(0)  # shape: (1, 100, 9)

    # === Step 2: Load model ===
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    # Initialize the model with the correct hidden_dim used during training
    model = GestureCNNLSTM(input_channels=9, hidden_dim=128, num_classes=4).to(device)
    model.load_state_dict(torch.load("best_model.pt", map_location=device))
    model.eval()

    # === Step 3: Inference ===
    input_tensor = input_tensor.to(device)
    with torch.no_grad():
        output = model(input_tensor)
        pred_id = torch.argmax(output, dim=1).item()
        pred_label = id_to_label[pred_id]

    print(f"{pred_label}")