import React from "react";
import { Tabs, Tab } from "react-bootstrap";

function Home() {
  return (
    <div className="d-flex justify-content-center mt-5">
      <Tabs
        defaultActiveKey="restaurants"
        id="uncontrolled-tab-example"
        className="mb-3"
      >
        <Tab eventKey="restaurants" title="Restaurants">
          {/* Add your Restaurants content here... */}
        </Tab>
        <Tab eventKey="dashboard" title="Dashboard">
          {/* Add your Dashboard content here... */}
        </Tab>
      </Tabs>
    </div>
  );
}

export default Home;
