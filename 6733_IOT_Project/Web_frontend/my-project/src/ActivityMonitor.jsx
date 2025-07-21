import { useEffect, useState } from "react";
import { Box, Typography, Card, Grid } from "@mui/material";

function ActivityMonitor() {
  const [userId, setUserId] = useState("");
  const [timestamp, setTimestamp] = useState("");
  const [activity, setActivity] = useState("");

  const getActivityImage = (activity) => {
    const normalized = activity.toLowerCase().replace(/\s+/g, "_");
    const imageMap = {
      walking: "walking.gif",
      running: "running.gif",
      standing: "standing.gif",
      climbing_stairs: "climbing_stairs.gif",
      swimming: "swimming.gif",
      unknown: "unknown.gif",
    };
    return `/images/${imageMap[normalized] || "unknown.gif"}`;
  };

  useEffect(() => {
    const fetchLatestActivity = async () => {
      try {
        const res = await fetch("http://adddd.local:8251/latest");
        const json = await res.json();
        setUserId(json.user_id);
        setTimestamp(json.timestamp);
        setActivity(json.activity);
      } catch (err) {
        console.error("Fetch failed:", err);
      }
    };

    fetchLatestActivity();
    const interval = setInterval(fetchLatestActivity, 2000);
    return () => clearInterval(interval);
  }, []);

  return (
    <Box
      sx={{
        display: "flex",
        justifyContent: "center",
        p: 2,
        mt: 4,
      }}
    >
      <Card
        sx={{
          width: "100%",
          maxWidth: 900,
          p: 4,
          backdropFilter: "blur(20px)",
          backgroundColor: "rgba(255, 255, 255, 0.08)",
          borderRadius: 5,
          boxShadow: "0 8px 32px rgba(0,0,0,0.25)",
          color: "white",
        }}
      >
        <Grid
          container
          spacing={3}
          alignItems="center"
          justifyContent="space-between"
        >
          <Grid item xs={12} md={6} >
            <Typography
              variant="h5"
              gutterBottom
              sx={{
                fontSize: '2.2rem',
                fontWeight: 600,
                letterSpacing: '0.5px',
                color: '#F5F5F7',
                fontFamily: `"SF Pro Display", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif`, // 苹果官方字体
                textShadow: '0 1px 3px rgba(0,0,0,0.2)',
              }}
            >
              Latest Activity
            </Typography>
            <Typography>
              <Box component="span" sx={{ fontWeight: 'bold', color: 'rgba(255,255,255,0.9)', mr: 1 }}>
                User ID:
              </Box>
              <Box component="span" sx={{ color: '#f0f0f5' /* or Apple-like colors */ }}>
                {userId}
              </Box>
            </Typography>

            <Typography>
              <Box component="span" sx={{ fontWeight: 'bold', color: 'rgba(255,255,255,0.9)', mr: 1 }}>
                Timestamp:
              </Box>
              <Box component="span" sx={{ color: '#e0e0ec' }}>
                {timestamp}
              </Box>
            </Typography>

            <Typography>
              <Box component="span" sx={{ fontWeight: 'bold', color: 'rgba(255,255,255,0.9)', mr: 1 }}>
                Activity:
              </Box>
              <Box component="span" sx={{ color: '#cce4ff' /* soft blue */ }}>
                {activity}
              </Box>
            </Typography>
          </Grid>

          <Grid item xs={12} md={6}>
            {activity && (
              <Box
                component="img"
                src={getActivityImage(activity)}
                alt={activity}
                sx={{
                  width: "100%",
                  maxWidth: 200,
                  height: "auto",
                  borderRadius: 3,
                  mt: { xs: 2, md: 0 },
                  mx: "auto",
                  display: "block",
                  animation: "float 5s ease-in-out infinite",
                }}
              />
            )}
          </Grid>
        </Grid>
      </Card>
    </Box>
  );
}

export default ActivityMonitor;