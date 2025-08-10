import React from 'react';
import { useNavigate } from 'react-router-dom';
import { Box, Typography, Button, Stack } from '@mui/material';
import './WelcomePage.css';

const WelcomePage = () => {
  const navigate = useNavigate();

  return (
    <Box
      className="fadeIn"
      sx={{
        height: '100vh',
        overflow: 'hidden',
        fontFamily: `"SF Pro Display", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif`,
        position: 'relative',
        background: 'linear-gradient(135deg, #0f0f0f, #1c1c1c, #2c2c2c, #3b3a4f, #2b2d42)',
      }}
    >
      <Box
        sx={{
          position: 'absolute',
          top: '50%',
          left: '50%',
          transform: 'translate(-50%, -50%)',
          background: 'rgba(0, 0, 0, 0.4)', // 半透明黑玻璃风
          borderRadius: '32px',
          backdropFilter: 'blur(24px)',
          WebkitBackdropFilter: 'blur(24px)',
          boxShadow: '0 0 60px rgba(0, 128, 255, 0.1)',
          padding: '3rem',
          textAlign: 'center',
          maxWidth: '400px',
          width: '90%',
          border: '1px solid rgba(255, 255, 255, 0.1)',
        }}
      >
        <Typography
          variant="h3"
          sx={{
            fontWeight: 700,
            color: '#ffffff',
            mb: 2,
            textShadow: '0 0 12px rgba(0, 174, 255, 0.5)',
          }}
        >
          Welcome to KinetiSense
        </Typography>

        <Typography
          variant="subtitle1"
          sx={{
            color: 'rgba(255,255,255,0.8)',
            mb: 4,
            fontWeight: 300,
            letterSpacing: '0.5px',
          }}
        >
          Please select your role to continue
        </Typography>

        <Stack spacing={2}>
          <Button
            variant="contained"
            size="large"
            sx={{
              fontWeight: 600,
              fontSize: '1rem',
              padding: '0.75rem 2rem',
              borderRadius: '14px',
              background: 'linear-gradient(to right, #6a11cb, #2575fc)',
              boxShadow: '0 0 16px rgba(101, 140, 255, 0.6)',
              transform: 'scale(1)',
              transition: 'all 0.3s ease-in-out',
              '&:hover': {
                background: 'linear-gradient(to right, #4a00e0, #007aff)',
                boxShadow: '0 0 24px rgba(101, 140, 255, 0.9)',
                transform: 'scale(1.03)',
              },
            }}
            onClick={() => navigate('/user')}
          >
            I am a User
          </Button>

          <Button
            variant="outlined"
            size="large"
            sx={{
              fontWeight: 500,
              fontSize: '1rem',
              padding: '0.75rem 2rem',
              borderRadius: '14px',
              color: '#00c6ff',
              borderColor: '#00c6ff',
              backgroundColor: 'rgba(255,255,255,0.05)',
              '&:hover': {
                backgroundColor: 'rgba(0,198,255,0.1)',
                borderColor: '#00aaff',
                color: '#00aaff',
              },
            }}
            onClick={() => navigate('/admin')}
          >
            I am an Admin
          </Button>
        </Stack>
      </Box>
    </Box>
  );
};

export default WelcomePage;