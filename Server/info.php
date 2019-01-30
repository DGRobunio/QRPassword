<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    header('Access-Control-Allow-Origin:*');
    header("Content-type:text/html;charset=utf-8");
    $info_content = file_get_contents("php://input");
    $info_JSON = json_decode($info_content, true);
    $qrcode = file_get_contents("qrcode.json");
    $code_JSON = json_decode($qrcode, true);
    if ($info_JSON->randkey == $code_JSON->randkey) {
        $file = fopen("info.json", "w") or die("Unable to open file!");
        fwrite($file, $info_content);
        fclose($file);
    }
} else if ($_SERVER["REQUEST_METHOD"] == "GET") {
    header('Access-Control-Allow-Origin:*');
    header("Content-type:text/html;charset=utf-8");
    $file = fopen("info.json", "r") or die("Unable to open file!");
    echo fread($file, filesize("info.json"));
    fclose($file);
}
?>
