import json
import os
BASE_DIR = os.path.dirname(__file__) 
ADMIN_USER_FILE = os.path.join(BASE_DIR, 'admin_users.json')  

# 初始化 admin_users 数据（只在启动时加载一次）


if os.path.exists(ADMIN_USER_FILE) and os.path.getsize(ADMIN_USER_FILE) > 0:
    with open(ADMIN_USER_FILE, "r") as f:
        admin_users = json.load(f)
else:
    admin_users = {}

def save_admin_users(admin_users):
    if not os.path.exists(ADMIN_USER_FILE):
        os.makedirs(os.path.dirname(ADMIN_USER_FILE), exist_ok=True)
    with open(ADMIN_USER_FILE, "w") as f:
        json.dump(admin_users, f, indent=4) 


def load_admin_users():
    if os.path.exists(ADMIN_USER_FILE):
        with open(ADMIN_USER_FILE, "r") as f:
            return json.load(f)
    else:
        return {}