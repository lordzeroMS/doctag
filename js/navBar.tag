<nav-bar>
    <div class="top">
        <img class="logo" src="images/logo.png" alt="">
        <div class="btn-row">
            <button onclick="{onNoKeywordClick}" ref="noKeyword" class="btn default {disabled: noTagCount == 0}"><i class="fa fa-fw fa-tag"></i> <lang-text ref="without_keyword"></lang-text> <label class="badge">{noTagCount}</label></button>
            <button onclick="{onNoDateClick}" ref="noDate" class="btn default {disabled: noDateCount == 0}"><i class="fa fa-fw fa-calendar"></i> <lang-text ref="without_date"></lang-text> <label class="badge">{noDateCount}</label></button>
            <button onclick="{onUploadClick}" ref="upload" class="btn success"><i class="fa fa-fw fa-upload"></i> <lang-text ref="Upload"></lang-text></button>
            <button onclick="{onDeleteClick}" ref="delete" class="btn danger"><i class="fa fa-fw fa-trash-alt"></i> <lang-text ref="Delete"></lang-text></button>
            <button onclick="{onBackClick}" ref="back" class="btn default"><i class="fa fa-fw fa-arrow-left"></i> <lang-text ref="Back"></lang-text></button>
            <button onclick="{onLogoutClick}" ref="logout" class="btn danger"><i class="fa fa-fw fa-sign-out-alt"></i> <lang-text ref="Logout"></lang-text></button>
        </div>
    </div>
    <script>
        const that = this;

        this.showBtn = ['noDate', 'noKeyword', 'upload', 'delete', 'back', 'logout'];
        this.noDateDocId = 0;
        this.noTagDocId = 0;
        this.noTagCount = 0;
        this.noDateCount = 0;

        this.show = btnType => {
            console.log(btnType);
        };

        this.onUploadClick = e => {
            window.location.href = "upload.html";
        };

        this.onBackClick = e => {
            window.location.href = "index.html";
        };

        this.onDeleteClick = e => {
            // HACK: params comes from global scope and will only be filled if edit.html was opened
            var box = window.confirm("You want to delete this document?");
            if (box == true) {

                let request = {
                    url: 'api/',
                    data : {
                        method: "removePDF",
                        fileID: params.fileID
                    }
                };
                getData(request).then(function(response) {
                        if (response.status !== 200) {
                            console.error('Looks like there was a problem. Status Code: ' + response.status);
                            return;
                        }
                        else {
                            window.location.href = "index.html";
                        }
                    })
                    .catch(function(err) {
                        console.error('Fetch Error :-S', err);
                    });
            }
        };

        this.onNoDateClick = e => {

        	if( that.noDateCount != 0 )
            window.location.href = "edit.html?fileID=" + that.noDateDocId;
        };

        this.onNoKeywordClick = e => {
	        if( that.noTagCount != 0)
            window.location.href = "edit.html?fileID=" + that.noTagDocId;
        };

        this.onLogoutClick = e => {
            var out = window.location.href.replace(/:\/\//, '://log:out@');
            document.execCommand("ClearAuthenticationCache");
            window.location.href = out;
        };

        // put store global
        tagStore = new TagStore();

        function onData(data){
            that.noTagDocId = data.empty_keyword;
            that.noDateDocId = data.empty_date;
            that.noDateCount = data.empty_date_count;
            that.noTagCount = data.empty_keyword_count;
            that.update();
        }

        this.on('mount', function () {
            tagStore.trigger('loadTags');
            tagStore.on('tags', onData);


            // delete the button if not in opts
            that.showBtn.forEach( btn =>{
                if( this.opts.buttons.indexOf(btn) == -1 ){
                    this.refs[btn].remove();
                }
            });

            document.addEventListener('keydown', e => {
                if (e.altKey &&  e.which == '39'){
                    if( that.noDateCount != 0 )
                        window.location.href = "edit.html?fileID=" + that.noDateDocId;
                }
            });

        });

    </script>
</nav-bar>
