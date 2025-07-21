from fastapi import FastAPI, Request
from pydantic import BaseModel
from typing import List
import openai
from openai import OpenAI
import uvicorn
from fastapi.middleware.cors import CORSMiddleware

import time
from datetime import datetime

from fastapi import HTTPException, status, Header
from typing import Optional
from uuid import uuid4
from datastore import users, all_latest_activities

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class Sample(BaseModel):
    timestamp: float
    accX: float
    accY: float
    accZ: float
    gyroX: float
    gyroY: float
    gyroZ: float
    magX: float
    magY: float
    magZ: float





if __name__ == "__main__":
    uvicorn.run("backend:app", host="0.0.0.0", port=8251, reload=True)

OPENAI_API_KEY= "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"

# API Key
openai.api_key = OPENAI_API_KEY

# -----------------------------
# 1. design IMU data frame
# -----------------------------
class IMUData(BaseModel):
    user_id: str
    samples: List[Sample] 

# -----------------------------
# 2. create ChatGPT Prompt
# -----------------------------
def construct_prompt(data: IMUData) -> str:
    # prompt = (
    #     "!!!!!Think step by step!!!!!!!\n"
    #     "You are a professional activity recognition Human Expert.\n"
    #     "Analyze the following IMU data from a college student (175cm, 70kg):\n"
    #     "The IMU was placed in the user's hand or pocket.\n"
    #     "Each record includes: timestamp, 3-axis accelerometer, gyroscope, and magnetometer readings.\n\n"
    #     "The data was recorded over a 2-second window and has been downsampled (1 out of every 10 samples preserved).\n"
    # )
    # for sample in data.samples:
    #     prompt += (
    #         f"Timestamp: {sample.timestamp:.2f}, "
    #         f"Acc: [{sample.accX:.2f}, {sample.accY:.2f}, {sample.accZ:.2f}], "
    #         f"Gyro: [{sample.gyroX:.2f}, {sample.gyroY:.2f}, {sample.gyroZ:.2f}], "
    #         f"Mag: [{sample.magX:.2f}, {sample.magY:.2f}, {sample.magZ:.2f}]\n"
    #     )

    # prompt += (
        
    #     "You must only respond with **one** activity from:\n"
    #     "running, standing, walking, climbing stairs, Unknown.\n"
    #     "Only respond with the activity name."
    #     "you must think step by step and analyze the data before giving the final answer.\n"
    #     "Do not include any other text or explanation except (running, standing, walking, climbing stairs, Unknown.)\n"
    # )
    prompt = (
    "You are a professional human activity recognition expert.\n"
    "Analyze the following IMU data from a college student (175cm, 70kg).\n"
    "The IMU was placed in the user's hand or pocket.\n"
    "The data was recorded over a 2-second window and has been downsampled (1 out of every 10 samples preserved).\n"
    "Each record includes: timestamp, 3-axis accelerometer, gyroscope, and magnetometer readings.\n\n"
    "YOU must think step-by-step and identify the most likely activity.\n"
    "You must choose **ONLY ONE** from the following options:\n"
    "walking, running, standing, climbing stairs, swimming, unknown.\n"
    "Respond with just the activity name.\n\n"
    )

    for sample in data.samples:
        prompt += (
            f"Timestamp: {sample.timestamp:.2f}, "
            f"Acc: [{sample.accX:.2f}, {sample.accY:.2f}, {sample.accZ:.2f}], "
            f"Gyro: [{sample.gyroX:.2f}, {sample.gyroY:.2f}, {sample.gyroZ:.2f}], "
            f"Mag: [{sample.magX:.2f}, {sample.magY:.2f}, {sample.magZ:.2f}]\n"
        )

    prompt += "\nActivity:(ONLY respond with the activity name, no other text)\n"

    return prompt

# -----------------------------
# 3. use GPT model to analyze IMU data
# -----------------------------
client = OpenAI(api_key=OPENAI_API_KEY)

def call_gpt(prompt: str) -> str:
    response = client.chat.completions.create(
        #model="gpt-4",
        model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": "You are a sensor data analysis expert."},
            {"role": "user", "content": prompt}
        ],
        temperature=0.3
    )
    return response.choices[0].message.content.strip()

# -----------------------------
# 4. POST Socket
# -----------------------------

latest_activity = {f"user_id": "","timestamp": "", "activity": ""}

@app.post("/imu-data")
async def receive_imu_data(data: IMUData):
    print(f"✅ Received {len(data.samples)} samples from user {data.user_id}")
    prompt = construct_prompt(data)
    activity = call_gpt(prompt)
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    #  记得更新全局变量 latest_activity
    latest_activity["user_id"] = data.user_id
    latest_activity["timestamp"] = current_time
    latest_activity["activity"] = activity


    # 存入 all_latest_activities
    all_latest_activities[data.user_id] = {
        "user_id": data.user_id,
        "timestamp": current_time,
        "activity": activity
    }

    return {
        "user_id": data.user_id,
        "timestamp": current_time,
        "activity": activity
    }




# -----------------------------
# 5. GET Socket
# -----------------------------
@app.get("/latest")
def get_latest_activity():
    print(f"latest_activity: {latest_activity}")
    return latest_activity




class RegisterData(BaseModel):
    user_id: str
    password: str
    name: str

@app.post("/auth/register")
def register_user(data: RegisterData):
    if data.user_id in users:
        raise HTTPException(status_code=400, detail="User ID already registered.")
    token = str(uuid4())
    users[data.user_id] = {"password": data.password, "name": data.name, "token": token}
    return {"token": token}


# -----------------------------
# 登录接口
# -----------------------------
class LoginData(BaseModel):
    user_id: str
    password: str

@app.post("/auth/login")
def login_user(data: LoginData):
    user = users.get(data.user_id)
    if not user or user["password"] != data.password:
        raise HTTPException(status_code=401, detail="Invalid credentials.")
    return {"token": user["token"]}

# -----------------------------
# return all user's latest activities
# -----------------------------
@app.get("/all-latest")
def get_all_latest():
    return list(all_latest_activities.values())
