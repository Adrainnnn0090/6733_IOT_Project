import { useState, useEffect } from "react";
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import { Box, Typography, CssBaseline } from '@mui/material';
import ActivityMonitor from './ActivityMonitor.jsx';
// import ActivityMonitor from "./ActivityMonitor";


export default function App() {

  return (
    <Box
      sx={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        textAlign: 'center',
        py: 6,
        px: 4,
        mx: 'auto',
        maxWidth: '900px',
        borderRadius: '32px',
        background: 'rgba(25, 25, 30, 0.85)', // 更深背景，提升对比
        backdropFilter: 'blur(24px)',
        border: '1px solid rgba(255,255,255,0.15)',
        boxShadow: '0 8px 40px rgba(0,0,0,0.3)',
        color: '#ffffff',
        fontFamily: `"SF Pro Display", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif`,
      }}
    >
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
    </Box>
  );
}


