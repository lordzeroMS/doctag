
<?php

require_once 'config.php';

function selectDb($db, $sql)
{
    if (!$result = mysqli_query($db, $sql)) {
        rollback($db, $sql);
    }
    return $result;
}

function rollback($db)
{
    mysqli_query($db, "rollback;");
    mysqli_close($db);
    exit(1);
}

function connectDB()
{
    global $db_host, $db_user, $db_pass, $db_db;

    $db = mysqli_connect(
        $db_host,
        $db_user,
        $db_pass,
        $db_db
    );
    mysqli_set_charset($db, 'utf8');
    selectDb($db, "start transaction");
    return $db;
}

function close($db, $commit=False)
{
    if ($commit == True) {
        mysqli_commit($db);
    } else {
        mysqli_query($db, "rollback;");
    }
    mysqli_close($db);
}


$user = "";
if (!isset($_SERVER['PHP_AUTH_USER'])) {
  if (!isset($_SERVER['REMOTE_USER'])) {
    header('HTTP/1.1 403 Access denied');
    print "unautorized User";
    exit(1);
  }
  $user = $_SERVER['REMOTE_USER'];
} else {
  $user = $_SERVER['PHP_AUTH_USER'];
}

$uniqid = uniqid();
$uploaddir = 'documents/';
$uploadfile = $uploaddir . $uniqid .".pdf";

if (move_uploaded_file($_FILES['file']['tmp_name'], $uploadfile)) {

    header('HTTP/1.1 200 OK');
    $db = connectDB();
    exec("convert -density 50  \"".$uploadfile."[0]\" \"".$uploadfile.".png\"");
    exec("convert -density 300 \"".$uploadfile."\" -depth 8 -strip -background white -alpha off \"".$uploadfile.".tiff\"");
    exec("tesseract -l ".$ocr_lang." \"".$uploadfile.".tiff\" \"".$uploadfile.".ocr\"");
    exec("pdftotext \"".$uploadfile."\" \"".$uploadfile.".ext\"");
    unlink($uploadfile.".tiff");
    $ocr = file_get_contents($uploadfile.".ocr.txt");
    $ext = file_get_contents($uploadfile.".ext");
    unlink($uploadfile.".ocr.txt");
    unlink($uploadfile.".ext");
    $sql = "INSERT INTO `files` (`pdfLocation`,`orginal_name`,`tumbnail`,`user`, `ocrtext`, `pdftext`) VALUES ('".$uploadfile."', '".
    mysqli_real_escape_string($db, $_FILES['file']['name'])."','".
    $uploadfile.".png','".mysqli_real_escape_string($db, $user)."',
    '".mysqli_real_escape_string($db, $ocr)."', '".mysqli_real_escape_string($db, $ext)."');";
    $res = selectDb($db, $sql);
    $last_id = $db->insert_id;
    print "result:"
    print json_encode($res);
    close($db, True);
    print "last_id:"
    print $last_id;

} else {
    header('HTTP/1.1 500 Internal Server Error');
    echo "upload failed\n";
}



?>

