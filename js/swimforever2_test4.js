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

// jsp로 입력값 전달하면서 호출하기
$(document).on("click", "#analysis_Button", function() {
  var conditionCount = 0;
  var name = $("#name_analysis").val();
  if (name != "") {
    conditionCount++;
  }
  var sex = $("#sex").find('span.selected').find('input').val();
  if (sex != "") {
    conditionCount++;
  }
  var age = $("#age").find('span.selected').find('input').val();
  if (age != "") {
    conditionCount++;
  }
  var teamName = $("#teamName").val();
  //alert(teamName);
  if (teamName != "") {
    conditionCount++;
  }

  uriString = "http://45.119.147.152:8080/test3_test/RAnalysis.jsp?name=" + name + "&" + "sex=" + sex + "&" + "age=" + age + "&" + "teamName=" + teamName;
  window.location.href = encodeURI(uriString);

})
