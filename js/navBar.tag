<nav-bar>
    <div class="top">
        <img class="logo" src="images/logo.png" alt="">

        <button onclick="{onNoKeywordClick}" ref="noKeyword" class="btn default"><i class="fa fa-tag"></i> without keyword</button>
        <button onclick="{onNoDateClick}" ref="noDate" class="btn default"><i class="fa fa-calendar"></i> without date</button>
        <button onclick="{onUploadClick}" ref="upload" class="btn success"><i class="fa fa-upload"></i> Upload</button>
        <button onclick="{onDeleteClick}" ref="delete" class="btn danger"><i class="fa fa-trash-alt"></i> Delete</button>
        <button onclick="{onBackClick}" ref="back" class="btn default"><i class="fa fa-arrow-left"></i> Back</button>
        <button onclick="{onLogoutClick}" ref="logout" class="btn danger"><i class="fa fa-sign-out-alt"></i> Logout</button>
    </div>
    <script>
        const that = this;

        this.showBtn = ['noDate', 'noKeyword', 'upload', 'delete', 'back', 'logout'];

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
                $.get("api", {method: "removePDF", fileID: params.fileID})
                    .done(function (data) {
                        window.location.href = "index.html";
                    });
            }
        };

        this.onNoDateClick = e => {

            $.getJSON("api/index.php", {method: "listEmpty"})
                .done(function (data) {
                    if (data.empty_date != null) {
                        window.location.href = "edit.html?fileID=" + data.empty_date;
                    }
                });
        };

        this.onNoKeywordClick = e => {
            $.getJSON("api/index.php", {method: "listEmpty"})
                .done(function (data) {
                    if (data.empty_date != null) {
                        window.location.href = "edit.html?fileID=" + data.empty_keyword;
                    }
                });
        };

        this.onLogoutClick = e => {
            var out = window.location.href.replace(/:\/\//, '://log:out@');
            document.execCommand("ClearAuthenticationCache");
            window.location.href = out;
        };

        this.on('mount', function () {
            // delete the button if not in opts
            that.showBtn.forEach( btn =>{
                if( this.opts.buttons.indexOf(btn) == -1 ){
                    this.refs[btn].remove();
                }
            });
        });

    </script>
</nav-bar>
