<lang-text>
    <a>{text_in_tag}</a>
    <script>
        const that = this;
        // put store global
        langStore = new LangStore();

        function onData(data){
            that.text_in_tag = data[that.opts.ref]
            that.update();
        }

        this.on('mount', function () {
            langStore.trigger('loadLang');
            langStore.on('lang', onData);
            console.log(this.opts.ref);
            this.text_in_tag = this.opts.ref;
            this.update();
        });

    </script>
</lang-text>
