var searchConditions_string = '';
var name = '';
var sex_string = '';
var style_string = '';
var distance_string = '';
var age_string = '';
var competitionName = '';
var teamName = '';

// 페이지 로드 시 실행되는 명령
$(window).load(function() {
  // 이전 페이지에서 전달받은 데이터들 쪼개서 각 변수에 저장
  temp = decodeURI(location.href).split("?");
  data = temp[1].split(":");
  name = data[0];
  sex_string = data[1];
  style_string = data[2];
  distance_string = data[3];
  age_string = data[4];
  competitionName = data[5];
  period_from = data[6];
  period_to = data[7];
  teamName = data[8];

  // searchConditions bar 에 대한 소스 동적으로 만들기 및 체크박스 체크 상태 유지
  searchConditions_string += "<dl class='searchConditions'><dt>선택된 조건</dt>";
  if (name != '') {
    searchConditions_string += "<dd><span> 이름 : " + name + "</span></dd>";
    /*$("#name_filter").attr('placeholder', name + " ");
    $("#name_filter").attr('readOnly', true);
    $("#name_retrieval").attr('placeholder', name + " ");*/
  }
  if (sex_string != '') {
    var content = sex_string.split("_");
    searchConditions_string += "<dd><span> 성별 : ";
    for (i = 0; i < content.length; i++) {
      searchConditions_string += content[i] + " ";
      /*if (content[i] + " " == "여 ") {
        $("input:checkbox[id='women-filter']").prop('checked', true);
        $("input:checkbox[id='women-filter']").parent().addClass("selected");
        $("input:checkbox[id='women-retrieval']").parent().addClass("selected");
      } else if (content[i] + " " == "남 ") {
        $("input:checkbox[id='men-filter']").prop('checked', true);
        $("input:checkbox[id='men-filter']").parent().addClass("selected");
        $("input:checkbox[id='men-retrieval']").parent().addClass("selected");
      }*/
    }
    /*$("input:checkbox[id='women-filter']").attr('disabled', true);
    $("input:checkbox[id='men-filter']").attr('disabled', true);*/
    searchConditions_string += "</span></dd>";
  }
  if (style_string != '') {
    var content = style_string.split("_");
    searchConditions_string += "<dd><span> 종목 : ";
    for (i = 0; i < content.length; i++) {
      searchConditions_string += content[i] + " ";
      /*if (content[i] + " " == "자유형 ") {
        $("input:checkbox[id='free-filter']").prop('checked', true);
        $("input:checkbox[id='free-filter']").parent().addClass("selected");
        $("input:checkbox[id='free-retrieval']").parent().addClass("selected");
      } else if (content[i] + " " == "배영 ") {
        $("input:checkbox[id='backstroke-filter']").prop('checked', true);
        $("input:checkbox[id='backstroke-filter']").parent().addClass("selected");
        $("input:checkbox[id='backstroke-retrieval']").parent().addClass("selected");
      } else if (content[i] + " " == "평영 ") {
        $("input:checkbox[id='breaststroke-filter']").prop('checked', true);
        $("input:checkbox[id='breaststroke-filter']").parent().addClass("selected");
        $("input:checkbox[id='breaststroke-retrieval']").parent().addClass("selected");
      } else if (content[i] + " " == "접영 ") {
        $("input:checkbox[id='butterfly-filter']").prop('checked', true);
        $("input:checkbox[id='butterfly-filter']").parent().addClass("selected");
        $("input:checkbox[id='butterfly-retrieval']").parent().addClass("selected");
      } else if (content[i] + " " == "개인 혼영 ") {
        $("input:checkbox[id='individual_medley-filter']").prop('checked', true);
        $("input:checkbox[id='individual_medley-filter']").parent().addClass("selected");
        $("input:checkbox[id='individual_medley-retrieval']").parent().addClass("selected");
      }*/
    }
    /*$("input:checkbox[id='free-filter']").attr('disabled', true);
    $("input:checkbox[id='backstroke-filter']").attr('disabled', true);
    $("input:checkbox[id='breaststroke-filter']").attr('disabled', true);
    $("input:checkbox[id='butterfly-filter']").attr('disabled', true);
    $("input:checkbox[id='individual_medley-filter']").attr('disabled', true);*/
    searchConditions_string += "</span></dd>";
  }
  if (distance_string != '') {
    content = distance_string.split("_");
    searchConditions_string += "<dd><span> 거리 : ";
    for (i = 0; i < content.length; i++) {
      searchConditions_string += content[i] + " ";
      /*if (content[i] + " " == "25 ") {
        $("input:checkbox[id='25M-filter']").prop('checked', true);
        $("input:checkbox[id='25M-filter']").parent().addClass("selected");
        $("input:checkbox[id='25M-retrieval']").parent().addClass("selected");
      } else if (content[i] + " " == "50 ") {
        $("input:checkbox[id='50M-filter']").prop('checked', true);
        $("input:checkbox[id='50M-filter']").parent().addClass("selected");
        $("input:checkbox[id='50M-retrieval']").parent().addClass("selected");
      } else if (content[i] + " " == "100 ") {
        $("input:checkbox[id='100M-filter']").prop('checked', true);
        $("input:checkbox[id='100M-filter']").parent().addClass("selected");
        $("input:checkbox[id='100M-retrieval']").parent().addClass("selected");
      } else if (content[i] + " " == "200 ") {
        $("input:checkbox[id='200M-filter']").prop('checked', true);
        $("input:checkbox[id='200M-filter']").parent().addClass("selected");
        $("input:checkbox[id='200M-retrieval']").parent().addClass("selected");
      } else if (content[i] + " " == "400 ") {
        $("input:checkbox[id='400M-filter']").prop('checked', true);
        $("input:checkbox[id='400M-filter']").parent().addClass("selected");
        $("input:checkbox[id='400M-retrieval']").parent().addClass("selected");
      } else if (content[i] + " " == "800 ") {
        $("input:checkbox[id='800M-filter']").prop('checked', true);
        $("input:checkbox[id='800M-filter']").parent().addClass("selected");
        $("input:checkbox[id='800M-retrieval']").parent().addClass("selected");
      }*/
    }
    /*$("input:checkbox[id='25M-filter']").attr('disabled', true);
    $("input:checkbox[id='50M-filter']").attr('disabled', true);
    $("input:checkbox[id='100M-filter']").attr('disabled', true);
    $("input:checkbox[id='200M-filter']").attr('disabled', true);
    $("input:checkbox[id='400M-filter']").attr('disabled', true);
    $("input:checkbox[id='800M-filter']").attr('disabled', true);*/
    searchConditions_string += "</span></dd>";
  }
  if (age_string != '') {
    content = age_string.split("_");
    searchConditions_string += "<dd><span> 나이 : ";
    for (i = 0; i < content.length; i++) {
      searchConditions_string += content[i] + " ";
    /*  if (content[i] + " " == "0,19 ") {
        $("input:checkbox[id='0~19_filter']").prop('checked', true);
        $("input:checkbox[id='0~19_filter']").parent().addClass("selected");
        $("input:checkbox[id='0~19']").parent().addClass("selected");
      } else if (content[i] + " " == "20,24 ") {
        $("input:checkbox[id='20~24_filter']").prop('checked', true);
        $("input:checkbox[id='20~24_filter']").parent().addClass("selected");
        $("input:checkbox[id='20~24']").parent().addClass("selected");
      } else if (content[i] + " " == "25,29 ") {
        $("input:checkbox[id='25~29_filter']").prop('checked', true);
        $("input:checkbox[id='25~29_filter']").parent().addClass("selected");
        $("input:checkbox[id='25~29']").parent().addClass("selected");
      } else if (content[i] + " " == "30,34 ") {
        $("input:checkbox[id='30~34_filter']").prop('checked', true);
        $("input:checkbox[id='30~34_filter']").parent().addClass("selected");
        $("input:checkbox[id='30~34']").parent().addClass("selected");
      } else if (content[i] + " " == "35,39 ") {
        $("input:checkbox[id='35~39_filter']").prop('checked', true);
        $("input:checkbox[id='35~39_filter']").parent().addClass("selected");
        $("input:checkbox[id='35~39']").parent().addClass("selected");
      } else if (content[i] + " " == "40,44 ") {
        $("input:checkbox[id='40~44_filter']").prop('checked', true);
        $("input:checkbox[id='40~44_filter']").parent().addClass("selected");
        $("input:checkbox[id='40~44']").parent().addClass("selected");
      } else if (content[i] + " " == "45,49 ") {
        $("input:checkbox[id='45~49_filter']").prop('checked', true);
        $("input:checkbox[id='45~49_filter']").parent().addClass("selected");
        $("input:checkbox[id='45~49']").parent().addClass("selected");
      } else if (content[i] + " " == "50,54 ") {
        $("input:checkbox[id='50~54_filter']").prop('checked', true);
        $("input:checkbox[id='50~54_filter']").parent().addClass("selected");
        $("input:checkbox[id='50~54']").parent().addClass("selected");
      } else if (content[i] + " " == "55,59 ") {
        $("input:checkbox[id='55~59_filter']").prop('checked', true);
        $("input:checkbox[id='55~59_filter']").parent().addClass("selected");
        $("input:checkbox[id='55~59']").parent().addClass("selected");
      } else if (content[i] + " " == "60,64 ") {
        $("input:checkbox[id='60~64_filter']").prop('checked', true);
        $("input:checkbox[id='60~64_filter']").parent().addClass("selected");
        $("input:checkbox[id='60~64']").parent().addClass("selected");
      } else if (content[i] + " " == "65,69 ") {
        $("input:checkbox[id='65~69_filter']").prop('checked', true);
        $("input:checkbox[id='65~69_filter']").parent().addClass("selected");
        $("input:checkbox[id='65~69']").parent().addClass("selected");
      } else if (content[i] + " " == "70, ") {
        $("input:checkbox[id='70~_filter']").prop('checked', true);
        $("input:checkbox[id='70~_filter']").parent().addClass("selected");
        $("input:checkbox[id='70~']").parent().addClass("selected");
      }*/
    }
/*    $("input:checkbox[id='0~19_filter']").attr('disabled', true);
    $("input:checkbox[id='20~24_filter']").attr('disabled', true);
    $("input:checkbox[id='25~29_filter']").attr('disabled', true);
    $("input:checkbox[id='30~34_filter']").attr('disabled', true);
    $("input:checkbox[id='35~39_filter']").attr('disabled', true);
    $("input:checkbox[id='40~44_filter']").attr('disabled', true);
    $("input:checkbox[id='45~49_filter']").attr('disabled', true);
    $("input:checkbox[id='50~54_filter']").attr('disabled', true);
    $("input:checkbox[id='55~59_filter']").attr('disabled', true);
    $("input:checkbox[id='60~64_filter']").attr('disabled', true);
    $("input:checkbox[id='65~69_filter']").attr('disabled', true);
    $("input:checkbox[id='70~_filter']").attr('disabled', true);*/
    searchConditions_string += "</span></dd>";
  }
  if (competitionName != '') {
    searchConditions_string += "<dd><span> 대회명 : " + competitionName + "</span></dd>";
    /*$('.competitionName').attr('value', competitionName + " ");
    $('.competitionName').attr('readOnly', true);*/
  }
  searchConditions_string += "<dd><span> 기간 : " + period_from + "년 ~ " + period_to + "년" + "</span></dd>";

  if (teamName != '') {
    searchConditions_string += "<dd><span> 소속 :  " + teamName + "</span></dd>";
  /*  $('.teamName').attr('value', teamName + " ");
    $('.teamName').attr('readOnly', true);*/
  }
  searchConditions_string += "</dl>";
  $("#viewSearchConditions").append(searchConditions_string);

  // 서버에서 검색한 결과 가져오기 및 결과 테이블 동적 생성
  // string에 있는 _를 ,로 바꿔주기
  sex_string = sex_string.replace(/_/g, ',');
  style_string = style_string.replace(/_/g, ',');
  distance_string = distance_string.replace(/_/g, ',');
  age_string = age_string.replace(/_/g, ',');
  //GET 방식으로 서버에 HTTP Request를 보냄.
  console.log(period_from + " " + period_to);
  $.get("swimforever2_search_response_test.php", {
      // 검색 조건 전달 변수
      name_retrieval: name,
      sex: sex_string,
      style: style_string,
      distance: distance_string,
      age: age_string,
      competitionName: competitionName,
      period_from: period_from,
      period_to: period_to,
      teamName: teamName
    },
    function(data, status) {
      // 반환 값 파싱
      response = JSON.parse(data);
      // 테이블 헤더 생성
      num = Object.keys(response).length;
      //$("#table-background").html(make_table_head(num));
      $("#main-content_result").html(make_table_head(num));
      // 파싱한 결과를 표의 rows로 만들기
      //alert(num);
      rows = make_table_rows(response, num);
      $("#searchResult-table").append(rows);
      // 필터링 사이드 바 체크박스 disabled 설정
    }
  );
})


// 통합 검색 결과 창에서 재검색 창 열기
$(document).on("click", ".open_or_close_retrievalSearch_bar", function() {
  $(".open").toggle();
  $(".hide").toggle();
  $("#retrievalSearch_bar #SearchConditionWrap").toggle();
  var newTop = $('#retrievalSearch_bar').outerHeight() + 50;
  //alert(newTop + "px");
  $("#main-content_result_and_filter").css("margin-top", newTop);
})

// 재검색 창 검색 조건 더보기
$(document).on("click", ".more_or_hide", function() {
  var newTop = $('#retrievalSearch_bar').outerHeight() + 50;
  $("#main-content_result_and_filter").css("margin-top", newTop);
})

//검색 조건에 맞는 데이터에 따른 테이블 만들기
var response, response_records; //검색 결과(전체) 및 결과 레코드만
//테이블 헤더만 만들기
function make_table_head(rowspanNum) {
  var new_table = "<table id='searchResult-table'>" +
    "<tr class='table-header' id='table-header'>" +
    "<th style='width: 110px;' class='table_name'>이름</th>" +
    "<th style='width: 50px;' class='table_sex'>성별</th>" +
    "<th style='width: 120px;' class='table_age'>나이 그룹<br/>대회당시(현재)</th>" +
    "<th style='width: 80px;' class='table_style'>종목</th>" +
    "<th style='width: 100px;' class='table_distance'>거리</th>" +
    "<th style='width: 110px;' class='table_timeRecord'>기록</th>" +
    //"<td rowspan='" + (rowspanNum + 1) + "' class='expandOrCollapse-table'>" +
    //"<span class='expand expandOrCollapse'>▶</span></td>" +
    "<th style='width: 150px;' class='table_competitionDate '>대회일시</th>" +
    "<th style='width: 130px;' class='table_competitionName '>대회명</th>" +
    "<th style='width: 100px;' class='table_team '>소속</th>" +
    "<th style='width: 90px;' class='table_note '>비고</th>" +
    //"<td rowspan='" + (rowspanNum + 1) + "' class='expandOrCollapse-table detailsSearchResult-table'>" +
    //"<span class='collapse expandOrCollapse detailsSearchResult-table'>◀</span></td>" +
    "</tr>";
  return new_table;
}

//테이블 바디 만들기
function make_table_rows(result_arrays, num) {
  table_tags = ""
  for (i = 0; i < num; i++) {
    var table_array = result_arrays[i];
    t_row = "<tr class='added_row'>" +
      "<td class='table_name'>" + table_array.pname +
      "</td><td class='table_sex'>" + table_array.psex +
      "</td><td class='table_age'>" + changeAgeForm(table_array.year, table_array.age_from, table_array.age_to) +
      "</td><td class='table_style'>" + table_array.style +
      "</td><td class='table_distance'>" + table_array.distance + 'm' +
      "</td><td class='table_timeRecord'>" + changeRecordForm(table_array.record) +
      "</td><td class='table_competitionDate'>" + table_array.year + '. ' + table_array.month + '. ' + changeDateForm(table_array.day) +
      "</td><td class='table_competitionName '>" + table_array.mname +
      "</td><td class='table_team '>" + table_array.team +
      "</td><td class='table_note '>" + table_array.remark +
      "</td></tr>";
    table_tags += t_row;
  }
  return table_tags;
}

//테이블 접기 펼치기
$(document).on("click", ".expandOrCollapse", function() {
//  alert("2");
  var obj = $(this);
  if (obj.hasClass("expand")) {
    obj.hide();
    obj.parent().hide();
    $(".detailsSearchResult-table").show();
  } else {
    obj.hide();
    $(".detailsSearchResult-table").hide();
    $(".expand").show();
    $(".expand").parent().show();
  }
});


// record 필드 값 출력형식 설정하는 함수
function changeRecordForm(record) {
  var recordData = '';
  var minutes = record.substring(0, 2);
  var seconds = record.substring(2, 4);
  var mseconds = record.substring(4, 6);

  if (minutes != "00") {
    recordData = minutes + ':' + seconds + '.' + mseconds;
  } else {
    recordData = seconds + '.' + mseconds;
  }
  return recordData;
}

// competitionDate 필드의 day 값 출력형식 설정하는 함수
function changeDateForm(date){
  var dateData = '';
  var startIndex_secondDate = date.indexOf('~');
  if (startIndex_secondDate != -1){
    dateData = date.substr(0, startIndex_secondDate);
  }
  else {
    dateData = date;
  }
  return dateData;
}

// age 필드의 출력형식 설정하는 함수
function changeAgeForm(competitionYear, from, to){
  var full_ageForm = '';
  var age_competition = from + '~' + to;
  var age_current = '';
  var currentYear = new Date().getFullYear();
  var gap = currentYear - parseInt(competitionYear);

  age_current = (parseInt(from) + gap) + '~' + (parseInt(to) + gap);
  full_ageForm = age_competition + '<br>(' + age_current + ')';

  return full_ageForm;
}


// /* 필터 검색 기능


var filterCondition_name = '';
var filterCondition_psex = new Array(); // 중복선택
var filterCondition_age = new Array();  // 중복선택
var filterCondition_style = new Array();  // 중복선택
var filterCondition_distance = new Array();  // 중복선택
var filterCondition_competitionName = '';
var filterCondition_competitionPeriod = '';
var filterCondition_teamName = '';
// 필터 검색 중 텍스트 처리
$(document).ready(function(){
  // 필터 검색 중 이름 검색 처리
  $("#name-filter").keyup(function(){
    filterCondition_name = $(this).val();
    filteringTD();
  })
  // 필터 검색 중 대회명 검색 처리
  $("#selValue-competitionName").keyup(function(){
    filterCondition_competitionName = $(this).val();
    filteringTD();
  })
  // 필터 검색 중 소속명 검색 처리
  $("#selValue-teamName").keyup(function(){
    filterCondition_teamName = $(this).val();
    filteringTD();
  })
})

// 필터 검색 중 체크박스 처리 (중복 허용)
$(document).on("click", "input:checkbox", function() {
  var obj = $(this);
  var conditionObject = obj.parent().parent().parent().parent().parent();
  if (!(obj.hasClass("checked"))) {
    obj.parent().addClass("selected");
    obj.addClass("checked");
    // 필터 검색 조건 값 전달
    if (conditionObject.attr('class') == "sex-filter"){
      filterCondition_psex.push(obj.attr('id'));
    }
    if (conditionObject.attr('class') == "style-filter"){
      filterCondition_style.push(obj.attr('id'));
    }
    if (conditionObject.attr('class') == "distance-filter"){
      filterCondition_distance.push(obj.attr('id'));
    }
    if (conditionObject.attr('class') == "age-filter"){
      filterCondition_age.push(obj.attr('id'));
    }
    filteringTD();
    return false;
  } else {
    obj.parent().removeClass("selected");
    obj.removeClass("checked");
    // 필터 검색 조건 값 삭제
    if (conditionObject.attr('class') == "sex-filter"){
      filterCondition_psex.splice(filterCondition_psex.indexOf(obj.attr('id')), 1);
    }
    if (conditionObject.attr('class') == "style-filter"){
      filterCondition_style.splice(filterCondition_style.indexOf(obj.attr('id')), 1);
    }
    if (conditionObject.attr('class') == "distance-filter"){
      filterCondition_distance.splice(filterCondition_distance.indexOf(obj.attr('id')), 1);
    }
    if (conditionObject.attr('class') == "age-filter"){
      filterCondition_age.splice(filterCondition_age.indexOf(obj.attr('id')), 1);
    }
    filteringTD();
    return false;
  }
})

// 테이블에 필터조건을 적용하는 함수
function filteringTD(){
  $("#searchResult-table > tbody > tr:not(#table-header)").hide();
  var temp = $("#searchResult-table > tbody > tr:not(#table-header) > td");
  var tempValue = '';
  if (filterCondition_name != ''){
    temp = $(temp).parent().children('.table_name').filter(":contains('"+ filterCondition_name + "')");
  }
  if (filterCondition_psex.length != 0){
    var temp_use = temp;
    var temp_base = temp;
    for (var i=0; i<filterCondition_psex.length; i++){
      tempValue = filterCondition_psex[i].replace("-filter","");
      tempValue = tempValue.replace("women", "여");
      tempValue = tempValue.replace("men", "남");
      if (i == 0){
        temp_use = $(temp_base).parent().children('.table_sex').filter(":contains('" + tempValue + "')");
        temp = temp_use;
      }
      else {
        temp_use = $(temp_base).parent().children('.table_sex').filter(":contains('" + tempValue + "')");
        temp = temp.add(temp_use);
      }
    }
  }
  if (filterCondition_age.length != 0){
    var temp_use = temp;
    var temp_base = temp;
    for (var i=0; i<filterCondition_age.length; i++){
      tempValue = filterCondition_age[i].replace("-filter","");
      if (i == 0){
        temp_use = $(temp_base).parent().children('.table_sex').filter(":contains('(" + tempValue + ")')");
        temp = temp_use;
      }
      else {
        temp_use = $(temp_base).parent().children('.table_sex').filter(":contains('(" + tempValue + "')");
        temp = temp.add(temp_use);
      }
    }
  }
  if (filterCondition_style.length != 0){
    temp += filterCondition_style;
  }
  if (filterCondition_distance.length != 0){

    tempValue = filterCondition_distance[0].replace("M-filter","m");
    temp = $(temp).parent().children('.table_distance').filter(":contains('" + tempValue + "')");
  }
  if (filterCondition_competitionName != ''){
    temp = $(temp).parent().children('.table_competitionName').filter(":contains('" + filterCondition_competitionName + "')");
  }
  if (filterCondition_competitionPeriod != ''){
    temp += filterCondition_competitionPeriod;
  }
  if (filterCondition_teamName != ''){
    temp = $(temp).parent().children('.table_team').filter(":contains('" + filterCondition_teamName + "')");
  }
  $(temp).parent().show();
}

// */
