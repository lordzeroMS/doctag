function LangStore(){
    riot.observable(this);
    this.tags = [];
    const that = this;

    this.on('loadLang', filter => {


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
                    response.json().then(data =>{
                        that.trigger('lang', data);
                    });
                }
            })
            .catch(function(err) {
                console.error('Fetch Error :-S', err);
            });
    });
}
