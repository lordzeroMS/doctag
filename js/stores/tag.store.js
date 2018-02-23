function TagStore(){
    riot.observable(this);
    this.tags = [];
    const that = this;

    this.on('loadTags', filter => {


        let request = {
            url: 'api/',
            data : {
                method: "listEmpty"
            }
        };

        getData(request).then(function(response) {
                if (response.status !== 200) {
                    console.error('Looks like there was a problem. Status Code: ' + response.status);
                    return;
                }
                else {
                    response.json().then(data =>{
                        that.trigger('tags', data);
                    });
                }
            })
            .catch(function(err) {
                console.error('Fetch Error :-S', err);
            });
    });
}
