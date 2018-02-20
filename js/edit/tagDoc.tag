<tag-doc>
    <div class="filter-box">
        <div class="filter-text">Add Keyword:
            <input list="listedkeywords" ref="keyword" id="tags" onkeyup="{onTagKey}">
            <datalist id="listedkeywords">
                <option each={keyword in listedKeywords} value="{keyword}">{keyword}</option>
            </datalist>
        </div>
        <div class="filter-text">Date: <input ref="datepicker" type="date" onChange="{onDateChange}"></div>
    </div>
    <script>
        const that = this;
        let allKeywords = [];
        let docKeywords = [];
        that.listedKeywords = [];

        function onData(data) {
            allKeywords = data.keywords;
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


        this.onTagKey = e => {
            if (e.which == 13) {
                $.get("api", {method: "addKeyword", fileID: params.fileID, keyword: e.target.value})
                    .done(function (data, resp) {
                        if (resp == 'success') {
                            e.target.value = '';
                            docDetailStore.trigger('loadDocDetails');
                            // HACK: comes from global navBar.tag
                            tagStore.trigger('loadTags');
                        }
                    });
            }
        };

        this.onDateChange = e => {
            $.get("api", {method: "updateDate", fileID: params.fileID, date: e.target.value})
                .done((data, success) => {
                    if (success == 'success') tagStore.trigger('loadTags');
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
