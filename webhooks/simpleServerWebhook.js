const https = require('https');
const fs = require("fs");
const credentials = require("./webhookCredentials");

if (process.argv.length < 6) {
    throw new String("Parameter count insufficient");
}

const params = process.argv.slice(2);

var msgColor = parseInt(params[0]);
var iconType = params[1].toLowerCase();
var msgTitle = params[2].toUpperCase();
var msgContent = params.slice(3).join(" ");

var options = {
    'method': 'POST',
    'hostname': credentials.hookURL.hostname,
    'path': "/api/webhooks/" + credentials.hookURL.hookID + "/" + credentials.hookURL.hookToken,
    'headers': {
        'Content-Type': 'application/json'
    },
    'maxRedirects': 20
};

// Getting the local datetime as an ISO string
var localISOTime = new Date(
    Date.now() -
    (new Date().getTimezoneOffset() * 60000)).toISOString().slice(0, -1);


var req = https.request(options, (res) => {
    var chunks = [];

    res.on("data", (chunk) => {
        chunks.push(chunk);
    });

    res.on("end", (chunk) => {
        var body = Buffer.concat(chunks);
        console.log(body.toString());
    });

    res.on("error", (error) => {
        fs.writeFileSync("./webhookErrorLog.log", localISOTime + error.stack);
        console.error(error);
    });
});


/**
 * For full syntax and options, refer to
 * https://discord.com/developers/docs/resources/webhook#execute-webhook
 */
var postData = JSON.stringify({
    "username": credentials.hookName,
    "avatar_url": credentials.hookAvatar,
    "embeds":[{
        "author": {
            "name": msgTitle,
            // Adding a little rickroll for fun here
            "url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
            "icon_url": credentials.images[iconType]
          },
          "description": msgContent ,
        "color": msgColor,
        "footer": {
            "text": localISOTime.replace("T", " ")
        }
    }]
});

req.write(postData);

req.end();