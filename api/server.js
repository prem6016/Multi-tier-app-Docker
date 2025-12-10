const express = require("express");
const cors = require("cors");
const app = express();

const PORT = process.env.PORT || 5000;
const PUBLIC_IP = process.env.PUBLIC_IP || "localhost";

app.use(cors());
app.use(express.json());

app.get("/api/health", (req, res) => {
  res.json({
    message: `API is running successfully! Public IP: ${PUBLIC_IP}`,
    status: "healthy",
    timestamp: new Date().toISOString(),
  });
});

app.get("/api/info", (req, res) => {
  res.json({
    service: "Backend API",
    port: PORT,
    publicIP: PUBLIC_IP,
    environment: process.env.NODE_ENV || "development",
  });
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`API server running on port ${PORT}`);
  console.log(`Public IP configured: ${PUBLIC_IP}`);
});
