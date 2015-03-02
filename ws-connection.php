<?php

$data = '{
	"post-data":
		[
			{"name":"'.$_POST["name"].'","age":"'.$_POST["age"].'"}
		],
	"user":
	[
		{"id":"14","name":"Igor"},
		{"id":"0","name":"Thiago"},
		{"id":"2","name":"Léo"}
	]
}';

echo $data;

?>