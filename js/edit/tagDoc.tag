<tag-doc>
    <div class="filter-box">
        <div class="filter-text">Add Keyword: <input id="tags" onkeyup="{onTagKey}"></div>
        <div class="filter-text">Date: <input type="text" id="datepicker"></div>
    </div>
    <script>
        const that = this;
        this.date = '';


        function onData(data){
            $("#datepicker").val(data.date);
            that.update();
        }

        this.onTagKey = e => {
            if (event.which == 13) {
                $.get("api", {method: "addKeyword", fileID: params.fileID, keyword: e.target.value})
                    .done(function (data,resp) {
                        if(resp == 'success'){
                            e.target.value = '';
                            docDetailStore.trigger('loadDocDetails');
                        }
                    });

            }
        };

        this.on('mount', function(){
            docDetailStore.on('docDetails', onData);

            $.datepicker.setDefaults($.datepicker.regional["de"]);

            $("#datepicker").datepicker({dateFormat: 'yy-mm-dd'}).bind("change", function () {
                // HACK: params comes from global scope
                $.get("api", {method: "updateDate", fileID: params.fileID, date: $("#datepicker").val()});
            });
        });


    </script>
</tag-doc>
