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
    try{
        var result =  await queries.getPhones(req,res);
        res.status(200,result)
    }
    catch(ex)
    {
        res.status(500,ex);
    }
});

app.post("/add-phone", async (req, res, next) => {
    try{
        var result =  await queries.addPhone(req,res);
        res.status(200,result)
    }
    catch(ex)
    {
        res.status(500,ex);
    }
});