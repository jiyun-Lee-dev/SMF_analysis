<%@ page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="test3.Rserver"%>
<%@ page import="test3.Rresult"%>
<!DOCTYPE html>
<html lang="en" dir="ltr">
	<head>	
		<meta charset="utf-8" name="viewport" content="width=device-width, initial-scale=1">
		<title>SwimForever</title>
		<link rel="stylesheet" TYPE="text/css" href="swimforever2_test.css">
		<link rel="stylesheet" TYPE="text/css" href="divSlideTest.css">
		<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
		<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
		<script src="swimforever2_test.js"></script>
		<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
		<script type="text/javascript">
		  	// string형 데이터 배열형식으로 정리
		  	var realArray = new Array();
		  	function toArray(str){
		  		var firstArray = str.split('/');
		  		var tableElement = ['예측종목','비교종목'];
		  		realArray.push(tableElement);
		  		// 2차원 배열 생성 및 값 할당
		  		for (var i=0; i < firstArray.length-4; i++){ 
		  			var subArr = new Array();
		  			var temp = firstArray[i].slice(0,-1);
		  	  		var tempArr = temp.split(':');
		  			subArr.push(parseFloat(tempArr[0]));
		  			subArr.push(parseFloat(tempArr[1]));
		  			realArray.push(subArr);
		  		}  		
		  		return realArray;
		  	}
		  	console.log(realArray);
	  	</script>
	</head>
<body>

	<%
		request.setCharacterEncoding("UTF-8"); // 받아올 데이터의 인코딩
		String name = request.getParameter("name");
		String sex = request.getParameter("sex");
		String style = request.getParameter("style"); // 넘겨오는 데이터 중에 irum 속성을 가져옴
		String distance = request.getParameter("distance");
		String playerAVG = request.getParameter("playerAVG");

		Rserver con = new Rserver(name, sex, style, distance);
		String rversion = con.getRVersion();

		con.read_file();

		con.linearModel();
		// 자바스크립트에서 사용할 값들 변수에 저장
		String filename = con.newFileName;
		String predictionStyle = con.style;
		String predictionDistance = con.distance;
		String oppositeDistance = "";

		if (predictionDistance.equals("50")) {
			oppositeDistance = "100";
		} else {
			oppositeDistance = "50";
		}
		Rresult result = new Rresult(filename);
		String usedfilePath = result.filePath;
		String resultDataStr = result.getRresult();
		
		// 독립변수기울기, 절편, 신뢰구간 변수 저장
		String[] tempArray = resultDataStr.split("/");
		int templength = tempArray.length;
		String[] tempArray2 = tempArray[templength - 3].split(":");
		double slope = Double.valueOf(tempArray2[1]); //독립변수 기울기
		tempArray2 = tempArray[templength - 2].split(":");
		double intercept = Double.valueOf(tempArray2[1]); // y 절편
		tempArray2 = tempArray[templength - 1].split(":");
		double interval = Double.valueOf(tempArray2[1]); // 신뢰 구간
		
		// 선형회귀 예측값 구하기
		double predictionValue = slope * Double.valueOf(playerAVG) + intercept;
		predictionValue = Math.round(predictionValue * 100) / 100.0;
		double predictionValuePlus = predictionValue + interval;
		predictionValuePlus = Math.round(predictionValuePlus * 100) / 100.0;
		double predictionValueMinus = predictionValue - interval;
		predictionValueMinus = Math.round(predictionValueMinus * 100) / 100.0;
		
		String strCheck = "";
		if (resultDataStr == "") {
			strCheck = "no";
		} else {
			strCheck = "ok";
		}
	%>
	<div id="EntireWrap">
		<div id="HeaderWrap">
			<div id="siteTitleWrap">
				<a href="http://www.swimforever.net/test/test_jy/swimforever2_test.html"><img src="SwimForeverTitle.png" title="첫 화면으로 돌아가기" id="siteTitleIMGPos"></a>
			</div>
			<nav id="MenuNav">
				<ul>
					<li><a class="menuLink current" href="http://www.swimforever.net/test/test_jy/swimforever2_test.html">기록 검색</a></li>
					<li><a class="menuLink" href="http://www.swimforever.net/test/test_jy/swimforever2_test3.html">기록 예측</a></li>
					<li><a class="menuLink" href="http://www.swimforever.net/test/test_jy/swimforever2_test4.html">기록 분석</a></li>
					<li><a class="menuLink" href="http://45.119.147.152:8080/test3_upload/ResultForm.jsp">대회 결과 업로드</a></li>
				</ul>
			</nav>
		</div>

		<script type="text/javascript">
			var name = "<%=name%>";
			var style = "<%=style%>";
			var distance = "<%=distance%>";
			var playerAVG = "<%=playerAVG%>";
			console.log(name);
			console.log(style);
			console.log(distance);
			console.log(playerAVG);
	  		var str= "<%=resultDataStr%>";
	    	var arr = toArray(str);
	    	console.log("<%= slope%>");
	    	console.log("<%= intercept%>");
	    	console.log("<%= interval%>");
	   		// 구글 차트
	   	  	google.charts.load('current', {'packages':['corechart']});
	   	  	google.charts.setOnLoadCallback(drawChart);
	   	  	
	   	  	function drawChart() {
	   	    	var hAxisTitle = "<%=predictionStyle%>" + " " + "<%=oppositeDistance%>";
	   	    	var vAxisTitle = "<%=predictionStyle%>" + " " + "<%=predictionDistance%>";
	
					var data = google.visualization.arrayToDataTable(arr);
					var options = {
						title : '',
						hAxis : {
							title : hAxisTitle,
							viewWindowMode : 'explicit',
							viewWindow : {
								min : 20
							}
						},
						vAxis : {
							title : vAxisTitle,
							viewWindowMode : 'explicit',
							viewWindow : {
								min : 20
							}
						},
						legend : 'none',
						trendlines : {
							0 : {}
						}
					};
					var chart = new google.visualization.ScatterChart(document.getElementById('chart_trendlines'));
					chart.draw(data, options);
				}
		</script>
		<div id="ContentWrap" style="background-color: #e6ecf7;">
	      <div id="prediction_result_Wrap">
	        <span class="slideButton prev">❮</span>
	        <span style="font-weight: 600; font-size: 18pt; text-align: center; display: table; margin-right: auto; margin-left: auto; margin-bottom: 20px; margin-top: 20px;">〈 예측 결과 〉</span>
	        <div class="prediction_result current" id="1">
	          <div id="chart_trendlines">
	          </div>
	          <span id="prediction_explanation">
	          	<p>'<span><%= name %></span>'님의 [<span><%= style %> - <%= oppositeDistance %></span>]를 반영한 예측값입니다.</p>
	            <p>'<span><%= name %></span>' 님의 [<span><%= style %> - <%= distance %></span>]에 대한 예측 기록은 [<span><%= predictionValue %></span>] 입니다!</p>
	            <p>( 이 예측값의 오차범위는 95%의 신뢰수준으로 [<span><%= predictionValueMinus %></span>  ~ <span><%= predictionValuePlus%></span>] 입니다. )</p>
	            <p>우측의 화살표를 클릭해서 다음 예측 결과도 확인해보세요!</p>
	          </span>
	        </div>
	        <script>
	        	$(document).ready(function(){
	        		var x = "<%=name%>";
		        	if (x == "이재혁"){
		        		console.log("1");
		        		$(".ku").remove();
		        		$(".won").remove();
		        		return false;
		        	} else if (x == "구자백"){
		        		console.log("2");
		        		$(".lee").remove();
		        		$(".won").remove();
		        		return false;
		        	} else if (x == "원혜성"){
		        		console.log("3");
		        		$(".ku").remove();
		        		$(".lee").remove();
		        		return false;
		        	}
	        	})
	        </script>
	        <div class="prediction_result lee" id="2">
	          <div id="chart_trendlines">
	          	<img src="lee.png" style="width:600px;">
	          </div>
	          <span id="prediction_explanation">
	            <p>'<span>이재혁</span>'님의 <span>기록변화</span>를 반영한 예측값입니다.</p>
				<p>'이재혁'님의 [<span>자유형 - 50</span>]에 대한 예측 기록은 [<span>29.26</span>] 입니다!</p>
				<p>왼쪽 그래프에서 [<span>자유형 - 50</span>]에 대한 자신의 기록 변화도 확인해 보세요!<br/>
					왼쪽 그래프는 예측기록[<span>29.26</span>]을 포함한 결과입니다.</p>
	          </span>
	        </div>
	        <div class="prediction_result ku" id="2">
	          <div id="chart_trendlines">
	          	<img src="ku.png" style="width:600px;">
	          </div>
	          <span id="prediction_explanation">
	            <p>'<span>구자백</span>'님의 <span>기록변화</span>를 반영한 예측값입니다.</p>
				<p>'구자백'님의 [<span>접영 - 50</span>]에 대한 예측 기록은 [<span>33.26</span>] 입니다!</p>
				<p>왼쪽 그래프에서 [<span>접영 - 50</span>]에 대한 자신의 기록 변화도 확인해 보세요!<br/>왼쪽 그래프는 예측기록[<span>33.26</span>]을 포함한 결과입니다.</p>
	            
	          </span>
	        </div>
	        <div class="prediction_result won" id="2">
	          <div id="chart_trendlines">
	          	<img src="won.png" style="width:600px;">
	          </div>
	          <span id="prediction_explanation">
	            <p>'<span>원혜성</span>'님의 <span>기록변화</span>를 반영한 예측값입니다.</p>
				<p>'원혜성'님의 [<span>배영 - 50</span>]에 대한 예측 기록은 [<span>43.59</span>] 입니다!</p>
				<p>왼쪽 그래프에서 [<span>배영 - 50</span>]에 대한 자신의 기록 변화도 확인해 보세요!<br/>왼쪽 그래프는 예측기록[<span>43.59</span>]을 포함한 결과입니다.</p>
	          </span>
	        </div>
	        <span class="slideButton next">❯</span>
	      </div>
    	</div>
	</div>
</body>
</html>