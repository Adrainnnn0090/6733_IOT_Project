from fastapi import FastAPI, Request
from pydantic import BaseModel
from typing import List
import openai
from openai import OpenAI
import uvicorn
from fastapi.middleware.cors import CORSMiddleware

import time
from datetime import datetime


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
    prompt = (
        "!!!!!Think step by step!!!!!!!\n"
        "You are a professional activity recognition Human Expert.\n"
        "Analyze the following IMU data from a college student (175cm, 70kg):\n"
    )
    for sample in data.samples:
        prompt += (
            f"Timestamp: {sample.timestamp:.2f}, "
            f"Acc: [{sample.accX:.2f}, {sample.accY:.2f}, {sample.accZ:.2f}], "
            f"Gyro: [{sample.gyroX:.2f}, {sample.gyroY:.2f}, {sample.gyroZ:.2f}], "
            f"Mag: [{sample.magX:.2f}, {sample.magY:.2f}, {sample.magZ:.2f}]\n"
        )

    prompt += (
        "!!!!!Think step by step!!!!!!!\n"
        "You must only respond with **one** activity from:\n"
        "running, standing, walking, climbing stairs, swimming, Unknown.\n"
        "Only respond with the activity name."
    )

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
current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
latest_activity = {f"user_id": "","time":current_time, "activity": ""}

@app.post("/imu-data")
async def receive_imu_data(data: IMUData):
    print(f"✅ Received {len(data.samples)} samples from user {data.user_id}")
    prompt = construct_prompt(data)
    activity = call_gpt(prompt)

    #  记得更新全局变量 latest_activity
    latest_activity["user_id"] = data.user_id
    #latest_activity["timestamp"] = data.timestamp
    latest_activity["activity"] = activity

    return {
        "user_id": data.user_id,
        #"timestamp": data.timestamp,
        "activity": activity
    }

# -----------------------------
# 5. GET Socket
# -----------------------------
@app.get("/latest")
def get_latest_activity():
    print(f"latest_activity: {latest_activity}")
    return latest_activity