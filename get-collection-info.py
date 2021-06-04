import json
import requests
import logging

logging.basicConfig(level=logging.ERROR)

logging.debug('Logging Debug Level')

collection_id = 17852729468262794

headers = {}
with open('headers.txt', 'r') as headers_file:
    logging.debug(headers_file.readline())
    for header in headers_file.read().split("\n"):
        headersplit = header.split(":", 1)
        if len(headersplit) > 1:
            headerKey = headersplit[0].strip()
            headerValue = headersplit[1].strip()
            headers[headerKey] = headerValue

max_id = ""


docontinue = 1
count = 0
while docontinue:
    with open('output/response.data', 'w+') as outputFile, open('output/shortcodes.data', 'w') as shortcodesFile, open(
            'output/summary.data', 'w') as summaryFile:
        collection_fetching_url = f"https://i.instagram.com/api/v1/feed/collection/{collection_id}/posts/?max_id={max_id}"
        logging.debug(collection_fetching_url)
        response = requests.get(collection_fetching_url, headers=headers)

        if response.status_code == 200:
            responseJson = response.json()
            # print(responseJson, file=outputFile)
            print(json.dumps(responseJson), file=outputFile)
            # print(responseJson["items"])
            for item in responseJson["items"]:
                # print(item["media"])
                print(item["media"]["code"], file=shortcodesFile)
                summary = "{}, {}, {}, {}, {}".format(count, item["media"]["id"], item["media"]["code"],
                                                      item["media"]["user"]["pk"], item["media"]["user"]["username"])
                print(summary)
                print(summary, file=summaryFile)
                count += 1
            max_id = json.dumps(responseJson["next_max_id"]).strip('"')
            shortcodesFile.flush()
            outputFile.flush()
            logging.debug(f"Next Max ID : {max_id}")
            docontinue = 1 if ("true" == json.dumps(responseJson["more_available"])) else 0
        else:
            logging.error("Error with status code : {}".format(response.status_code))
            logging.error(response.text)
            exit(1)
