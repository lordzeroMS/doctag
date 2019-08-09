<?php
/**
 * Created by PhpStorm.
 * User: dl
 * Date: 19.01.17
 * Time: 12:01
 */

require_once '../config.php';

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
    mysqli_set_charset($db, "utf8");
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


$db = connectDB();

$method = null;
$fileID = null;
$keyword = null;
$date = null;
$search = null;
$date_from = null;
$date_to = null;

if(isset($_GET['method'])) {
    $method = mysqli_real_escape_string($db, $_GET["method"]);
}
if(isset($_GET['fileID'])) {
    $fileID = mysqli_real_escape_string($db, $_GET["fileID"]);
}
if(isset($_GET['search_field'])) {
    $search = mysqli_real_escape_string($db, $_GET["search_field"]);
}
if(isset($_GET['keyword'])) {
    $keyword = mysqli_real_escape_string($db, $_GET["keyword"]);
}
if(isset($_GET['search_keyword'])) {
    $search_keyword = mysqli_real_escape_string($db, $_GET["search_keyword"]);
}
if(isset($_GET['date'])) {
    $date = mysqli_real_escape_string($db, $_GET["date"]);
}
if(isset($_GET['date_from'])) {
    $date_from = mysqli_real_escape_string($db, $_GET["date_from"]);
}
if(isset($_GET['date_to'])) {
    $date_to = mysqli_real_escape_string($db, $_GET["date_to"]);
}


$user = "";
if (!isset($_SERVER['PHP_AUTH_USER'])) {
    if (!isset($_SERVER['REMOTE_USER'])) {
        header('HTTP/1.1 403 Access denied');
        print "unautorized User";
        exit(1);
    }
    $user = mysqli_real_escape_string($db, $_SERVER['REMOTE_USER']);
} else {
    $user = mysqli_real_escape_string($db, $_SERVER['PHP_AUTH_USER']);
}

if ($fileID != Null){
    $sql = "select * from files where id = ".$fileID." and user = '".$user."';";
    $res = selectDb($db, $sql);
    if (!$obj=mysqli_fetch_object($res)){
        header('HTTP/1.1 403 Access denied');
        print "unautorized User";
        exit(0);
    }
    mysqli_free_result($res);
}

switch ($method) {
    case "listEmpty":
        if ($fileID == Null){
            $fileID = 0;
        }
        $sql = "select
(SELECT id from files where date is null and user = '".$user."' and id <> ".$fileID." order by rand() limit 1) empty_date,
(SELECT count(id) from files where date is null and user = '".$user."' and id <> ".$fileID." order by rand()) empty_date_count,
(SELECT id from files where id not in (select fileID from fileToKeywordMap) and user = '".$user."' and id <> ".$fileID." order by rand() limit 1) empty_keyword,
(SELECT count(id) from files where id not in (select fileID from fileToKeywordMap) and user = '".$user."' and id <> ".$fileID." order by rand()) empty_keyword_count";
        $res = selectDb($db, $sql);
        $ret = mysqli_fetch_object($res);
        mysqli_free_result($res);
        print json_encode($ret);
        break;
    case "listKeywords":
        $sql = "SELECT keyword FROM keywords where id in (select keywordID from fileToKeywordMap a join files b on a.fileID = b.id where b.user = '".
            $user."') order by 1;";
        $res = selectDb($db, $sql);
        $obj = mysqli_fetch_all($res);
        $ret = array();
        foreach($obj as $row)
            array_push($ret, $row[0]);
        mysqli_free_result($res);
        print json_encode($ret);
        break;
    case "listVisibleKeywords":
        $sql = "SELECT keyword FROM keywords where type = 'visible' and id in (select keywordID from fileToKeywordMap a join files b on a.fileID = b.id where b.user = '".
            $user."') order by 1;";
        $res = selectDb($db, $sql);
        $obj = mysqli_fetch_all($res);
        $ret = array();
        foreach($obj as $row)
            array_push($ret, $row[0]);
        mysqli_free_result($res);
        print json_encode($ret);
        break;
    case "listOrginalNames":
        $sql = "SELECT distinct `orginal_name` FROM `files`";
        $res = selectDb($db, $sql);
        $obj = mysqli_fetch_all($res);
        $ret = array();
        foreach($obj as $row)
            array_push($ret, $row[0]);
        mysqli_free_result($res);
        print json_encode($ret);
        break;
    case "updateDate":
        if ($date == Null or $fileID == Null){
            header('HTTP/1.1 500 Internal Server Error');
            print "parameter missing";
            exit(1);
        }
        $sql = "UPDATE `files` SET `date` = '".
            $date.
            "' WHERE `id` = ".$fileID.";";
        selectDb($db, $sql);
        print $sql;
        break;
    case "removeKeyword":
        if ($keyword == Null or $fileID == Null){
            header('HTTP/1.1 500 Internal Server Error');
            print "parameter missing";
            exit(1);
        }
        $sql = "delete from `fileToKeywordMap` where `fileID` = ".
            $fileID.
            " and `keywordID` in (select `id` from `keywords` where `keyword` = '".
            $keyword.
            "');";
        selectDb($db, $sql);
        $sql = "delete from `keywords` where `id` not in (select distinct `keywordID` from `fileToKeywordMap`);";
        selectDb($db, $sql);
        break;
    case "addKeyword":
        if (trim($keyword) == false or $fileID == Null){
            header('HTTP/1.1 500 Internal Server Error');
            print "parameter missing";
            exit(1);
        }
        $sql = "INSERT INTO `keywords` (`keyword`, `type`) VALUES ('".str_replace('|', '_', trim($keyword))."', 'visible');";
        mysqli_query($db, $sql);
        $sql = "INSERT INTO `fileToKeywordMap` (`fileID`,`keywordID`) VALUES(".
            $fileID.
            ",(select min(id) from keywords where keyword = '".
            $keyword."' and type = 'visible'));";
        selectDb($db, $sql);
        break;
    case "addHiddenKeyword":
        if (trim($keyword) == false or $fileID == Null){
            header('HTTP/1.1 500 Internal Server Error');
            print "parameter missing";
            exit(1);
        }
        $sql = "INSERT INTO `keywords` (`keyword`, `type`) VALUES ('".str_replace('|', '_', trim($keyword))."', 'hidden');";
        mysqli_query($db, $sql);
        $sql = "INSERT INTO `fileToKeywordMap` (`fileID`,`keywordID`) VALUES(".
            $fileID.
            ",(select min(id) from keywords where keyword = '".
            $keyword."' and type = 'hidden'));";
        selectDb($db, $sql);
        break;
    case "listPDF":
        $where_condition = array();
        array_push($where_condition, " a.user = '".$user."' ");
        if (!empty($date_to)){
            array_push($where_condition, " date <= '".$date_to."' ");
        }
        if (!empty($date_from)){
            array_push($where_condition, " date >= '".$date_from."' ");
        }
        if (!empty($search_keyword)){
                array_push($where_condition, " a.id in (SELECT fileID FROM `keywords` a	join `fileToKeywordMap` b
                on a.id = b.keywordID where keyword = '".$search_keyword."') ");
        }
        if (!empty($keyword)){
            $k_list = explode('|', $keyword);
            foreach ($k_list as $k){
                array_push($where_condition, " a.id in (SELECT fileID FROM `keywords` a	join `fileToKeywordMap` b
                on a.id = b.keywordID where keyword = '".$k."') ");
            }

        }
        if (!empty($search)){
            array_push($where_condition, " match(`ocrtext`, `pdftext`) against ( '".$search."' in boolean mode) ");
        }
        if (!empty($where_condition)){
            $where_sql = " where ".join(' and ', $where_condition);
        } else {
            $where_sql = "";
        }
        $sql = "SELECT a.id, pdfLocation, date, tumbnail, group_concat(c.keyword order by c.keyword) keywords
	FROM files a
        left join fileToKeywordMap b on a.id = b.fileID
        left join keywords c on b.keywordID = c.id
        ".$where_sql."
        group by a.id, pdfLocation, date, tumbnail
        order by date desc;";
        $res = selectDb($db, $sql);
        $ret = array();
        while ($obj = mysqli_fetch_object($res)){
            array_push($ret, $obj);
        }
        print json_encode($ret);
        break;
    case "detailsPDF":
        if ($fileID == Null){
            header('HTTP/1.1 500 Internal Server Error');
            print "parameter missing";
            exit(1);
        }
        $sql = "SELECT * FROM files where id = ".$fileID.";";
        $res = selectDb($db, $sql);
        $ret = mysqli_fetch_object($res);

        $sql = "
            select keyword from keywords a
            join fileToKeywordMap b on a.id = b.keywordID
            where b.fileID = ".$fileID." order by 1;";
        $res = selectDb($db, $sql);
        $obj = mysqli_fetch_all($res);
        $ret->keywords = array();
        foreach($obj as $row)
            array_push($ret->keywords, $row[0]);
        print json_encode($ret);
        break;
    case "removePDF":
        if ($fileID == Null){
            header('HTTP/1.1 500 Internal Server Error');
            print "parameter missing";
            exit(1);
        }
        $sql = "SELECT * FROM files where id = ".$fileID.";";
        $res = selectDb($db, $sql);
        $ret = mysqli_fetch_object($res);
        if (!empty($ret->pdfLocation)){
            unlink("../".$ret->pdfLocation);
        }
        if (!empty($ret->tumbnail)){
            unlink("../".$ret->tumbnail);
        }
        $sql = "delete from `files` where `id` = ".
            $fileID.
            ";";
        selectDb($db, $sql);
        $sql = "delete from `fileToKeywordMap` where `fileID` = ".
            $fileID.
            ";";
        selectDb($db, $sql);
        $sql = "delete from `keywords` where `id` not in (select distinct `keywordID` from `fileToKeywordMap`);";
        selectDb($db, $sql);
        break;
    default:
        header('HTTP/1.1 500 Internal Server Error');
        print "Unsupported Method";
        exit(1);
}

close($db, True);
