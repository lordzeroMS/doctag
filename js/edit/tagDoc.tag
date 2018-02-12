<tag-doc>
    <div class="filter-box">
        <div class="filter-text">Add Keyword: <input id="tags" onkeyup="{onTagKey}"></div>
        <div class="filter-text">Date: <input type="text" id="datepicker"></div>
    </div>
    <script>
        const that = this;

        function onData(data){
            $("#datepicker").val(data.date);
            that.update();
        }

        function onKeywords(keywords){
            $( "#tags" ).autocomplete({
                source: keywords
            });
        }

        this.onTagKey = e => {
            if (event.which == 13) {
                $.get("api", {method: "addKeyword", fileID: params.fileID, keyword: e.target.value})
                    .done(function (data,resp) {
                        if(resp == 'success'){
                            e.target.value = '';
                            docDetailStore.trigger('loadDocDetails');
                            // HACK: comes from global navBar.tag
                            tagStore.trigger('loadTags');
                        }
                    });
            }
        };

        this.on('mount', function(){
            docDetailStore.on('docDetails', onData);
            let docStore = new DocStore();
            docStore.trigger('loadKeywords');
            docStore.on('keywords', onKeywords);

            $.datepicker.setDefaults($.datepicker.regional["de"]);


            $("#datepicker").datepicker({dateFormat: 'yy-mm-dd'}).bind("change", function () {
                // HACK: params comes from global scope
                $.get("api", {method: "updateDate", fileID: params.fileID, date: $("#datepicker").val()})
                .done((data,success)=>{
                    if(success == 'success') tagStore.trigger('loadTags');
                });

            });
        });


    </script>
</tag-doc>
