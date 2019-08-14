<tag-doc>
    <div class="filter-box">
        <div class="filter-text"><lang-text ref="Add_Keyword"></lang-text>:
            <input list="listedvisiblekeywords" ref="keyword" id="tags" onkeyup="{onTagKey}">
            <datalist id="listedvisiblekeywords">
                <option each={keyword in listedVisibleKeywords} value="{keyword}">{keyword}</option>
            </datalist>
        </div>
        <div class="filter-text"><lang-text ref="Add_Hidden_Keyword"></lang-text>:
            <input list="listedhiddenkeywords" ref="keyword" id="tags" onkeyup="{onTagHidKey}">
            <datalist id="listedhiddenkeywords">
                <option each={keyword in listedHiddenKeywords} value="{keyword}">{keyword}</option>
            </datalist>
        </div>
        <div class="filter-text"><lang-text ref="Date"></lang-text>: <input ref="datepicker" type="date" onChange="{onDateChange}"></div>
        <button onclick="{onDownloadClick}" ref="download" class="btn success"><i class="fa fa-fw fa-upload"></i> Download</button>
    </div>
    <script>
        const that = this;
        let allKeywords = [];
        let docKeywords = [];
        that.listedVisibleKeywords = [];
        that.listedHiddenKeywords = [];
        let documentLink = "";
        let documentName = "";

        function onData(data) {
            allKeywords = data.keywords;
            documentName = data.date + '_' + allKeywords.join('_');
            documentLink = data.pdfLocation;
            console.log('document link '+documentLink);
            let datepicker = that.refs.datepicker;
            datepicker.value = data.date;
            onKeywords(docKeywords);
            that.update();
        }

        function onVisibleKeywords(keywords) {
            docKeywords = keywords;
            that.listedVisibleKeywords = _(docKeywords).difference(allKeywords);
            that.update();
        }

        function onHiddenKeywords(keywords) {
            docKeywords = keywords;
            that.listedHiddenKeywords = _(docKeywords).difference(allKeywords);
            that.update();
        }

        this.onDownloadClick = e => {
            var a = document.createElement("a");
            a.href = documentLink;
            a.download = documentName;
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


        this.onTagHidKey = e => {

            if (e.which == 13) {

                let request = {
                    url: 'api/',
                    data: {
                        method: 'addHiddenKeyword',
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
            docStore.trigger('loadKeywords', {});
            docStore.trigger('loadHiddenKeywords');
            docStore.on('keywords', onVisibleKeywords);
            docStore.on('hiddenKeywords', onHiddenKeywords);

            that.refs.keyword.focus();
        });


    </script>
</tag-doc>
