<doc-list>
    <div id="documents">
        <div class="doc" each="{doc in docsFiltered}">
            <div class="info-box">
                <div class="date">{doc.date}</div>
                <div class="keyword">{doc.keywords}</div>
            </div>
            <div class="img-box"><a href="edit.html?fileID={doc.id}"><img src="{doc.tumbnail}"></a></div>
        </div>
        <div class="bottom-button-container" if="{docs.length > chunkLimit * chunkCount}">
            <Button onclick="{onLoadMoreClick}" class="btn default">Load more...</Button>
        </div>
    </div>
    <script>
        const that = this;
        this.docs = [];
        this.docsFiltered = [];
        this.chunkLimit = 3;
        this.chunkCount = 1;

        function onData(data){
            that.docs = data;
            that.docsFiltered = that.docs.slice(0, that.chunkCount * that.chunkLimit);
            that.update();
        }

        this.onLoadMoreClick = e => {
            that.docsFiltered = that.docs.slice(0, ++that.chunkCount * that.chunkLimit);
            that.update();
        };

        this.on('mount', function(){
            docStore.trigger('loadDocs', {});
            docStore.on('docs', onData);
        });

    </script>
</doc-list>
