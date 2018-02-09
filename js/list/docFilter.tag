<doc-filter>
    <div class="filter-box">
        <div class="filter-text">Date From: <input type="text" id="datepicker_from"></div>
        <div class="filter-text">Date To: <input type="text" id="datepicker_to"></div>
        <div class="filter-text">Search: <input type="text" id="search_field"></div>
        <div class="btn-container">
            <button id="reset_date" click="{onResetClick}" class="btn default">Reset</button>
        </div>
    </div>
    <script>

        this.onResetClick = () => {
            filterStore.trigger('init');
        };

        function onData(data){
            $("#datepicker_from").val(data.dateFrom);
            $("#datepicker_to").val(data.dateTo);
            $("#search_field").val(data.searchValue);
        }

        this.on('mount', () => {
            filterStore.on('emit', onData );

            $.datepicker.setDefaults($.datepicker.regional["de"]);

            $("#datepicker_from").datepicker({dateFormat: 'yy-mm-dd'}).bind("change", function (e) {
                filterStore.trigger('add', {'dateFrom': this.value})
            });

            $("#datepicker_to").datepicker({dateFormat: 'yy-mm-dd'}).bind("change", function () {
                filterStore.trigger('add', {'dateTo': this.value})
            });

            $("#search_field").on('keyup', function (e) {
                if (e.keyCode == 13) {
                    filterStore.trigger('add', {'searchValue': this.value})
                }
            });

        });

    </script>
</doc-filter>
