<keywords>
    <div id="keywords" class="keywords">
        <button ref="keyword" class="label" onclick="{onKeywordClick}" each="{keyword in keywords}">{keyword}</button>
    </div>
    <script>
        const that = this;

        function onData(data){
            that.keywords = data;
            that.update();
        }

        function onFilterEmit(filter){
            let keywords = that.refs.keyword;
            keywords.forEach( keyword => {
                if( keyword.innerText == filter.keyword ) {
                    keyword.classList.add('selected');
                }
                else {
                    keyword.classList.remove('selected');
                }
            });
        }

        this.onKeywordClick = e => {
            let keyword = e.item.keyword;
            // docStore.trigger('loadDocs', {'keyword': keyword});
            if( e.target.classList.contains('selected') ) {
                filterStore.trigger('remove', {'keyword': keyword});
            }
            else {
                filterStore.trigger('add', {'keyword': keyword});
            }
        };

        this.on('mount', function(){
            docStore.trigger('loadKeywords');
            docStore.on('keywords', onData);
            filterStore.on('emit', onFilterEmit);
        });
    </script>

</keywords>
