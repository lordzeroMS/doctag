$(function () {
    let page = 1;
    let listChuckLimit = 100;
    let docs = [];

    function createDocument(d){
        var imgBox = document.createElement("div");
        imgBox.classList.add('img-box');

        var doc = document.createElement("div");
        var href = document.createElement("a");
        href.href = "edit.html?fileID=" + d.id;
        if (d.tumbnail != null) {
            var preview = document.createElement("img");
            preview.src = d.tumbnail;
            href.appendChild(preview);
        } else {
            href.innerText = "Document";
        }
        imgBox.appendChild(href);

        doc.classList.add('doc');

        var infoBox = document.createElement("div");
        infoBox.classList.add('info-box');

        var d = document.createElement("div");
        if (d.date == null) d.date = "&nbsp;";
        d.innerHTML = d.date;
        d.classList.add('date');
        infoBox.appendChild(d);


        var words = document.createElement("div");
        if (d.keywords == null) d.keywords = "&nbsp;";
        words.innerHTML = d.keywords;
        words.title = d.keywords;
        words.classList.add('keyword');
        infoBox.appendChild(words);

        doc.appendChild(infoBox);
        doc.appendChild(imgBox);
        return doc;
    }

    function refreshDocuments(keywords = "") {
        if (keywords != "") $("#keyword_field").val(keywords);
        var args = {
            method: "listPDF",
            date_from: $("#datepicker_from").val(),
            date_to: $("#datepicker_to").val(),
            keyword: $("#keyword_field").val(),
            search_field: $("#search_field").val()
        };


        $.getJSON("api/index.php", args)
            .done(function (data) {
                console.log(data);
                docs = data;
                var count = 0;
                $("#documents").empty();

                for( let i = 0; i < data.length && i < page * listChuckLimit; i++){
                    let doc = createDocument(data[i]);
                    $("#documents").append(doc);
                }

                // remove load more button if all docs are loaded
                if( page * listChuckLimit >= docs.length ) loadMoreBtn.remove();
            });

    }

    function chuckLoadDocuments( ){
        console.log(page * listChuckLimit);
        for( let i = page * listChuckLimit-listChuckLimit; i < docs.length && i < page * listChuckLimit; i++){
            let doc = createDocument(docs[i]);
            $("#documents").append(doc);
        }
    }

    let loadMoreBtn = document.querySelector('#load-more');

    loadMoreBtn.onclick = event => {
        page++;
        chuckLoadDocuments();
        // remove load more button if all docs are loaded
        if( page * listChuckLimit >= docs.length ) loadMoreBtn.remove();
    };

    $.datepicker.setDefaults($.datepicker.regional["de"]);

    $.getJSON("api/index.php?method=listKeywords", null)
        .done(function (data) {
            data.forEach(function (v1) {
                var b1 = document.createElement("button");
                b1.innerText = v1;
                b1.classList.add('label');
                b1.onclick = function (event) {
                    var btn = event.target;
                    var btnList = document.querySelectorAll('.label');
                    btnList.forEach(function (btn) {
                        btn.classList.remove('selected');
                    });

                    btn.classList.toggle('selected');
                    refreshDocuments(event.target.innerText);
                };
                $("#keywords").append(b1);
            });
        });

    $.getJSON("api/index.php", {method: "listEmpty"})
        .done(function (data) {
            if (data.empty_date != null) {
                var dateBtn = document.querySelector('#rnd-no-date');
                dateBtn.onclick = event => {
                    window.location.href = "edit.html?fileID=" + data.empty_date;
                };
            }
            if (data.empty_keyword != null) {
                var dateBtn = document.querySelector('#rnd-no-key');
                dateBtn.onclick = event => {
                    window.location.href = "edit.html?fileID=" + data.empty_keyword;
                };
            }
        });

    refreshDocuments();

    $("#upload").click(function () {
        window.location.href = "upload.html";
    });

    $("#logout").click(function () {
        var out = window.location.href.replace(/:\/\//, '://log:out@');
        document.execCommand("ClearAuthenticationCache");
        window.location.href = out;
    });

    $("#reset_date").click(function () {
        $("#datepicker_from").val("");
        $("#datepicker_to").val("");
        $("#search_field").val("");
        $("#keyword_field").val("");
        var btnList = document.querySelectorAll('.label');
        btnList.forEach(function (btn) {
            btn.classList.remove('selected');
        });
        refreshDocuments("");
    });

    $("#datepicker_from").datepicker({dateFormat: 'yy-mm-dd'}).bind("change", function () {
        refreshDocuments("");
    });

    $("#datepicker_to").datepicker({dateFormat: 'yy-mm-dd'}).bind("change", function () {
        refreshDocuments("");
    });

    $("#search_field").on('keyup', function (e) {
        if (e.keyCode == 13) {
            refreshDocuments("");
        }
    });

    $(".keywords button").click(function (event) {
        alert(event.target.innerText);
        event.defaultPrevented();
    });
});
