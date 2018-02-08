$(function () {

    $(document).ready(function() {
        $('#tags').focus();
    });

    var params = {};
    window.location.search
        .replace(/[?&]+([^=&]+)=([^&]*)/gi, function (str, key, value) {
                params[key] = value;
            }
        );

    $.getJSON("api/index.php?method=listKeywords", null)
        .done(function (data) {
            $("#tags").autocomplete({
                source: data
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

    $.getJSON("api/index.php?method=detailsPDF&fileID=" + params.fileID, null)
        .done(function (data) {

            if (data['keywords']) {
                data["keywords"].forEach(function (v1) {
                    var b1 = document.createElement("button");
                    b1.innerText = v1;
                    b1.onclick = function (event) {
                        var box = window.confirm("Should '" + event.target.innerText + "' removed?");
                        if (box == true) {
                            $.get("api", {
                                method: "removeKeyword",
                                fileID: params.fileID,
                                keyword: event.target.innerText
                            })
                            event.target.remove()
                        }
                    };
                    $("#keywords").append(b1);
                });
            }

            $("#datepicker").val(data["date"]);
            $("#pdf").attr("data", data["pdfLocation"]);
        });

    $("#datepicker").datepicker({dateFormat: 'yy-mm-dd'}).bind("change", function () {
        $.get("api", {method: "updateDate", fileID: params.fileID, date: $("#datepicker").val()})
    });

    $.datepicker.setDefaults($.datepicker.regional["de"]);

    $("#tags").keypress(function (event) {
        if (event.which == 13) {
            $.get("api", {method: "addKeyword", fileID: params.fileID, keyword: $("#tags").val()})
            var b1 = document.createElement("button");
            b1.innerText = $("#tags").val();
            b1.onclick = function (event) {
                var box = window.confirm("Should '" + event.target.innerText + "' removed?");
                if (box == true) {
                    $.get("api", {
                        method: "removeKeyword",
                        fileID: params.fileID,
                        keyword: event.target.innerText
                    })
                    event.target.remove()
                }
            }
            $("#keywords").append(b1);
            $("#tags").val("");
        }
    });

    $("#delete").click(function () {
        var box = window.confirm("are you sure to delete this document?");
        if (box == true) {
            $.get("api", {method: "removePDF", fileID: params.fileID}).done(function (data) {
                window.location.href = "index.html";
            });
        }
    });


})
;
function buttonBackClick() {
    location.href = 'index.html';
}
