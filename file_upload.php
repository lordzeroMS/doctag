
<?php

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
    $db = mysqli_connect(
        "localhost",
        "c1pdftagger",
        "mjvtAW!RhG2",
        "c1pdftagger"
    );
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
    echo "File is valid, and was successfully uploaded.\n";
	$db = connectDB();
        exec("convert -density 50  \"".$uploadfile."[0]\" \"".$uploadfile.".png\"");
        $sql = "INSERT INTO `files` (`pdfLocation`,`orginal_name`,`tumbnail`,`user`) VALUES ('".$uploadfile."', '".
	  mysqli_real_escape_string($db, $_FILES['file']['name'])."','".
          $uploadfile.".png','".mysqli_real_escape_string($db, $user)."');";
        selectDb($db, $sql);
        close($db, True);
} else {
            header('HTTP/1.1 500 Internal Server Error');
    echo "upload failed\n";
}



?>

