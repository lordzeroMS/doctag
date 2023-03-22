function DocStore(){
    riot.observable(this);
    this.docs = [];
    const that = this;

    this.on('loadAllKeywords', () => {
        let request = {
            url: 'api/',
            data : {
                method: "listKeywords"
            }
        };

        getData(request).then(function(response) {
                if (response.status !== 200) {
                    console.error('Looks like there was a problem. Status Code: ' + response.status);
                    return;
                }
                else {
                    response.json().then(data =>{
                        that.trigger('allKeywords', data);
                    });
                }
            })
            .catch(function(err) {
                console.error('Fetch Error :-S', err);
            });
    });

    this.on('loadHiddenKeywords', () => {

        let request = {
            url: 'api/',
            data : {
                method: "listHiddenKeywords"
            }
        };

        getData(request).then(function(response) {
                if (response.status !== 200) {
                    console.error('Looks like there was a problem. Status Code: ' + response.status);
                    return;
                }
                else {
                    response.json().then(data =>{
                        that.trigger('hiddenKeywords', data);
                    });
                }
            })
            .catch(function(err) {
                console.error('Fetch Error :-S', err);
            });
    });

    this.on('loadKeywords', filter => {

        let request = {
            url: 'api/',
            data : {
                method: "listVisibleKeywords",
                date_from: filter.dateFrom || '',
                date_to: filter.dateTo || '',
                keyword: Array.isArray(filter.keyword) ? filter.keyword.join('|') : filter.keyword,
                search_field: filter.searchValue,
                search_keyword: filter.searchKeyword,
            }
        };

        getData(request).then(function(response) {
                if (response.status !== 200) {
                    console.error('Looks like there was a problem. Status Code: ' + response.status);
                    return;
                }
                else {
                    response.json().then(data =>{
                        that.trigger('keywords', data);
                    });
                }
            })
            .catch(function(err) {
                console.error('Fetch Error :-S', err);
            });
    });

    this.on('loadDocs', filter => {
        let request = {
            url: 'api/',
            data : {
                method: "listPDF",
                date_from: filter.dateFrom || '',
                date_to: filter.dateTo || '',
                keyword: Array.isArray(filter.keyword) ? filter.keyword.join('|') : filter.keyword,
                search_field: filter.searchValue,
                search_keyword: filter.searchKeyword,
            }
        };

        getData(request).then(function(response) {
                if (response.status !== 200) {
                    console.error('Looks like there was a problem. Status Code: ' + response.status);
                    return;
                }
                else {
                    response.json().then(data =>{
                        that.trigger('docs', data);
                    });
                }
            })
            .catch(function(err) {
                console.error('Fetch Error :-S', err);
            });


    });
}
