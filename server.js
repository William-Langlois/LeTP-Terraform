var express = require("express");
var app = express();app.listen(443, () => {
 console.log("Server running on port 443");
});

const phones = ["Iphone","Alcatel"]
//TODO : turn into postgres
app.get("/get-phones", (req, res, next) => {
res.json(
        phones
    );
});

app.post("/add-phone", (req, res, next) => {
    phones = phone+req.body;
    //Add rabbit mq
});