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
        py: 8,
        px: 12,
        background: 'linear-gradient(to right, #0f2027, #203a43, #2c5364)',
        color: 'white',
        borderRadius: 4,
        boxShadow: 3,
      }}
    >
      <Typography
        variant="h2"
        sx={{
          fontWeight: 1800,
          background: 'linear-gradient(to right, #00c6ff, #0072ff)',
          WebkitBackgroundClip: 'text',
          WebkitTextFillColor: 'transparent',
        }}
      >
        KinetiSense
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

