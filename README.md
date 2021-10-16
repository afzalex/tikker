
### Copy below in console for tiktok
```js
fetch("https://afzalex.github.io/tikker/tiktok-downloader-script.js")
    .then(response => response.text())
    .then(text => eval(text));
```
[Link to tiktok-downloader-script.js](https://afzalex.github.io/tikker/tiktok-downloader-script.js)


### Files that could be used for insta
To get all new data into /output/general/**
```sh
get-collection-info.sh 
```


To download videos from all collected info
```sh
dounloader.sh
```

To download frames of all videos
```sh
get-frames.sh
```


```sh
curl -H @headers.txt "https://i.instagram.com/api/v1/feed/collection/17852729468262794/posts/?max_id=" | gunzip | jq

curl -sH @headers.txt "https://i.instagram.com/api/v1/feed/collection/17852729468262794/posts/?max_id=" | gunzip | jq >> output.json

cat output.json | jq '.items[].media.id'
curl -sH @headers.txt "https://i.instagram.com/api/v1/feed/collection/17909366908042779/posts/?max_id=" | gunzip | jq >> output.json
```


Create an anchor to some inline data...
```js
var url = 'https://cdn.shopify.com/s/files/1/1303/8383/files/DSC_0087_large.jpg?v=1560971564';
var anchor = document.createElement('a');
    anchor.setAttribute('href', url);
    anchor.setAttribute('download', 'myNote.txt');
```

Click the anchor
```js
// This works in Chrome, not in Firefox
$(anchor)[0].click();

// For Firefox, we need to manually do a click event

// Create event
var ev = document.createEvent("MouseEvents");
    ev.initMouseEvent("click", true, false, self, 0, 0, 0, 0, 0, false, false, false, false, 0, null);

// Fire event
anchor.dispatchEvent(ev);
```




```
//build the new URL
var my_url = 'https://cdn.shopify.com/s/files/1/1303/8383/files/DSC_0087_large.jpg?v=1560971564';
//load it into a hidden iframe
var iframe = $("<iframe/>").attr({
    src: my_url,
}).appendTo($('body'));
```
