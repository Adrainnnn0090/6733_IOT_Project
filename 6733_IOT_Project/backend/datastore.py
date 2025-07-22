import json
import os

BASE_DIR = os.path.dirname(__file__) 
DATA_FILE = os.path.join(BASE_DIR, 'latest_activities.json')  

# 尝试从文件中加载历史记录
def load_latest_activities():
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE, 'r') as f:
            return json.load(f)
    return {}

# 保存当前活动数据到文件
def save_latest_activities(data):
    with open(DATA_FILE, 'w') as f:
      json.dump(data, f, indent=2)
    print("latest_activities.json saved successfully.")
    print("!!!!!!!#@@@@@@@ saved file path:", os.path.abspath(DATA_FILE))

# 全局变量
users = {}  # user_id: { token }
admin_users = {}  # user_id: { password, token }

# 加载已有数据（会覆盖旧的数据）
all_latest_activities = load_latest_activities()