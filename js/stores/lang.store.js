function LangStore(){
    riot.observable(this);
    const tags = [];
    const _data = [];
    const that = this;

    this.on('loadLang', filter => {
        tags.push(this);

        if (tags.length == 1) {
           let request = {
                url: 'api/',
                data : {
                    method: "lang"
                }
            };

            getData(request).then(function(response) {
                    if (response.status !== 200) {
                        console.error('Looks like there was a problem. Status Code: ' + response.status);
                        return;
                    }
                    else {
                        response.json().then(data => {
                            tags.forEach(function(tag) {
                                tag.trigger('lang', data);
                            });
                            that.trigger('lang', data);
                            _data.push(data)
                        });
                    }
                }).catch(function(err) {
                    console.error('Fetch Error :-S', err);
            });
        } else {
            if (_data.length > 0) {
                tags.forEach(function(tag) {
                    tag.trigger('lang', _data[0]);
                });
            }
        }
    });
}
