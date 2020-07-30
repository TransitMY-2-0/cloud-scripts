var Jimp = require("jimp");
var fs = require("fs");

var fileName = '/home/kubuntu/scripts/wallpaperDownload/background.jpg';
var loadedImage;

const myJSON = JSON.parse(fs.readFileSync("/home/kubuntu/scripts/wallpaperDownload/background.json", "utf-8").toString());
const imageCaption = myJSON.images[0].title + ": " + myJSON.images[0].copyright;
const history = JSON.parse(fs.readFileSync("/home/kubuntu/scripts/wallpaperDownload/history/details.json", "utf-8").toString());

console.log(imageCaption);

var object = {};
const imageDetails = myJSON.images[0];
object.fileName = "wallpaper-" + imageDetails.enddate + ".jpg";
object.url = "https://www.bing.com/" + imageDetails.url;
object.title = imageDetails.title;
object.caption = imageDetails.copyright;
history.push(object);
fs.writeFileSync("/home/kubuntu/scripts/wallpaperDownload/history/details.json", JSON.stringify(history, null, 2));


Jimp.read(fileName)
    .then(function (image) {
        loadedImage = image;
        return Jimp.loadFont(Jimp.FONT_SANS_16_WHITE);
    })
    .then(function (font) {
        loadedImage.print(font, 10, 10, imageCaption)
                   .write(fileName);
    })
    .catch(function (err) {
        console.error(err);
    });