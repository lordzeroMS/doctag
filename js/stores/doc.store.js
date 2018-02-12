function DocStore(){
    riot.observable(this);
    this.docs = [];
    const that = this;

    this.on('loadKeywords', () => {
        $.getJSON("api/index.php?method=listKeywords", null)
            .done(function (data) {
                that.trigger('keywords', data);
            });
    });

    this.on('loadDocs', filter => {
        let args = {
            method: "listPDF",
            date_from: filter.dateFrom,
            date_to: filter.dateTo,
            keyword: Array.isArray(filter.keyword) ? filter.keyword.join('|'): filter.keyword,
            search_field: filter.searchValue,
        };

        $.getJSON("api/index.php", args)
            .done(function (data) {
                that.trigger('docs', data);
            });
    });
}
