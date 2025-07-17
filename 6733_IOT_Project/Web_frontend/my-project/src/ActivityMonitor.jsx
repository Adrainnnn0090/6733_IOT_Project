import { useState, useEffect } from "react";

function ActivityMonitor() {
  const [userId, setUserId] = useState("");
  const [timestamp, setTimestamp] = useState("");
  const [activity, setActivity] = useState(""); // ✅生产环境记得改回来

  // 获取图片路径
  const getActivityImage = (activity) => {
    const normalized = activity.toLowerCase().replace(/\s+/g, "_");
    const imageMap = {
      walking: "walking.gif",
      running: "running.gif",
      standing: "standing.gif",
      "climbing stairs": "climbing_stairs.gif",
      swimming: "swimming.gif",
      unknown: "unknown.gif",
    };
    return `/images/${imageMap[normalized] || "unknown.gif"}`;
  };

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

    fetchLatestActivity();
    const interval = setInterval(fetchLatestActivity, 2000);
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="card">
      <h2>Latest Activity</h2>
      <p><strong>User ID:</strong> {userId}</p>
      <p><strong>Timestamp:</strong> {timestamp}</p>
      <p><strong>Activity:</strong> {activity}</p>

      {activity && (
        <img
          src={getActivityImage(activity)}
          alt={activity}
          style={{ width: '200px', height: '200px', marginTop: '1rem' }}
        />
      )}
    </div>
  );
}

export default ActivityMonitor;