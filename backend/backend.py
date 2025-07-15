from fastapi import FastAPI, Request
from pydantic import BaseModel
from typing import List
import openai
from openai import OpenAI


app = FastAPI()

OPENAI_API_KEY= "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"

# API Key
openai.api_key = OPENAI_API_KEY

# -----------------------------
# 1. design IMU data frame
# -----------------------------
class IMUData(BaseModel):
    user_id: str
    timestamp: str
    accel: List[List[float]]  # e.g., [[x1, y1, z1], [x2, y2, z2], ...]
    gyro: List[List[float]]

# -----------------------------
# 2. create ChatGPT Prompt
# -----------------------------
def construct_prompt(data: IMUData) -> str:
    prompt = (
        "!!!!!Think step by step!!!!!!!"
        "You are a professional activity recognition Human Expert.\n"
        "You need analyze following IMU data of an college student with 175cm height and 70kg weight anddetermine the most likely human activity of this student.\n"
        "Given the college student's following IMU data:\n"
        f"Acceleration: {data.accel}\n"
        f"Gyroscope: {data.gyro}\n"
        "What is the most likely human activity? !!!!!Think step by step!!!!!!!"
        #"Response your thoughts step by step, and then give the final answer.\n"
        "!!!!!!Strict LIMITATION!!!!!You must only reponse one activity in following activity set\n"
        "activitiy set: running, standing, walking, climbing stairs, swimming, Unkown.\n"
        "you can only responset activity name, do not response any other words.\n"
        "!!!!!Think step by step!!!!!!!"
    )
    return prompt

# -----------------------------
# 3. use GPT model to analyze IMU data
# -----------------------------
client = OpenAI(api_key=OPENAI_API_KEY)

def call_gpt(prompt: str) -> str:
    response = client.chat.completions.create(
        model="gpt-4",
        #model="gpt-3.5-turbo",
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
@app.post("/imu-data")
async def receive_imu_data(data: IMUData):
    prompt = construct_prompt(data)
    activity = call_gpt(prompt)
    return {
        "user_id": data.user_id,
        "timestamp": data.timestamp,
        "activity": activity
    }