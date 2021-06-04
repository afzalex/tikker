curl -H @headers.txt "https://i.instagram.com/api/v1/feed/collection/17852729468262794/posts/?max_id=" | gunzip | jq

curl -sH @headers.txt "https://i.instagram.com/api/v1/feed/collection/17852729468262794/posts/?max_id=" | gunzip | jq >> output.json

cat output.json | jq '.items[].media.id'
curl -sH @headers.txt "https://i.instagram.com/api/v1/feed/collection/17909366908042779/posts/?max_id=" | gunzip | jq >> output.json
