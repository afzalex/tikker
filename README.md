## Copy below in console for tiktok

```js
fetch("https://afzalex.github.io/tikker/tiktok-downloader-script.js?v=05")
    .then(response => response.text())
    .then(text => eval(text));
```

[Link to tiktok-downloader-script.js](https://afzalex.github.io/tikker/tiktok-downloader-script.js)

Command to get downloaded array

```
ls | grep -E '^[0-9]+\.mp4$' |  grep -oE '^[0-9]+' | jq -ncR '[inputs]' | pbcopy
```

## Files that could be used for insta

To get all new data into /output/general/**

```sh
get-collection-info.sh 
```

To download videos from all collected info

```sh
downloader.sh
```

To download frames of all videos

```sh
get-frames.sh
```

## Other information
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


## Useful commands
```
ffmpeg -i theme_video.mp4 -i theme_audio.mp3 -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -ss 28 -t 5 -y theme_pre1.mp4 && ffmpeg -i theme_pre1.mp4 -af "volume=0:enable='between(t,1,3)'" -y theme_pre.mp4 && ffplay -autoexit theme_pre.mp4

ffmpeg -i theme_video.mp4 -i theme_audio.mp3 -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -ss 28 -t 5 -y theme_pre1.mp4
ffmpeg -i theme_pre1.mp4 -af "volume=0:enable='between(t,1,3)'" -max_muxing_queue_size 1024 -y theme_pre.mp4


ffmpeg -i theme_video.mp4 -i theme_audio.mp3 -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -ss 28 -t 8 -y theme_pre1.mp4
ffmpeg -i theme_pre1.mp4 -af "volume=0:enable='between(t,1,3)'" -max_muxing_queue_size 1024 -y theme_pre.mp4
ffplay -autoexit theme_pre.mp4


ffmpeg -i theme_video.mp4 -i theme_audio.mp3 -c:v libx264 -c:a aac -map 0:v:0 -map 1:a:0 -ss 28 -t 8 -y theme_pre1.mp4


TARGET_FILE_NAME=theme_pre_short.mp4
ffmpeg -i theme_video.mp4 -i theme_audio.mp3 -c:v libx264 -c:a aac -map 0:v:0 -map 1:a:0 -ss 28 -t 4 -y "${TARGET_FILE_NAME}"
mv "${TARGET_FILE_NAME}" temp.mp4
ffmpeg -i temp.mp4 -af "volume=0.5:enable='between(t,2.5,3)', volume=0.25:enable='between(t,3,3.5)', volume=0.14:enable='between(t,3.5,4)'" -max_muxing_queue_size 1024 -y "${TARGET_FILE_NAME}"
ffplay -autoexit "${TARGET_FILE_NAME}"


SOURCE_VID=source_01.mp4
OUTPUT_VID=output_01.mp4
ffmpeg -i "${TARGET_FILE_NAME}" -i "${SOURCE_VID}" -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1 [v] [a]" -map "[v]" -map "[a]" -y "${OUTPUT_VID}"




ffprobe -v 32 source_01.mp4  2>&1

ffmpeg -i "${TARGET_FILE_NAME}" -i "${SOURCE_VID}" -filter_complex "[0:v] [0:a] [1:v] [1:a] concat=n=2:v=1:a=1 [v] [a]; [v]scale=720:1280[v2]" -map "[v2]" -map "[a]" -y "${OUTPUT_VID}"
ffmpeg -i "${TARGET_FILE_NAME}" -i "${SOURCE_VID}" -filter_complex "[0:v:0]scale=720:1280[v0]; [v0][0:a][1:v][1:a] concat=n=2:v=1:a=1[v][a]" -map "[v]" -map "[a]" -y "${OUTPUT_VID}"
ffmpeg -i "${TARGET_FILE_NAME}" -i "${SOURCE_VID}" -filter_complex "[0:v:0]crop=720:1280:0:0[v0]; [v0][0:a][1:v][1:a] concat=n=2:v=1:a=1[v][a]" -map "[v]" -map "[a]" -y "${OUTPUT_VID}"
ffmpeg -i "${TARGET_FILE_NAME}" -i "${SOURCE_VID}" -filter_complex "[0:v:0]scale=-1:1280[v1]; [v1]crop=720:1280:0:0[v0]; [v0][0:a][1:v][1:a] concat=n=2:v=1:a=1[v][a]" -map "[v]" -map "[a]" -y "${OUTPUT_VID}"

ffmpeg -i "${TARGET_FILE_NAME}" -i "${SOURCE_VID}" -i "input_noise.mp3" -filter_complex "[0:v:0]scale=-1:1280[v1]; [v1]crop=720:1280:0:0[v0]; [v0][0:a][1:v][1:a] concat=n=2:v=1:a=1[v][a]" -map "[v]" -map "[a]" -y "${OUTPUT_VID}"
ffplay -autoexit "${OUTPUT_VID}"

ffmpeg -i input1.mp4 -i input2.mp4 -filter_complex \
"[0:v]scale=1024:576:force_original_aspect_ratio=1[v0]; \ 
 [1:v]scale=1024:576:force_original_aspect_ratio=1[v1]; \
 [v0][0:a][v1][1:a]concat=n=2:v=1:a=1[v][a]" -map [v] -map [a] output.mp4

ffmpeg -i d:\1.mp4 -i d:\2.mp4 -filter_complex "concat=n=2:v=1:a=1 [v] [a]; \
[v]scale=320:200[v2]" -map "[v2]" -map "[a]" d:\3.mp4

----
ls *.mp4| head -n 50 | while read line; do echo 
ffmpeg -i $line.mp4 -filter_complex "[0:v]setpts=1*PTS[v];[0:a]atempo=1.1[a]" -map "[v]" -map "[a]" $line;
done;

ffmpeg -i _shiyya__2474177348860379803_5776153997.mp4 -filter_complex "[0:v]setpts=1*PTS[v];[0:a]atempo=1.1[a]" -map "[v]" -map "[a]" output.mp4
```