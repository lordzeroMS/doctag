<doc-filter>
    <div class="filter-box">
        <div class="filter-text">Date From: <input type="date" ref="datefrom" oninput="{onDateFromInput}"></div>
        <div class="filter-text">Date To: <input type="date" ref="dateto" oninput="{onDateToInput}"></div>
        <div class="filter-text">Search: <input type="text" ref="searchfield" onkeydown="{onSearchKeydown}"></div>
        <div class="btn-container">
            <button id="reset_date" click="{onResetClick}" class="btn default">Reset</button>
        </div>
    </div>
    <script>
        const that = this;
        this.onResetClick = () => {
            filterStore.trigger('init');
        };

        function onData({dateFrom:from = '', dateTo:to = '', searchValue:search = ''}){
            that.refs.datefrom.value = from;
            that.refs.dateto.value = to;
            that.refs.searchfield.value = search;
        }

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
        });

    </script>
</doc-filter>
