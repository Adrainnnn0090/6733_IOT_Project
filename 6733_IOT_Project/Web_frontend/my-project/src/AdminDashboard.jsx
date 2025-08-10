// import React, { useEffect, useState } from 'react';
// import axios from 'axios';
// import './AdminDashboard.css';

// function AdminDashboard() {
//   const [data, setData] = useState([]);
//   const [error, setError] = useState('');
//   const [searchQuery, setSearchQuery] = useState('');

//   useEffect(() => {
//     const fetchData = () => {
//       axios.get('http://adddd.local:8251/all-latest')
//         .then((res) => setData(res.data))
//         .catch((err) => setError(err.message));
//     };

//     fetchData();
//     const intervalId = setInterval(fetchData, 3000);
//     return () => clearInterval(intervalId);
//   }, []);

//   const filteredData = data.filter(record =>
//     record.user_id.toLowerCase().includes(searchQuery.toLowerCase())
//   );

//   return (
//     <div className="dashboard-root">
//       <div className="dashboard-header">
//         <h1>⚡ Admin Activity Dashboard</h1>
//         <input
//           type="text"
//           placeholder="🔍 Search by User Name"
//           value={searchQuery}
//           onChange={(e) => setSearchQuery(e.target.value)}
//           className="dashboard-search"
//         />
//       </div>

//       {error && <p className="dashboard-error">{error}</p>}

//       <div className="dashboard-cards">
//         {filteredData.length > 0 ? (
//           filteredData.map((record, index) => (
//             <div key={index} className="dashboard-card fadeIn">
//               <p className="card-user">🧍 <strong>{record.user_id}</strong></p>
//               <p className="card-activity">Activity: {record.activity}</p>
//               {/* 可选显示时间 */}
//               {record.timestamp && (
//                 <p className="card-time">🕒 {new Date(record.timestamp).toLocaleString()}</p>
//               )}
//             </div>
//           ))
//         ) : (
//           <div className="dashboard-nodata">No user activity found.</div>
//         )}
//       </div>
//     </div>
//   );
// }

// export default AdminDashboard;




import React, { useEffect, useState } from 'react';
import axios from 'axios';
import {
  Box,
  Typography,
  TextField,
  Dialog,
  DialogTitle,
  DialogContent,
  Fade,
  Paper
} from '@mui/material';

export default function AdminDashboard() {
  const [data, setData] = useState([]);
  const [error, setError] = useState('');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedRecord, setSelectedRecord] = useState(null);

  useEffect(() => {
    const fetchData = () => {
      axios.get('http://adddd.local:8251/all-latest')
        .then((res) => setData(res.data))
        .catch((err) => setError(err.message));
    };

    fetchData();
    const intervalId = setInterval(fetchData, 3000);
    return () => clearInterval(intervalId);
  }, []);

  const filteredData = data.filter(record =>
    record.user_id.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <Box
      sx={{
        minHeight: '100vh',
        padding: '2rem',
        background: 'linear-gradient(135deg, #f0fff0, #e6fffd)',
        fontFamily: '"SF Pro Display", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif',
      }}
    >
      <Box sx={{ textAlign: 'center', mb: 4 }}>
        <Typography variant="h4" fontWeight={700} gutterBottom>
          Admin Activity Dashboard
        </Typography>
        <TextField
          variant="outlined"
          placeholder="🔍 Search by User Name"
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          sx={{
            width: '80%',
            maxWidth: '420px',
            input: { color: '#111' },
            '& .MuiOutlinedInput-root': {
              borderRadius: '12px',
              backgroundColor: '#fff',
              boxShadow: '0 0 0 2px rgba(56, 249, 215, 0.1)',
              '&.Mui-focused': {
                boxShadow: '0 0 0 2px rgba(56, 249, 215, 0.3)',
              }
            }
          }}
        />
      </Box>

      {error && (
        <Typography color="#ff3b30" textAlign="center" mb={2}>
          {error}
        </Typography>
      )}

      <Box
        sx={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))',
          gap: '2rem',
        }}
      >
        {filteredData.length > 0 ? (
          filteredData.map((record, index) => (
            <Box
              key={index}
              onClick={() => setSelectedRecord(record)}
              sx={{
                background: 'linear-gradient(135deg, #f6d365 0%, #fda085 100%)',
                borderRadius: '20px',
                padding: '1.5rem',
                color: '#fff',
                backdropFilter: 'blur(20px)',
                boxShadow: '0 6px 20px rgba(0,0,0,0.15)',
                cursor: 'pointer',
                transition: 'transform 0.3s ease, box-shadow 0.3s ease',
                '&:hover': {
                  transform: 'scale(1.03)',
                  boxShadow: '0 8px 28px rgba(0,0,0,0.25)',
                },
              }}
            >
              <Typography variant="h6" fontWeight={600} gutterBottom>
                🧍 {record.user_id}
              </Typography>
              <Typography sx={{ color: '#fafafa', fontWeight: 500 }}>
                Activity: {record.activity}
              </Typography>
              {record.timestamp && (
                <Typography sx={{ mt: 1, fontSize: '0.9rem', opacity: 0.9 }}>
                  🕒 {new Date(record.timestamp).toLocaleString()}
                </Typography>
              )}
            </Box>
          ))
        ) : (
          <Typography textAlign="center" fontSize="1.1rem" color="#999">
            No user activity found.
          </Typography>
        )}
      </Box>

      {/* DIALOG */}
      <Dialog
        open={!!selectedRecord}
        onClose={() => setSelectedRecord(null)}
        TransitionComponent={Fade}
        TransitionProps={{ timeout: 600 }}
        keepMounted
        PaperProps={{
          sx: {
            background: 'linear-gradient(135deg, #ffecd2 25%, #fcb69f 100%)',
            borderRadius: 4,
            padding: 4,
            minWidth: 600,
            color: '#333',
            boxShadow: '0 8px 40px rgba(0,0,0,0.3)',
            fontFamily: 'inherit',
          }
        }}
      >
        <DialogTitle sx={{ fontWeight: 'bold', fontSize: '2.8rem', color: '#4A148C' }}>
          ✨ User Activity Detail ✨
        </DialogTitle>
        <DialogContent>
          {selectedRecord && (
            <Box>
              <Typography variant="h5" fontWeight={600} gutterBottom>
                User Name: {selectedRecord.user_id}
              </Typography>
              <Typography fontSize="1.2rem" fontWeight={500} gutterBottom>
                Activity: {selectedRecord.activity}
              </Typography>
              {selectedRecord.timestamp && (
                <Typography fontSize="1rem" color="text.secondary">
                  🕒 {new Date(selectedRecord.timestamp).toLocaleString()}
                </Typography>
              )}
            </Box>
          )}
        </DialogContent>
      </Dialog>
    </Box>
  );
}