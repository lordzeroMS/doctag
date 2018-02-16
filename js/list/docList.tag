<doc-list>
    <div id="documents">
        <div class="doc" each="{doc in docsFiltered}">
            <a href="edit.html?fileID={doc.id}">
                <div class="info-box">
                    <div class="date">{doc.date}</div>
                    <div class="keyword">{doc.keywords}</div>
                </div>
                <div class="img-box"><img src="{doc.tumbnail}">
                    <i class="fa fa-search-plus" onmouseover="{showZoomed}" onmouseleave="{hideZoomed}"></i>
                </div>
            </a>
        </div>

        <div class="bottom-button-container" if="{docs.length > chunkLimit * chunkCount}">
            <Button onclick="{onLoadMoreClick}" class="btn default">Load more...</Button>
        </div>
    </div>
    <div ref="zoomed-box" class="zoomed">
        <img ref="zoomed-img" src="" alt="">
    </div>
    <script>
        const that = this;
        this.docs = [];
        this.docsFiltered = [];
        this.chunkLimit = 50;
        this.chunkCount = 1;
        let timeout = null;

        this.showZoomed = e => {
            timeout = setTimeout( ()=> {
                let img = that.refs['zoomed-img'];
                let box = that.refs['zoomed-box'];
                img.src = e.item.doc.tumbnail;
                box.classList.add('show-zoomed');
            },100);
        };

        this.hideZoomed = e => {
            clearTimeout(timeout);
            let box = that.refs['zoomed-box'];
            box.classList.remove('show-zoomed');
        };

        function onData(data){
	        that.chunkCount = 1;
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
