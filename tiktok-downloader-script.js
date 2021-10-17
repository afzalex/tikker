(function () {

    function tikFunction(itemList, dataPointer, downloaded) {
        let vm = this;
        vm.logLevel = 0;
        let loadScript = vm.loadScript = function (url, onload) {
            let script = document.createElement("script");
            script.setAttribute("src", url);
            onload && (script.onload = onload);
            document.body.appendChild(script);
            return script
        }

        loadScript("https://code.jquery.com/jquery-3.6.0.js")

        let download = vm.download = function (url, filename, successHandler, errorHandler) {
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
                    if(successHandler) successHandler();
                };
                reader.readAsDataURL(blob);
            }).catch(err => {
                if(errorHandler) errorHandler(err);
            })
        }

        vm.dataPointer = 0;
        vm.itemList = [];
        vm.downloaded = [];

        if (dataPointer) {
            vm.dataPointer = dataPointer;
        }

        if (itemList) {
            vm.itemList = itemList;
        }

        if (downloaded) {
            vm.downloaded = downloaded;
        }

        vm.downloadNextVideo = function (force, successHandler, errorHandler) {
            let downloaded = vm.downloaded;
            let itemList = vm.itemList;
            let dataPointer = vm.dataPointer;
            if (dataPointer < itemList.length) {
                let item = itemList[dataPointer];
                let isNewToDownload = downloaded.indexOf(item.id) == -1;
                if (force || isNewToDownload) {
                    download(item.video.downloadAddr, item.id, () => {
                        successHandler && successHandler();
                        isNewToDownload && downloaded.push(item.id);
                    }, e => {
                        console.log(`%c Unable to download video of dataPointer ${dataPointer}`, 'color: #a00')
                    });
                    console.log(`%c Added video with dataPointer ${dataPointer} to download`, '')
                } else {
                    console.log(`%c Video of datapointer ${dataPointer} is present in downloaded list`, 'color: #a00');
                }
                showItemInfoForDataPointer(dataPointer);
                vm.dataPointer++;
            } else {
                console.log(`End of List | dataPointer : ${vm.dataPointer}`);
            }
            return vm.dataPointer;
        }

        vm.redownloadLastVideo = function () {
            vm.dataPointer--;
            let item = vm.itemList[vm.dataPointer];
            vm.downloadNextVideo(true);
        }

        vm.downloadNextNVideos = function(n, force) {
            if(!n) n = 10;
            for(let i = 0; i < n; i++) tik.downloadNextVideo(force)
        }
        vm.redownloadNextNVideos = function(n, force) {
            if(!n) n = 10;
            tik.dataPointer -= n;
            vm.downloadNextNVideos(n, force);
        }


        let showItemInfoForDataPointer = vm.showItemInfoForDataPointer = function (dataPointer, showIsDownloaded) {
            if(vm.logLevel == 0) {
                return;
            }

            let item = vm.itemList[dataPointer];
            if (!item) {
                console.log('Item not found')
                return
            }
            let op = ""
            op += `Video ID : ${item.id}\n`
            op += `Video Desc : ${item.desc}\n`
            op += `Author Name : ${item.author.nickname}\n`
            op += `Data Pointer : ${dataPointer}\n`
            showIsDownloaded && (op += `Is Downloaded : ${(vm.downloaded.indexOf(item.id) != -1)}`)
            console.log(op)
        }

        vm.showNextItemInfo = function () {
            showItemInfoForDataPointer(vm.dataPointer)
        }
        vm.showLastItemInfo = function () {
            showItemInfoForDataPointer(vm.dataPointer - 1);
        }

        vm.addNewData = function (newDataItemList) {
            let itemList = vm.itemList;
            let itemListPrevLength = itemList.length;
            newDataItemList.forEach(n => {
                if (itemList.findIndex(d => d.id == n.id) == -1) {
                    itemList.push(n)
                }
            });
            let itemListNewLength = itemList.length;
            console.log(`Old Size : ${itemListPrevLength}\nNew Size : ${itemListNewLength}\nNewly Added : ${itemListNewLength - itemListPrevLength}`)
        }

        vm.addDownloaded = function (newDownloadedList) {
            let downloaded = vm.downloaded;
            newDownloadedList.forEach(d => {
                if (downloaded.indexOf(d) == -1) {
                    downloaded.push(d);
                }
            })
            return downloaded.length;
        }

        let downloadObjectAsJson = vm.downloadObjectAsJson = function (itemList) {
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

        vm.setDataPointer = function (dataPointer) {
            vm.dataPointer = dataPointer;
            return vm.dataPointer;
        }
        vm.decrementDataPointer = function () {
            vm.dataPointer--;
            return vm.dataPointer;
        }
        vm.incrementDataPointer = function () {
            vm.dataPointer++;
            return vm.dataPointer;
        }
        vm.resetDataPointer = function () {
            vm.dataPointer = 0;
        }

        vm.resetDownloaded = function () {
            vm.downloaded = []
        }

        vm.downloadItemListJson = function () {
            downloadObjectAsJson(vm.itemList);
        }
    }
    let tik = new tikFunction();
    if (window.tik) {
        if (window.tik.dataPointer) {
            tik.dataPointer = window.tik.dataPointer;
        }
        if (window.tik.itemList) {
            tik.itemList = window.tik.itemList;
        }
        if (window.tik.downloaded) {
            tik.downloaded = window.tik.downloaded;
        }
    }
    window.tik = tik;


    console.log("%c tik is installed successfully.", "color: #070; font-weight: bold;");
    console.log("%c Command to get all downloaded array", "color: #888");
    console.log("%c ls | grep -E '^[0-9]+\.mp4$' |  grep -oE '^[0-9]+' | jq -ncR '[inputs]' | pbcopy", "color: black; font-family: monospace;")

})();