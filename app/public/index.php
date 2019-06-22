<?php

$USER = "root";
$PASS = "12345";
$c = new \PDO("mysql:host=raport-mysql;dbname=testdb",$USER,$PASS);

$stmt = $c->query("SELECT * FROM user");

print_r($stmt->fetchAll(PDO::FETCH_ASSOC));
?>