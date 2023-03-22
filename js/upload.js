Dropzone.autoDiscover = false;
$(function () {

    let dzone = document.querySelector('#dzone');
    dzone.dropzone({
        url: "./file_upload.php",
        acceptedFiles: "application/pdf",
        success: function (file, responseText) {
            console.log("file successfull uploaded " + file.name);
            file.previewElement.parentElement.removeChild(file.previewElement);
        }
    });

});
function buttonBackClick(){
    location.href = 'index.html';
}
