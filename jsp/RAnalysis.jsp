<%@ page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="test3.RAnalysis" %>
<%@ page import="java.util.*"%>

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
		<link rel="stylesheet" href="Nwagon.css" type="text/css">
		<script src="Nwagon.js"></script>
	</head>
<body>
<%
request.setCharacterEncoding("UTF-8"); // 받아올 데이터의 인코딩
String name = request.getParameter("name");
String sex = request.getParameter("sex");
String age = request.getParameter("age");
String team = request.getParameter("teamName");

RAnalysis con = new RAnalysis(name, sex, age, team);
con.read_file();

// 8개 종목에 대해서 결과값 구하기
List<String[]> resultList = new ArrayList();
int Index = 0;

// 자유형 50 기록 전체 리스트, 평균값, 순위 및 최고 기록
resultList = con.getRanking("자유형","50");
int freeFiftyAVG = con.calAVG(resultList); // 평균값
List<Double> freeFifty = con.getEntireRecords(resultList); // 전체 기록 리스트(초 단위)
List<String[]> freeFifty_str = con.getEntireRecords_String(resultList); // 전체 기록 리스트(문자열)
Index = con.getRank(resultList); // 순위 및 최고기록에 해당하는 인덱스
double bestRecord_FreeFifty =  freeFifty.get(Index); //최고기록
double bestRank_FreeFifty = Double.parseDouble(resultList.get(Index)[1]); // 순위
int freeFifty_totalNum = con.totalNum;
double freeFifty_forward = con.record_String_to_Number(con.forwardRecord);


// 자유형 100
resultList = con.getRanking("자유형","100");
int freeHundredAVG = con.calAVG(resultList);
List<Double> freeHundred = con.getEntireRecords(resultList);
List<String[]> freeHundred_str = con.getEntireRecords_String(resultList);
Index = con.getRank(resultList);
double bestRecord_FreeHundred = freeHundred.get(Index); 
double bestRank_FreeHundred = Double.parseDouble(resultList.get(Index)[1]); 
int freeHundred_totalNum = con.totalNum;
double freeHundred_forward = con.record_String_to_Number(con.forwardRecord);

// 접영 50
resultList = con.getRanking("접영","50");
int butterflyFiftyAVG = con.calAVG(resultList);
List<Double> butterflyFifty = con.getEntireRecords(resultList);
List<String[]> butterflyFifty_str = con.getEntireRecords_String(resultList);
Index = con.getRank(resultList); 
double bestRecord_butterflyFifty = butterflyFifty.get(Index); 
double bestRank_butterflyFifty = Double.parseDouble(resultList.get(Index)[1]); 
int butterflyFifty_totalNum = con.totalNum;
double butterflyFifty_forward = con.record_String_to_Number(con.forwardRecord);

// 접영 100
resultList = con.getRanking("접영","100");
int butterflyHundredAVG = con.calAVG(resultList); 
List<Double> butterflyHundred = con.getEntireRecords(resultList); 
List<String[]> butterflyHundred_str = con.getEntireRecords_String(resultList);
Index = con.getRank(resultList); 
double bestRecord_butterflyHundred = butterflyHundred.get(Index);
double bestRank_butterflyHundred = Double.parseDouble(resultList.get(Index)[1]); 
int butterflyHundred_totalNum = con.totalNum;
double butterflyHundred_forward = con.record_String_to_Number(con.forwardRecord);

// 배영 50
resultList = con.getRanking("배영","50");
int backstrokeFiftyAVG = con.calAVG(resultList); 
List<Double> backstrokeFifty = con.getEntireRecords(resultList); 
List<String[]> backstrokeFifty_str = con.getEntireRecords_String(resultList); 
Index = con.getRank(resultList);
double bestRecord_backstrokeFifty = backstrokeFifty.get(Index); 
double bestRank_backstrokeFifty = Double.parseDouble(resultList.get(Index)[1]); 
int backstrokeFifty_totalNum = con.totalNum;
double backstrokeFifty_forward = con.record_String_to_Number(con.forwardRecord);

//배영 100
resultList = con.getRanking("배영","100");
int backstrokeHundredAVG = con.calAVG(resultList);
List<Double> backstrokeHundred = con.getEntireRecords(resultList);
List<String[]> backstrokeHundred_str = con.getEntireRecords_String(resultList);
Index = con.getRank(resultList); 
double bestRecord_backstrokeHundred = backstrokeHundred.get(Index); 
double bestRank_backstrokeHundred = Double.parseDouble(resultList.get(Index)[1]); 
int backstrokeHundred_totalNum = con.totalNum;
double backstrokeHundred_forward = con.record_String_to_Number(con.forwardRecord);

// 평영 50
resultList = con.getRanking("평영","50");
int BreaststrokeFiftyAVG = con.calAVG(resultList); 
List<Double> BreaststrokeFifty = con.getEntireRecords(resultList);
List<String[]> BreaststrokeFifty_str = con.getEntireRecords_String(resultList);
Index = con.getRank(resultList); 
double bestRecord_BreaststrokeFifty = BreaststrokeFifty.get(Index); 
double bestRank_BreaststrokeFifty = Double.parseDouble(resultList.get(Index)[1]); 
int BreaststrokeFifty_totalNum = con.totalNum;
double BreaststrokeFifty_forward = con.record_String_to_Number(con.forwardRecord);

//평영 100
resultList = con.getRanking("평영","100");
int BreaststrokeHundredAVG = con.calAVG(resultList); 
List<Double> BreaststrokeHundred = con.getEntireRecords(resultList);
List<String[]> BreaststrokeHundred_str = con.getEntireRecords_String(resultList);
Index = con.getRank(resultList);
double bestRecord_BreaststrokeHundred = BreaststrokeHundred.get(Index); 
double bestRank_BreaststrokeHundred = Double.parseDouble(resultList.get(Index)[1]);
int BreaststrokeHundred_totalNum = con.totalNum;
double BreaststrokeHundred_forward = con.record_String_to_Number(con.forwardRecord);
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
		<div id="ContentWrap" style="background-color: #e6ecf7;">
	      <div id="analysis_result_Wrap">
	        <span class="slideButton_analysis prev">❮</span>
	        <span style="font-weight: 600; font-size: 18pt; text-align: center; display: table; margin-right: auto; margin-left: auto; margin-bottom: 20px; margin-top: 20px;">〈 분석 결과 〉</span>
	        <div class="analysis_result current" id="1">
	        <script type="text/javascript">
			    google.charts.load("current", {packages:['corechart']});
			    google.charts.setOnLoadCallback(drawChart);
			    function drawChart() {
			      var data = google.visualization.arrayToDataTable([
			        ["Element", "Rank", { role: "style" } ],
			        ["자유형50", <%=bestRank_FreeFifty%>, "#3290dc"],
			        ["자유형100", <%=bestRank_FreeHundred%>, "#5fb0ff"],
			        ["접영50", <%=bestRank_butterflyFifty%>, "#79c6ff"],
			        ["접영100", <%=bestRank_butterflyHundred%>, "#3290dc"],
			        ["배영50", <%=bestRank_backstrokeFifty%>, "#5fb0ff"],
			        ["배영100", <%=bestRank_backstrokeHundred%>, "#79c6ff"],
			        ["평영50", <%=bestRank_BreaststrokeFifty%>, "#3290dc"],
			        ["평영100", <%=bestRank_BreaststrokeHundred%>, "#5fb0ff"]
			      ]);
			
			      var view = new google.visualization.DataView(data);
			      view.setColumns([0, 1,
			                       { calc: "stringify",
			                         sourceColumn: 1,
			                         type: "string",
			                         role: "annotation" },
			                       2]);
			
			      var options = {
			        title: "종목 별 순위",
			        width: 800,
			        height: 500,
			        bar: {groupWidth: "95%"},
			        legend: { position: "none" },
			      };
			      var chart = new google.visualization.ColumnChart(document.getElementById("chart_rank"));
			      chart.draw(view, options);
			  }
			  </script>
		      <div id="chart_rank"></div>
	          <span id="analysis_explanation">
	            <p>[종목 별 순위]</p>
	            <p><span>'<%=name %>'</span> 님의 <span>종목 별 순위 그래프</span>입니다!<br>현재 swimforever에서 보유하고 있는 종목별 기록의 총 개수는 다음과 같습니다. 기록 분석에 참고하세요.<br>
	            	[자유형50 : <span><%=freeFifty_totalNum %></span>, 자유형100 : <span><%=freeHundred_totalNum %></span>, 접영50 : <span><%=butterflyFifty_totalNum %></span>, 
	            	접영100 : <span><%=butterflyHundred_totalNum %></span>, 평영50 : <span><%=backstrokeFifty_totalNum %></span>, 평영100 : <span><%=backstrokeHundred_totalNum %></span>,
	            	 배영50 : <span><%=BreaststrokeFifty_totalNum %></span>, 배영100 : <span><%=BreaststrokeHundred_totalNum %></span>]<br>
	            	( 값이 0으로 나오는 경우는 해당 종목에 대한 '<%=name %>' 님의 기록이 없는 경우입니다.)</p>
	            <p>우측의 화살표를 클릭해서 다음 분석 결과도 확인해보세요!</p>
	          </span>
	        </div>
	        <div class="analysis_result" id="2">
	          <div id="Nwagon"></div>
	          <script type="text/javascript">
				// 종목 별 순위 그래프(네이버 오픈소스)
				 var options = {
							'legend': {
					 			names: ['자유형50', '자유형100', '접영50', '접영100', '배영50', '배영100', '평영50', '평영100'],
							},
							'dataset': {
								title: '종목 별 기록평균',
								values: [[<%=freeFiftyAVG%>, <%=freeHundredAVG%>, <%=butterflyFiftyAVG%>, <%=butterflyHundredAVG%>, <%=backstrokeFiftyAVG%> , <%=backstrokeHundredAVG%>, <%=BreaststrokeFiftyAVG%>, <%=BreaststrokeHundredAVG%>]],
								bgColor: '#f9f9f9',
								fgColor: '#30a1ce',
							},
							'chartDiv': 'Nwagon',
							'chartType': 'radar',
							'chartSize': {width: 800, height: 500}
				};
				Nwagon.chart(options);
			</script>
	          <span id="analysis_explanation">
	            <p>[종목 별 평균 기록]</p>
	            <p></span>'<%=name %>'</span> 님의 </span>종목 별 평균 기록 그래프</span>입니다!<br>평균 기록은 다음과 같습니다. 기록 분석에 참고하세요.(평균 값에 버림을 적용함)<br>
	            	[자유형50 : <span><%=freeFiftyAVG %></span>, 자유형100 : <span><%=freeHundredAVG %></span>, 접영50 : <span><%=butterflyFiftyAVG %></span>,
	            	 접영100 : <span><%=butterflyHundredAVG %></span>, 평영50 : <span><%=backstrokeFiftyAVG %></span>, 평영100 : <span><%=backstrokeHundredAVG %></span>,
	            	  배영50 : <span><%=BreaststrokeFiftyAVG %></span>, 배영100 : <span><%=BreaststrokeHundredAVG %></span>]<br>
	            	( 값이 0으로 나오는 경우는 해당 종목에 대한 '<%=name %>' 님의 기록이 없는 경우입니다.)</p>
	            <p>우측의 화살표를 클릭해서 다음 분석 결과도 확인해보세요!</p>
	          </span>
	        </div>
	        <div class="analysis_result" id="3">
	        <script>
		        google.charts.load("current", {packages:['corechart']});
			    google.charts.setOnLoadCallback(drawChart);
			    function drawChart() {
			      var data = google.visualization.arrayToDataTable([
			        ["Element", "Record", { role: "style" } ],
			        ["자유형50",  <%=bestRecord_FreeFifty %>, "#3290dc"],
			        ["자유형50", <%=freeFifty_forward %>, "#5fb0ff"],
			        ["자유형100", <%=bestRecord_FreeHundred%>, "#3290dc"],
			        ["자유형100", <%=freeHundred_forward %>, "#5fb0ff"],
			        ["접영50", <%=bestRecord_butterflyFifty%>, "#3290dc"],
			        ["접영50", <%=butterflyFifty_forward %>, "#5fb0ff"],
			        ["접영100", <%=bestRecord_butterflyHundred%>, "#3290dc"],
			        ["접영100", <%=butterflyHundred_forward %>, "#5fb0ff"]
			      ]);
			
			      var view = new google.visualization.DataView(data);
			      view.setColumns([0, 1,
			                       { calc: "stringify",
			                         sourceColumn: 1,
			                         type: "string",
			                         role: "annotation" },
			                       2]);
			
			      var options = {
			        title: "종목 별 기록 비교",
			        width: 800,
			        height: 400,
			        bar: {groupWidth: "95%"},
			        legend: { position: "none" },
			      };
			      var chart = new google.visualization.ColumnChart(document.getElementById("chart_compareRecord"));
			      chart.draw(view, options);
			  }
			  </script>
			  <script>
		        google.charts.load("current", {packages:['corechart']});
			    google.charts.setOnLoadCallback(drawChart);
			    function drawChart() {
			      var data = google.visualization.arrayToDataTable([
			    	  ["Element", "Record", { role: "style" } ],
			    	  ["배영50", <%=bestRecord_backstrokeFifty%>, "#3290dc"],
				        ["배영50", <%=backstrokeFifty_forward %>, "#5fb0ff"],
				        ["배영100", <%=bestRecord_backstrokeHundred%>, "#3290dc"],
				        ["배영100", <%=backstrokeHundred_forward %>, "#5fb0ff"],
				        ["평영50", <%=bestRecord_BreaststrokeFifty%>, "#3290dc"],
				        ["평영50", <%=BreaststrokeFifty_forward %>, "#5fb0ff"],
				        ["평영100", <%=bestRecord_BreaststrokeHundred%>, "#3290dc"],
				        ["평영100", <%=BreaststrokeHundred_forward %>, "#5fb0ff"]
			      ]);
			
			      var view = new google.visualization.DataView(data);
			      view.setColumns([0, 1,
			                       { calc: "stringify",
			                         sourceColumn: 1,
			                         type: "string",
			                         role: "annotation" },
			                       2]);
			
			      var options = {
			        title: "종목 별 기록 비교",
			        width: 800,
			        height: 400,
			        bar: {groupWidth: "95%"},
			        legend: { position: "none" },
			      };
			      var chart = new google.visualization.ColumnChart(document.getElementById("chart_compareRecord2"));
			      chart.draw(view, options);
			  }
			  </script>
	          <div id="chart_compareRecord"></div>
	          <div id="chart_compareRecord2"></div>
	          <span id="analysis_explanation">
	            <p>[종목 별 앞 순위 선수와 기록 비교]</p>
	            <p><span>'<%=name %>'</span> 님의 <span>종목 별 기록 비교</span> 그래프입니다!<br>종목 별 상대방과 본인의 기록은 다음과 같습니다. 기록 분석에 참고하세요.<br>(그래프 순서는 본인, 상대방 입니다. 상대방은 <span>'<%=name %>'</span> 님보다 200위 높은 순위를 가지고 있습니다.)</p>
	            <p>	[자유형50 : <span><%=freeFifty_forward %></span>, <span><%=bestRecord_FreeFifty %>]</span>, [자유형100 : <span><%=freeHundred_forward %></span>, <span><%=bestRecord_FreeHundred %></span>],
	            	[접영50 : <span><%=butterflyFifty_forward %></span>, <span><%=bestRecord_butterflyFifty %></span>], [접영100 : <span><%=butterflyHundred_forward %></span>, <span><%=bestRecord_butterflyHundred %></span>],
	            	[배영50 : <span><%=backstrokeFifty_forward %></span>, <span><%=bestRecord_backstrokeFifty %></span>], [배영100 : <span><%=backstrokeHundred_forward %></span>, <span><%=bestRecord_backstrokeHundred %></span>],
	            	[평영50 : <span><%=BreaststrokeFifty_forward %></span>, <span><%=bestRecord_BreaststrokeFifty %></span>], [평영100 : <span><%=BreaststrokeHundred_forward %></span>, <span><%=bestRecord_BreaststrokeHundred %></span>]<br>
	            	( 값이 0으로 나오는 경우는 해당 종목에 대한 '<%=name %>' 님의 기록이 없는 경우입니다.)</p>
	          </span>
	        </div>
	        <span class="slideButton_analysis next">❯</span>
	      </div>
    	</div>
</div>

</body>
</html>