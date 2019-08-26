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
                let request = {
                    url: 'api/',
                    data: {
                        method: "removeKeyword",
                        fileID: params.fileID,
                        keyword: keyword
                    }
                };

                getData(request).then(function(response) {
                            if (response.status !== 200) {
                                console.error('Looks like there was a problem. Status Code: ' + response.status);
                                return;
                            }
                            else {
                                docDetailStore.trigger('loadDocDetails');
                                tagStore.trigger('loadTags');
                                docStore.trigger('loadKeywords', {});
                                docStore.trigger('loadHiddenKeywords', {});
                            }
                        }
                    )
                    .catch(function(err) {
                        console.error('Fetch Error :-S', err);
                    });
            }
        };

        this.on('mount', function(){
            docDetailStore.on('docDetails', onData);
        });
    </script>
</keywords>
