<%@ page import="java.net.URLEncoder"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
	</head>
<body>
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
			<center>
				<br/>
				<br/>
				<h2> 캐노니칼 폼(대회 결과) 파일 다운로드하기 </h2>
				<form action = "FileDownload.jsp?file=result_form.xls" method ="post">
				<input type = "submit" value = "다운로드">
				</form>
				<br/>
				<br/>
				<br/>
				<h2> 캐노니칼 폼(대회 정보) 파일 다운로드하기 </h2>
				<form action = "FileDownload.jsp?file=meet_form.xls" method ="post">
				<input type = "submit" value = "다운로드">
				</form>
				<br/>
				<br/>
				<br/>
				<h2> 캐노니칼 폼 작성 안내 파일 다운로드하기 </h2>
				<form action = "FileDownload.jsp?file=canonical form작업과정 설명.docx" method ="post">
				<input type = "submit" value = "다운로드">
				</form>
				<br/>
				<br/>
				<br/>				
				<h2> 파일 업로드하기</h2>
				<p>캐노니칼 파일을 다운로드 받고 데이터를 입력한 뒤 완성한 파일을 업로드해주세요!</p>
				<form action="fileUpload.jsp" method="post" enctype="Multipart/form-data">
					대회 이름 : <input type="text" name="name"/><br/>
					파일명: <input type="file" name="fileName1"/><br/>
					<input type="submit" value="전송"/>
					<input type="reset" value="취소"/>
				</form>
			</center>
		</div>
</div>
</body>
</html>