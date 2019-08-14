<doc-filter>
    <div class="filter-box">
        <div class="filter-text"><lang-text ref="Date_From"></lang-text>: <input type="date" ref="datefrom" oninput="{onDateFromInput}"></div>
        <div class="filter-text"><lang-text ref="Date_To"></lang-text>: <input type="date" ref="dateto" oninput="{onDateToInput}"></div>
        <div class="filter-text"><lang-text ref="Hidden_Keyword"></lang-text>:
            <input list="listedkeywords" type="text" ref="searchfieldkeyword" onkeydown="{onSearchKeywordKeydown}">
            <datalist id="listedkeywords">
                <option each={keyword in listedKeywords} value="{keyword}">{keyword}</option>
            </datalist>
        </div>
        <div class="filter-text"><lang-text ref="Search"></lang-text>: <input type="text" ref="searchfield" onkeydown="{onSearchKeydown}"></div>
        <div class="btn-container">
            <button id="reset_date" click="{onResetClick}" class="btn default">Reset</button>
        </div>
    </div>
    <script>
        const that = this;
        that.listedKeywords = [];

        this.onResetClick = () => {
            filterStore.trigger('init');
        };

        function onData({dateFrom:from = '', dateTo:to = '', searchValue:search = '', searchKeyword:searchkey = ''}){
            that.refs.datefrom.value = from;
            that.refs.dateto.value = to;
            that.refs.searchfield.value = search;
            that.refs.searchfieldkeyword.value = searchkey;
        }

        function onKeywords(keywords) {
            that.listedKeywords = keywords;
            that.update();
        }

        this.onSearchKeywordKeydown = e => {
            if (e.keyCode == 13) {
                filterStore.trigger('add', {'searchKeyword': e.target.value})
            }
        };

        this.onSearchKeydown = e => {
            if (e.keyCode == 13) {
                filterStore.trigger('add', {'searchValue': e.target.value})
            }
        };

        this.onDateFromInput = e => {
            filterStore.trigger('add', {'dateFrom': e.target.value})
        };

        this.onDateToInput = e => {
            filterStore.trigger('add', {'dateTo': e.target.value})
        };

        this.on('mount', () => {
            filterStore.on('emit', onData );
            docStore.trigger('loadHiddenKeywords', {});
            docStore.on('hiddenKeywords', onKeywords);
        });

    </script>
</doc-filter>
