<?php
    $url = "https://fcm.googleapis.com/fcm/send";
    $token = $_POST['token'];
    $body = $_POST['body'];
    $title = $_POST['title'];
    $serverKey = 'AAAABbmpPfA:APA91bFlt4PIIp7ZBqPxjU5vGip1vBTqN0FQakIesB-THSuPGqc8UTB3D2FQ2i_C9Yo_VvcE5ZDLg0rwQeJCOw_pkPGnjDvJ6sWQni3l9gJV1U5ml2gSiV7_P1RTnbF-NJS2R_1ubGQI';
    $notification = array('title' => $title , 'body' => $body);
    $arrayToSend = array('to' => $token, 'notification' => $notification, 'priority'=> 'high');
    $json = json_encode($arrayToSend);
    $headers = array();
    $headers[] = 'Content-Type: application/json';
    $headers[] = 'Authorization: key='. $serverKey;
    $headers[] = 'Content-Length:'. strlen($json);

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL,$url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $json);

    $res = curl_exec($ch);
    curl_close($ch);
    echo $res;
?>