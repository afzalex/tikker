(function () {

    function tikFunction(itemList, dataPointer) {
        let loadScript = this.loadScript = function (url, onload) {
            let script = document.createElement("script");
            script.setAttribute("src", url);
            onload && (script.onload = onload);
            document.body.appendChild(script);
            return script
        }

        loadScript("https://code.jquery.com/jquery-3.6.0.js")

        let download = this.download = function (url, filename) {
            fetch(url).then(data => {
                const blob = data.blob();
                return blob;
            }).then(blob => {
                let reader = new window.FileReader();
                reader.onloadend = function () {
                    const data = reader.result;
                    var elem = window.document.createElement('a');
                    elem.href = data;
                    elem.download = filename;
                    document.body.appendChild(elem);
                    elem.click();
                    document.body.removeChild(elem);
                };
                reader.readAsDataURL(blob);
            })
        }

        this.dataPointer = 0;
        if (dataPointer) {
            this.dataPointer = dataPointer;
        }


        this.itemList = []
        if (itemList) {
            this.itemList = itemList;
        }

        this.downloaded = [];
        this.downloadNextVideo = function (force) {
            let downloaded = this.downloaded;
            let itemList = this.itemList;
            let dataPointer = this.dataPointer;
            if (dataPointer < itemList.length) {
                let item = itemList[dataPointer];
                if (force || downloaded.indexOf(item.id) == -1) {
                    download(item.video.downloadAddr, item.id, () => pointerDownloader(++dataPointer))
                    downloaded.push(item.id);
                } else {
                    console.log('%c Present in downloaded list.', 'color: #a00');
                }
                showItemInfoForDataPointer(dataPointer);
                this.dataPointer++;
            } else {
                console.log(`End of List | dataPointer : ${this.dataPointer}`);
            }
            return this.dataPointer;
        }

        this.redownloadLastVideo = function () {
            this.dataPointer--;
            let item = itemList[this.dataPointer];
            this.downloadNextVideo(true);
        }


        let showItemInfoForDataPointer = this.showItemInfoForDataPointer = function (dataPointer, showIsDownloaded) {
            let item = this.itemList[dataPointer];
            if (!item) {
                console.log('Item not found')
                return
            }
            let op = ""
            op += `Video ID : ${item.id}\n`
            op += `Video Desc : ${item.desc}\n`
            op += `Author Name : ${item.author.nickname}\n`
            op += `Data Pointer : ${dataPointer}\n`
            showIsDownloaded && (op += `Is Downloaded : ${(this.downloaded.indexOf(item.id) != -1)}`)
            console.log(op)
        }

        this.showNextItemInfo = function () {
            showItemInfoForDataPointer(this.dataPointer)
        }
        this.showLastItemInfo = function () {
            showItemInfoForDataPointer(this.dataPointer - 1);
        }

        this.addNewData = function (newDataItemList) {
            let itemList = this.itemList;
            let itemListPrevLength = itemList.length;
            newDataItemList.forEach(n => {
                if (itemList.findIndex(d => d.id == n.id) == -1) {
                    itemList.push(n)
                }
            });
            let itemListNewLength = itemList.length;
            console.log(`Old Size : ${itemListPrevLength}\nNew Size : ${itemListNewLength}\nNewly Added : ${itemListNewLength - itemListPrevLength}`)
        }

        this.addDownloaded = function (newDownloadedList) {
            let downloaded = this.downloaded;
            newDownloadedList.forEach(d => {
                if (downloaded.indexOf(d) == -1) {
                    downloaded.push(d);
                }
            })
            return downloaded.length;
        }

        let downloadObjectAsJson = this.downloadObjectAsJson = function (itemList) {
            let d = new Date(2010, 7, 5);
            let ye = new Intl.DateTimeFormat('en', { year: 'numeric' }).format(d);
            let mo = new Intl.DateTimeFormat('en', { month: 'short' }).format(d);
            let da = new Intl.DateTimeFormat('en', { day: '2-digit' }).format(d);
            let fileName = `tiktok_itemlist_${da}_${mo}_${ye}_${Date.now()}.json`;
            var dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(itemList));
            var downloadAnchorNode = document.createElement('a');
            downloadAnchorNode.setAttribute("href", dataStr);
            downloadAnchorNode.setAttribute("download", fileName);
            document.body.appendChild(downloadAnchorNode); // required for firefox
            downloadAnchorNode.click();
            downloadAnchorNode.remove();
        }

        this.setDataPointer = function (dataPointer) {
            this.dataPointer = dataPointer;
            return this.dataPointer;
        }
        this.decrementDataPointer = function () {
            this.dataPointer--;
            return this.dataPointer;
        }
        this.incrementDataPointer = function () {
            this.dataPointer++;
            return this.dataPointer;
        }
        this.resetDataPointer = function () {
            this.dataPointer = 0;
        }

        this.resetDownloaded = function () {
            this.downloaded = []
        }

        this.downloadItemListJson = function () {
            downloadObjectAsJson(this.itemList);
        }
    }

    if (typeof window.itemList === 'undefined') {
        window.itemList = []
    }
    window.tik = new tikFunction(itemList);
    window.tik.setDataPointer(0);


    console.log("%c tik is installed successfully.", "color: #070; font-weight: bold;");
    console.log("%c Command to get all downloaded array", "color: #888");
    console.log("%c ls | grep -E '^[0-9]+\.mp4$' |  grep -oE '^[0-9]+' | jq -ncR '[inputs]' | pbcopy", "color: black; font-family: monospace;")

})();