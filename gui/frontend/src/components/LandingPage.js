import React from "react";
import Button from "react-bootstrap/Button";
import { useNavigate } from "react-router-dom";

function LandingPage() {
  const navigate = useNavigate();
  return (
    <div className="d-flex flex-column align-items-center justify-content-center vh-100 text-center">
      <h1 className="mb-4">Welcome to Food Outlets Management System</h1>
      <div className="d-flex justify-content-center">
        <Button
          variant="primary"
          className="mb-2 me-3"
          onClick={() => navigate("/signup")}
        >
          Sign Up
        </Button>
        <Button
          variant="primary"
          className="mb-2 me-3"
          onClick={() => navigate("/login")}
        >
          User Login
        </Button>
        <Button
          variant="primary"
          className="mb-2"
          onClick={() => navigate("/admin")}
        >
          Admin Login
        </Button>
      </div>
    </div>
  );
}

export default LandingPage;
