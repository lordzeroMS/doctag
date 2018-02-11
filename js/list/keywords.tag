<keywords>
    <div id="keywords" class="keywords">
        <button class="label {'selected' : isSelected(keyword)}" onclick="{onKeywordClick}" each="{keyword in keywords}">{keyword}</button>
    </div>
    <script>
        const that = this;
        this.keywords = [];

        function onData(data){
            that.keywords = data;
            that.update();
        }

        function onFilterEmit(filter){
        	that.selected = filter.keyword;
        	that.update();
        }

        this.isSelected = keyword => {
            return  that.selected ? that.selected.indexOf(keyword) != -1 ? 'selected': '' : false;
        };

        this.onKeywordClick = e => {
            let keyword = e.item.keyword;
	        filterStore.trigger('toggle', {'keyword': keyword});
        };

        this.on('mount', function(){
            docStore.trigger('loadKeywords');
            docStore.on('keywords', onData);
            filterStore.on('emit', onFilterEmit);
        });
    </script>

</keywords>
