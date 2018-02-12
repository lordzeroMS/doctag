function TagStore(){
    riot.observable(this);
    this.tags = [];
    const that = this;

    this.on('loadTags', filter => {

        $.getJSON("api/index.php", {method: "listEmpty"})
            .done(function (data) {
                    that.trigger('tags', data);
                }
            );
    });
}
