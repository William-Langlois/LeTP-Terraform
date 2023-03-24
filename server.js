var express = require("express");
const bodyParser = require('body-parser')
const { Client } = require('pg')

const queries = require("./queries")


var app = express();
app.use(bodyParser.json())
app.use(
  bodyParser.urlencoded({
    extended: true,
  })
)

app.listen(process.env.PORT, () => {
 console.log("Server running on port",process.env.PORT);
});

const phones = ["Iphone","Alcatel"]
//TODO : turn into postgres
app.get("/get-phones", async(req, res, next) => {
    queries.getPhones(req,res);
});

app.post("/add-phone", async (req, res, next) => {
    queries.addPhone(req,res);
});