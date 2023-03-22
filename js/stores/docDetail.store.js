function DocDetailStore(){
    riot.observable(this);
    this.doc = {};
    const that = this;


    this.on('loadDocDetails', filter => {

        let request = {
            url: 'api/',
            data: {
                method: 'detailsPDF',
                fileID: params.fileID
            }
        };

        getData(request).then(function(response) {
                if (response.status !== 200) {
                    console.error('Looks like there was a problem. Status Code: ' + response.status);
                    return;
                }
                else {
                    response.json().then(data =>{
                        that.doc = data;                    
                        that.trigger('docDetails', data);
                    });
                }
            }
        )
        .catch(function(err) {
            console.error('Fetch Error :-S', err);
        });
    });
}
