function FilterStore(){
    riot.observable(this);
    this.filter = {};
    const that = this;

    this.on('add', obj => {
        let key = Object.keys(obj)[0];
        that.filter[key] = obj[key];
        this.trigger('emit', that.filter);
    });

    this.on('remove', obj => {
        let key = Object.keys(obj)[0];
        delete that.filter[key];
        this.trigger('emit', that.filter);
    });

    // toggle presents in array
    this.on('toggle', obj => {
        let key = Object.keys(obj);

        if(!that.filter[key])
            that.filter[key] = [];
        let pos = that.filter[key].indexOf(obj[key]);
        if(  pos === -1){
            that.filter.keyword.push(obj[key]);
        }
        else that.filter.keyword.splice(pos,1);

        this.trigger('emit', that.filter);
    });

    this.on('init', () => {
        this.filter = {};
        this.trigger('emit', that.filter);
    });

    this.on('emit', data =>{
        docStore.trigger('loadDocs', data );
    });

}
