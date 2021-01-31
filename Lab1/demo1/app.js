const express = require("express");
const bodyParser = require("body-parser");

const app = express();

const port = process.env.PORT || 8080;

const dataArray = new Array();

app.use(
  bodyParser.urlencoded({
    extended: true,
  })
);

app.route("").get((req, res) => {
  res.send("Hello from Node.js RESTful API");
});

app.route("/msg").get((req,res)=>{
    return res.send({
        data: dataArray
    });
})

app.route("/msg").post((req, res) => {
  console.log('test')
  let msg = req.body.message;
  let count = 0;
  let length = dataArray.length;

  if (length != 0) {
    let hasMsg;
    for (let i = 0; i < dataArray.length; i++) {
      let textInArray = dataArray[i].text;
      if (textInArray == msg) {
        count = dataArray[i].count;
        count++;
        dataArray[i].count = count;
        hasMsg = true;
        break;
      } else {
        hasMsg = false;
      }
    }

    if (!hasMsg) {
      count++;
      dataArray.push({
        text: msg,
        count: count,
      });
    }
    return res.send({text: msg});
  } else {
    count++;
    dataArray.push({
      text: msg,
      count: count,
    });
    return res.send({text: msg});
  }
});

app.listen(port, () => {
  console.log("server is running on port: ", port);
});
