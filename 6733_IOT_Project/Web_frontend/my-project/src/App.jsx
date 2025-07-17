import { useState, useEffect } from "react";
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import { Box, Typography } from '@mui/material';
import ActivityMonitor from './ActivityMonitor.jsx';


export default function App() {

  return (
    <Box
      sx={{
        display: 'flex',
        flexDirection: 'column',
        textAlign: 'center',
        py: 4,
        px: 6,
        background: 'linear-gradient(to right, #0f2027, #203a43, #2c5364)',
        color: 'white',
        borderRadius: 4,
        boxShadow: 3,
      }}
    >
      <Typography
        variant="h2"
        sx={{
          fontWeight: 700,
          fontSize: '3.5rem',
          background: 'linear-gradient(to right, #6366f1, #60a5fa)',
          WebkitBackgroundClip: 'text',
          WebkitTextFillColor: 'transparent',
          mb: 2,
        }}
      >
        KinetiSense
      </Typography>


      <Typography
        variant="h5"
        sx={{
          fontWeight: 400,
          color: 'rgba(255, 255, 255, 0.9)',
          mb: 3,
        }}
      >
        Smart Sensing for Every Move
      </Typography>

      <Typography
        variant="subtitle1"
        sx={{
          mt: 2,
          fontSize: '1.2rem',
          color: 'rgba(255,255,255,0.85)',
        }}
      >
        Real-time Human Activity Recognition Powered by IMU + LLM
      </Typography>


      <Box mt={4}>
        <ActivityMonitor />
      </Box>
    </Box>
  );
}

