import { useState, useEffect } from "react";

function ActivityMonitor() {
  const [userId, setUserId] = useState("");
  const [timestamp, setTimestamp] = useState("");
  const [activity, setActivity] = useState("");

  useEffect(() => {
    const fetchLatestActivity = async () => {
      try {
        const res = await fetch("http://127.0.0.1:8251/latest");
        const json = await res.json();
        console.log("Latest activity:", json);

        setUserId(json.user_id);
        setTimestamp(json.timestamp);
        setActivity(json.activity);
      } catch (error) {
        console.error("Failed to fetch activity:", error);
      }
    };

    fetchLatestActivity(); // 初始化加载一次

    const interval = setInterval(fetchLatestActivity, 2000); // 每 2 秒轮询一次

    return () => clearInterval(interval); // 卸载时清理定时器
  }, []);

  return (
    <div>
      <h2>Latest Activity</h2>
      <p><strong>User ID:</strong> {userId}</p>
      <p><strong>Timestamp:</strong> {timestamp}</p>
      <p><strong>Activity:</strong> {activity}</p>
    </div>
  );
}

export default ActivityMonitor;