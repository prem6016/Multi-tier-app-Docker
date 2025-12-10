import React, { useState, useEffect } from "react";
import axios from "axios";
import "./App.css";

const API_URL = process.env.REACT_APP_API_URL || "http://localhost:5000";

function App() {
  const [message, setMessage] = useState("Loading...");
  const [status, setStatus] = useState("connecting");

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await axios.get(`${API_URL}/api/health`);
        setMessage(response.data.message);
        setStatus("connected");
      } catch (error) {
        setMessage("Failed to connect to API");
        setStatus("error");
        console.error("API Error:", error);
      }
    };

    fetchData();
    const interval = setInterval(fetchData, 5000);
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="App">
      <div className="container">
        <h1>Multi-Tier Application</h1>
        <div className={`status ${status}`}>
          <div className="status-indicator"></div>
          <p className="status-text">{status.toUpperCase()}</p>
        </div>
        <div className="message-box">
          <p>{message}</p>
        </div>
        <div className="info">
          <p>Frontend: Port 8080</p>
          <p>API: Port 5000</p>
        </div>
      </div>
    </div>
  );
}

export default App;
