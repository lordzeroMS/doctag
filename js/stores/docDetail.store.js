function DocDetailStore(){
    riot.observable(this);
    this.doc = {};
    const that = this;


    this.on('loadDocDetails', filter => {
        $.getJSON("api/index.php?method=detailsPDF&fileID=" + params.fileID, null)
            .done(function (data) {
                that.doc = data;
                that.trigger('docDetails', data);
            });
    });
}
