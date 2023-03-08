import express from "express";
import db from "./db/db";
import bodyParser from "body-parser";
// Set up the express app
const app = express();
// get all todos
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
const PORT = 5000;

app.get("/getScans",(req,res)=>{
res.status(200).send(db);
});

app.post("/logScan", (req, res) => {
  const currentTime =  Date.now();
  const body = req.body;
  body.finalLatency = currentTime - body.latency;
  delete body.latency;
  body.dateOfScan = new Date()

  console.log(body);
  db.push(body);
  return res.status(204).send();
});

app.listen(PORT, () => {
  console.log(`server running on port ${PORT}`);
});
