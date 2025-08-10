import { useState, useEffect } from "react";
import { Box, Typography, Button } from '@mui/material';
import ActivityMonitor from './ActivityMonitor.jsx';
import './UserActivity.css';

export default function UserActivity() {
  const [username, setUsername] = useState('');

  useEffect(() => {
    const stored = localStorage.getItem("userId");
    if (stored) setUsername(stored);
  }, []);

  const handleLogout = () => {
    localStorage.removeItem("userId");
    window.location.href = '/user';
  };

  return (
    <Box
      sx={{
        minHeight: 'calc(100vh - 80px)',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        padding: '2rem',
        background: 'linear-gradient(to bottom right, #e0f7fa, #f0f4ff)',
      }}
    >
      {/* <Box
        className="fadeIn"
        sx={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          textAlign: 'center',
          py: 6,
          px: 4,
          maxWidth: '900px',
          width: '100%',
          borderRadius: '32px',
          background: 'rgba(25, 25, 30, 0.85)',
          backdropFilter: 'blur(24px)',
          border: '1px solid rgba(255,255,255,0.15)',
          boxShadow: '0 8px 40px rgba(0,0,0,0.3)',
          color: '#ffffff',
          fontFamily: `"SF Pro Display", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif`,
        }}
      > */}
      <Box
        className="fadeIn"
        sx={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          textAlign: 'center',
          py: 6,
          px: 4,
          maxWidth: '900px',
          width: '100%',
          borderRadius: '32px',
          background: 'rgba(25, 25, 30, 0.85)',
          backdropFilter: 'blur(24px)',
          border: '1px solid rgba(255,255,255,0.15)',
          boxShadow: '0 8px 40px rgba(0,0,0,0.3)',
          color: '#ffffff',
          fontFamily: `"SF Pro Display", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif`,
        }}
      >
        <Typography
          variant="subtitle2"
          sx={{ color: '#b0bec5', mb: 2 }}
        >
          Welcome, {username} 🧍
        </Typography>

        <Typography
          variant="h2"
          sx={{
            fontWeight: 700,
            fontSize: '3.2rem',
            color: '#fefefe',
            mb: 2,
          }}
        >
          KinetiSense
        </Typography>

        <Typography
          variant="h5"
          sx={{
            fontWeight: 400,
            fontSize: '1.5rem',
            color: '#e0e0e0',
            mb: 2,
          }}
        >
          Smart Sensing for Every Move
        </Typography>

        <Typography
          variant="subtitle1"
          sx={{
            mt: 1,
            fontSize: '1.15rem',
            color: '#cccccc',
            maxWidth: '600px',
          }}
        >
          Real-time Human Activity Recognition Powered by IMU + LLM
        </Typography>

        <Box mt={5} width="100%">
          <ActivityMonitor />
        </Box>

        <Button
          onClick={handleLogout}
          sx={{
            mt: 4,
            color: '#fff',
            border: '1px solid rgba(255,255,255,0.2)',
            background: 'transparent',
            backdropFilter: 'blur(12px)',
            '&:hover': {
              background: 'rgba(255,255,255,0.1)',
            },
          }}
        >
          🚪 Logout
        </Button>
      </Box>
    </Box>
  );
}