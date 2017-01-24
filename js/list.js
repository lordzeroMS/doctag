function refreshDocuments(keywords) {
    if (!keywords) keywords = "";
    var args = {
        method: "listPDF",
        date_from: $("#datepicker_from").val(),
        date_to: $("#datepicker_to").val(),
        keyword: keywords
    };

    $.getJSON("api/index.php", args)
        .done(function (data) {
            var count = 0;
            $("#documents").empty();


            data.forEach(function (v1) {

                var imgBox = document.createElement("div");
                imgBox.classList.add('img-box');

                var doc = document.createElement("div");
                var href = document.createElement("a");
                href.href = "edit.html?fileID=" + v1.id;
                if (v1.tumbnail != null) {
                    var preview = document.createElement("img");
                    preview.src = v1.tumbnail;
                    href.appendChild(preview);
                } else {
                    href.innerText = "Document";
                }
                imgBox.appendChild(href);


                doc.classList.add('doc');

                var infoBox = document.createElement("div");
                infoBox.classList.add('info-box');


                var d = document.createElement("div");
                if (v1.date == null) v1.date = "&nbsp;";
                d.innerHTML = v1.date;
                d.classList.add('date');
                infoBox.appendChild(d);


                var words = document.createElement("div");
                if (v1.keywords == null) v1.keywords = "&nbsp;";
                words.innerHTML = v1.keywords;
                words.classList.add('keyword');
                infoBox.appendChild(words);

                doc.appendChild(infoBox);
                doc.appendChild(imgBox);

                $("#documents").append(doc);
            });
        });
}
$(function () {
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
                var b1 = document.createElement("button");
                b1.innerText = "Document without date";
                b1.classList.add('btn');
                b1.classList.add('default');
                b1.onclick = function (event) {
                    window.location.href = "edit.html?fileID=" + data.empty_date;
                };
                $("#edit_extra").prepend(b1);
            }
            if (data.empty_keyword != null) {
                var b1 = document.createElement("button");
                b1.innerText = "Document without keyword";
                b1.classList.add('btn');
                b1.classList.add('default');
                b1.onclick = function (event) {
                    window.location.href = "edit.html?fileID=" + data.empty_keyword;
                };
                $("#edit_extra").prepend(b1);
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
    $(".keywords button").click(function (event) {
        alert(event.target.innerText);
        event.defaultPrevented();
    });
});
