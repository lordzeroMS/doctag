<keywords>
    <div id="keywords" class="keywords">
        <button each="{keyword in keywords}" onclick="{onKeywordClick}"> {keyword}</button>
    </div>
    <script>
        const that = this;

        function onData(data){
            that.keywords = data.keywords;
            that.update();
        };

        this.onKeywordClick = e => {
            let keyword =e.item.keyword;
            var box = window.confirm("Should '" + keyword + "' be removed?");
            if (box == true) {
                // HACK: params is from global scope
                $.get("api", {
                    method: "removeKeyword",
                    fileID: params.fileID,
                    keyword: keyword
                })
                .done((data,success)=>{
                    if( success == 'success'){
                        docDetailStore.trigger('loadDocDetails');
                        tagStore.trigger('loadTags');
                    }
                });
            }
        };

        this.on('mount', function(){
            docDetailStore.on('docDetails', onData);
        });
    </script>
</keywords>
