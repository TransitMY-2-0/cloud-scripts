var https = require('https');
var fs = require('fs');

var options = {
    'method': 'GET',
    'hostname': 'www.bing.com',
    'path': '/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US',
    'maxRedirects': 20
  };

var req = https.request(options, function (res) {
  var chunks = [];

  res.on("data", function (chunk) {
    chunks.push(chunk);
  });

  res.on("end", function (chunk) {
    var body = Buffer.concat(chunks);
    fs.writeFileSync("/home/kubuntu/scripts/wallpaperDownload/background.json", JSON.stringify(JSON.parse(body.toString()), null, 2));
    console.log("https://bing.com" + JSON.parse(body.toString()).images[0].url);
  });

  res.on("error", function (error) {
    console.error(error);
  });
});

req.end();