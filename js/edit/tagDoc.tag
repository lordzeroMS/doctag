<tag-doc>
    <div class="filter-box">
        <div class="filter-text">Add Keyword:
            <input list="listedkeywords" ref="keyword" id="tags" onkeyup="{onTagKey}">
            <datalist id="listedkeywords">
                <option each={keyword in listedKeywords} value="{keyword}">{keyword}</option>
            </datalist>
        </div>
        <div class="filter-text">Date: <input ref="datepicker" type="date" onChange="{onDateChange}"></div>
        <button onclick="{onDownloadClick}" ref="download" class="btn success"><i class="fa fa-fw fa-upload"></i> Download</button>
    </div>
    <script>
        const that = this;
        let allKeywords = [];
        let docKeywords = [];
        that.listedKeywords = [];
        let document_link = "";
        let document_name = "";

        function onData(data) {
            allKeywords = data.keywords;
            document_name = data.date + '_' + allKeywords.join('_');
            document_link = data.pdfLocation;
            console.log('document link '+document_link);
            let datepicker = that.refs.datepicker;
            datepicker.value = data.date;
            onKeywords(docKeywords);
            that.update();
        }

        function onKeywords(keywords) {
            docKeywords = keywords;
            that.listedKeywords = _(docKeywords).difference(allKeywords);
            that.update();
        }

        this.onDownloadClick = e => {
            var a = document.createElement("a");
            a.href = document_link;
            a.download = document_name;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
        };


        this.onTagKey = e => {

            if (e.which == 13) {

                let request = {
                    url: 'api/',
                    data: {
                        method: 'addKeyword',
                        fileID: params.fileID,
                        keyword: e.target.value
                    }
                };

                getData(request).then( function(response) {
                            if (response.status !== 200) {
                                console.error('Looks like there was a problem. Status Code: ' + response.status);
                                return;
                            }
                            else {
                                e.target.value = '';
                                docDetailStore.trigger('loadDocDetails');
                                // HACK: comes from global navBar.tag
                                tagStore.trigger('loadTags');
                            }
                        }
                    )
                    .catch(function(err) {
                        console.error('Fetch Error :-S', err);
                    });


            }
        };

        this.onDateChange = e => {

            let request = {
                url: 'api/',
                data: {
                    method: 'updateDate',
                    fileID: params.fileID,
                    date: e.target.value
                }
            };

            getData(request).then( function(response) {
                        if (response.status !== 200) {
                            console.error('Looks like there was a problem. Status Code: ' + response.status);
                            return;
                        }
                        else {
                            tagStore.trigger('loadTags');
                        }
                    }
                )
                .catch(function(err) {
                    console.error('Fetch Error :-S', err);
                });

        };

        this.on('mount', function () {
            docDetailStore.on('docDetails', onData);
            let docStore = new DocStore();
            docStore.trigger('loadKeywords');
            docStore.on('keywords', onKeywords);

            that.refs.keyword.focus();
        });


    </script>
</tag-doc>
