// 예측에 대한 조건 입력 (중복 선택 안됨)
$(document).on("click", ".option", function() {
  var value = $(this);
  var category = $(this).parent();

  if (value.hasClass("selectOption")) {
    return false;
  } else if (!(value.hasClass("selected"))) {
    if (!(category.hasClass("selectedCategory"))) {
      value.addClass("selected");
      category.addClass("selectedCategory");
      return false;
    } else {
      alert("항목당 조건은 하나씩만 선택해주세요!");
      return false;
    }
    return false;
  } else {
    value.removeClass("selected");
    category.removeClass("selectedCategory");
    return false;
  }
});

// 직접입력과 선택입력
function setselectedValue(selectedValue, objClass) {
  if (selectedValue != "직접입력") {
    $('.' + objClass).attr('value', selectedValue);
    $('.' + objClass).attr('readOnly', true);
  } else {
    $('.' + objClass).removeAttr('readOnly', false);
    $('.' + objClass).attr('value', "");
    $('.' + objClass).focus();
  }
};


// 사용자 기록 DB에서 가져와서 평균값 계산하고 예측하고 싶은 종목과 거리랑 같이 jsp로 넘겨줘야 한다.
$(document).on("click", "#prediction_Button", function() {
  var playerRecords = new Array();
  var playerRecordsAVG = 0.0;
  var playerRecordsSUM = 0.0;
  var records = 0.0;
  //조건이 다 입력되어 있어야 예측 서비스가 실행되게 해야 함
  var conditionCount = 0;
  var name = $("#name_prediction").val();
  if (name != "") {
    conditionCount++;
  }
  var sex = $("#sex").find('span.selected').find('input').val();
  if (sex != "") {
    conditionCount++;
  }
  var style = $("#style").find('span.selected').find('input').val();
  if (style != "") {
    conditionCount++;
  }
  var distance = $("#distance").find('span.selected').find('input').val();
  if (distance != "") {
    conditionCount++;
    if (distance == 100){
      distance = 50;
    } else if (distance == 50){
      distance = 100;
    }
  }
  var age = $("#age").find('span.selected').find('input').val();
  if (age != "") {
    conditionCount++;
  }
  var teamName = $("#teamName").val();
  if (teamName != "") {
    conditionCount++;
  }

  if (conditionCount < 6) {
    alert("모든 조건을 입력해주세요!");
    return false;
  } else {
    $.get("swimforever2_test2.php", {
        name_prediction: name,
        sex_prediction: sex,
        style_prediction: style,
        distance_prediction: distance,
        age_prediction: age,
        teamName: teamName,
      },
      function(data, status) {
        response = JSON.parse(data);
        num = Object.keys(response).length;
        // 검색 결과값 배열에 저장하기
        for (var i=0; i<num; i++){
          playerRecords.push(response[i].record);
        }
        console.log(playerRecords[0]/2);
        // 기록들 초 단위로 바꾸기
        for (var i=0; i<num; i++){
          var temp = playerRecords[i];
          var minutes = parseInt(temp.substring(0, 2))*60;
          var seconds = parseInt(temp.substring(2, 4));
          var mseconds = parseFloat(temp.substring(4, 6)/100);
          playerRecords[i] = minutes + seconds + mseconds;
        }
        console.log(playerRecords[0]);
        // 기록 총합 및 평균 구하기
        for (var i = 0; i < num; i++){
          var temp = playerRecords[i];
          playerRecordsSUM += temp;
        }
        playerRecordsAVG = playerRecordsSUM / num;
        if (distance == 100){
          distance = 50;
        } else if (distance == 50){
          distance = 100;
        }
        console.log(playerRecordsAVG);
        console.log(style);
        console.log(distance);
        // 사용자 평균, 예측 종목, 예측 거리를 GET으로 전달하면서 jsp 호출
        uriString = "http://45.119.147.152:8080/test3_2_4/RPrediction.jsp?name=" + name + "&" + "sex=" + sex + "&" + "style=" + style + "&" + "distance=" + distance + "&" + "playerAVG=" + playerRecordsAVG ;
        window.location.href = encodeURI(uriString);
      }
    );
  }
})
