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

// 기본 쿼리문
	$temp = "SELECT *
	FROM individual_game_result AS I
	JOIN masters_meet AS M
		ON I.mindex = M.mindex
	WHERE I.mindex NOT LIKE ''";

	// 대회 기간 검색
	if ($period_from != ""){
		$temp .= " AND M.year >= '%$period_from%'";
	}

	if ($period_to != ""){
		$temp .= " AND M.year <= '$period_to'";
	}

// 선수 이름 검색
if ($name_retrieval != ""){
	$temp .= " AND I.pname LIKE '%$name_retrieval%'";
}

// 선수 성별 검색 - 중복선택 가능
if ($sex != ""){
	//문자열로 받은 style을 배열로 변환시키는 부분
	$sex_array = explode(",", $sex);

	$temp .= " AND (";

	for ($i = 0; $i < count($sex_array)-1 ; $i++) {
		$temp .= "I.psex LIKE '$sex_array[$i]'";
		if ($i < count($sex_array)-2) {
			$temp .= " OR ";
		}
	}
	$temp .= ")";
}

// 종목 검색 - 중복선택 가능
if ($style != ""){
	//문자열로 받은 style을 배열로 변환시키는 부분
	$style_array = explode(",", $style);

	$temp .= " AND (";

	for ($i = 0; $i < count($style_array)-1 ; $i++) {
		$temp .= "I.style LIKE '$style_array[$i]'";
		if ($i < count($style_array)-2) {
			$temp .= " OR ";
		}
	}
	$temp .= ")";
}

// 거리 검색 - 중복선택 가능
if ($distance != ""){
	//문자열로 받은 distance을 배열로 변환시키는 부분
	$distance_array = explode(",", $distance);

	$temp .= " AND (";

	for ($i = 0; $i < count($distance_array)-1 ; $i++) {
		$temp .= "I.distance LIKE '$distance_array[$i]'";
		if ($i < count($distance_array)-2) {
			$temp .= " OR ";
		}
	}
	$temp .= ")";
}

// 나이 검색 - 중복선택 가능
if ($age != ""){
	//문자열로 받은 age을 배열로 변환시키는 부분
	$age_array = explode(",", $age);

	$temp .= " AND (";

	for ($i = 0; $i < count($age_array)-1 ; $i++) {
		$temp .= "( (I.age_from >= $age_array[$i] AND ";
			$i++;
			$temp .= "I.age_from <= $age_array[$i]) OR (";
				$i -= 1;
				$temp .="I.age_to >= $age_array[$i] AND";
				$i++;
				$temp .= " I.age_to <= $age_array[$i]) )";
		if ($i < count($age_array)-2) {
			$temp .= " OR ";
		}
	}
	$temp .= ")";
}


// 선수 소속 검색
if ($teamName != ""){
	$temp .= " AND I.team LIKE '%$teamName%'";
}

// 대회 이름 검색 & 대회 기간 검색
if ($competitionName != ""){
	$temp .= " AND (M.mname, M.year) IN (SELECT mname, year FROM masters_meet AS M WHERE M.mname LIKE '%$competitionName%' AND M.year >= $period_from AND M.year <= $period_to)";
}


//마지막에 검색 결과 기록에 대한 오름차순으로 정렬
//(근데 불참, 실격에 해당하는 record=1000000이 제일 먼저 뜸..왜지..)
$temp .= "ORDER BY I.record ASC";

	$result_array = array(); //결과를 받을 배열 선언

	$sql = $temp;
	$result = mysqli_query($db, $sql); // 데이터베이스에 쿼리 요청

	while ($row = mysqli_fetch_assoc($result)){
		$row_array['pname'] = $row['pname'];
		$row_array['psex'] = $row['psex'];
		$row_array['style'] = $row['style'];
		$row_array['distance'] = $row['distance'];
		$row_array['record'] = $row['record'];
		$row_array['age_from'] = $row['age_from'];
		$row_array['age_to'] = $row['age_to'];
		$row_array['year'] = $row['year'];
		$row_array['month'] = $row['month'];
		$row_array['day'] = $row['day'];
		$row_array['mname'] = $row['mname'];
		$row_array['rank'] = $row['rank'];
		$row_array['team'] = $row['team'];
		$row_array['remark'] = $row['remark'];
		array_push($result_array, $row_array);
	}

	echo to_han(json_encode($result_array));

	mysqli_close($db);
?>
