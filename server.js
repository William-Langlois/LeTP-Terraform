var express = require("express");
const bodyParser = require('body-parser')

const queries = require("./queries")

var app = express();
app.use(bodyParser.json())

app.use(
  bodyParser.urlencoded({
    extended: true,
  })
)

app.listen(process.env.PORT | 3000, () => {
 console.log("Server running on port",process.env.PORT | 3000);
});

app.get("/get-phones", (req, res, next) => {
    queries.getPhones(req,res);
});

app.post("/add-phone", (req, res, next) => {
    queries.addPhone(req,res);
});