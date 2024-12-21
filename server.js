const express = require('express');
const mysql = require('mysql2'); // Using mysql2 for better compatibility
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Create a connection to the MySQL database
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root', // Replace with your MySQL username
  password: 'your_password', // Replace with your MySQL password
  database: 'BiometricAttendance', // Replace with your database name
});

// Connect to the database
db.connect((err) => {
  if (err) {
    console.error('Database connection failed:', err);
    return;
  }
  console.log('Connected to MySQL Database');
});

// API to authenticate user
app.post('/api/login', (req, res) => {
  const { username, password } = req.body;
  const query = 'SELECT * FROM Users WHERE username = ? AND password_hash = ?';
  db.query(query, [username, password], (err, results) => {
    if (err) {
      res.status(500).json({ error: 'Server error' });
    } else if (results.length > 0) {
      res.json({ message: 'Login successful', user: results[0] });
    } else {
      res.status(401).json({ message: 'Invalid credentials' });
    }
  });
});

// API to fetch attendance
app.get('/api/attendance/:classId', (req, res) => {
  const classId = req.params.classId;
  const query = 'SELECT * FROM AttendanceRecords WHERE class_id = ?';
  db.query(query, [classId], (err, results) => {
    if (err) {
      res.status(500).json({ error: 'Server error' });
    } else {
      res.json(results);
    }
  });
});

// Start the server
app.listen(3000, () => {
  console.log('Server is running on port 3000');
});
