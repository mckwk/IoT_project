<?php

define("API_URL", "http://192.168.206.43:8443");

function api_get($endpoint) {
    $url = API_URL . $endpoint;
    $response = file_get_contents($url);
    return json_decode($response, true);
}

function api_post($endpoint, $data) {
    $url = API_URL . $endpoint;
    
    $options = [
        "http" => [
            "header" => "Content-Type: application/json",
            "method" => "POST",
            "content" => json_encode($data)
        ]
    ];
    
    $context = stream_context_create($options);
    $response = file_get_contents($url, false, $context);
    return json_decode($response, true);
}

?>
