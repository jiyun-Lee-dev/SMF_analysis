<?php

$servername = 'localhost';
	$username = 'sblim2';
	$password = 'forever~';
	$dbname = 'sblim2';

	$db = mysqli_connect($servername, $username, $password, $dbname);
	if (!$db) {
		die("Connection failed : ".mysqli_connect_error());
	}

	mysqli_query($db,"set names utf8;");

// json_encode 함수가 한글을 유니코드 형태로 자동 변환하는 문제에 대한 PHP 5.4 하위 버전에서의 해결 방안
	function han ($s) {
		return reset(json_decode('{"s":"'.$s.'"}'));
	}

	function to_han ($str) {
		return preg_replace('/(\\\u[a-f0-9]+)+/e', 'han("$0")', $str);
	}

// 이름, 성별, 소속으로 선수에 대한 특정 종목에 대한 기록 가져오기
$temp = "SELECT *
FROM individual_game_result AS I
JOIN masters_meet AS M
ON I.mindex = M.mindex
WHERE M.year >= '2013' AND I.mindex NOT LIKE ''
AND I.pname LIKE '%$name_prediction%'
AND I.psex LIKE '%$sex_prediction%'
AND I.style LIKE '%$style_prediction%'";

$temp .= "AND I.distance LIKE '$distance_prediction'";

$age = explode(",", $age_prediction);
$temp .= " AND ( ( (I.age_from >= $age[0] AND I.age_from <= $age[1])
OR (I.age_to >= $age[0] AND I.age_to <= $age[1]) ) )";

$temp .= "AND I.team LIKE '%$teamName%'";

$result_array = array();

$sql = $temp;
$result = mysqli_query($db, $sql);

while ($row = mysqli_fetch_assoc($result)){
  $row_array['record'] = $row['record'];
  array_push($result_array, $row_array);
}
echo to_han(json_encode($result_array));
mysqli_close($db);
 ?>
