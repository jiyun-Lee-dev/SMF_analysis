//직접입력과 선택입력
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

//체크박스 선택시 해당 요소 클래스에 selected 추가 및 해제 & 체크박스 값 체크 설정
$(document).on("click", ".option", function() {
  var obj = $(this);
  if (obj.hasClass("selectOption")) {
    return false;
  } else if (!(obj.hasClass("selected"))) {
    obj.addClass("selected");
    return false;
  } else {
    obj.removeClass("selected");
    return false;
  }
});

// 검색 조건 더보기
$(document).on("click", ".more_or_hide", function() {
  var obj = $(this);
  if (obj.hasClass("moreOptions_Button")) {
    obj.hide();
    $(".detailSearchOptions").show();
    obj.next().show();
    return false;
  } else {
    obj.hide();
    $(".detailSearchOptions").hide();
    obj.prev().show();
    return false;
  }
})

/*사용자가 입력한 검색 조건 처리*/
var name = '';
var sex_string = '';
var style_string = '';
var distance_string = '';
var age_string = '';
var competitionName = '';
var period_to;
var period_from;
var teamName = '';
// 사용자로부터 입력받은 검색 조건 각 변수에 저장 (중복선택 지원하는 항목)
function save_SearchConditions(values, category) {
  var conditions = '';
  var string = '';

  values.each(function() {
    if ($(this).hasClass(category)) {
      string += $(this).children('input').val();
      string += '_';
    }
  })
  return string;
}
// 사용자로부터 입력받은 검색 조건 각 변수에 저장 (전체)
function save_All_SearchConditions() {
  var searchConditions = $(".selected");

  name = $("#name_retrieval").val();
  if ($(".sex").hasClass("selected")) {
    sex_string = save_SearchConditions(searchConditions, "sex");
  }
  if ($(".style").hasClass("selected")) {
    style_string = save_SearchConditions(searchConditions, "style");
  }
  if ($(".distance").hasClass("selected")) {
    distance_string = save_SearchConditions(searchConditions, "distance");
  }
  if ($(".age").hasClass("selected")) {
    age_string = save_SearchConditions(searchConditions, "age");
  }
  competitionName = $(".competitionName").children('input').val();
  period_from = $("#period_from option:selected").val();
  period_to = $("#period_to option:selected").val();
  //alert(period_from + " " + period_to);
  teamName = $(".teamName").children('input').val();
}


// 검색 결과 페이지로 이동 및 변수 전달
$(document).on("click", "#retrievalSearch_Button", function() {
  save_All_SearchConditions();
  uriString = "swimforever2_test2.html?" + name + ":" + sex_string + ":" + style_string + ":" +
    distance_string + ":" + age_string + ":" + competitionName + ":" + period_from + ":" + period_to + ":" + teamName;
  // 검색 결과 html로 이동 및 변수 전달
  window.location.href = encodeURI(uriString);
});

//div 옆으로 넘기기
$(document).on("click", ".slideButton", function() {
  var obj = $(this);
  var currentPage = $('.prediction_result.current');
  var currentIndex = parseInt(currentPage.attr('id'));
  // 이전 결과 페이지로
  if (obj.hasClass('prev')) {
    var nextIndex = "#" + (currentIndex - 1);
    if ($(nextIndex).length) {
      currentPage.hide();
      $(nextIndex).show();
      currentPage.removeClass("current");
      $(nextIndex).addClass("current");
      return false;
    } else {
      alert("처음입니다!");
      return false;
    }
    return false;
  }
  // 다음 결과 페이지로
  else {
    var nextIndex = "#" + (currentIndex + 1);
    if ($(nextIndex).length) {
      currentPage.hide();
      $(nextIndex).show();
      currentPage.removeClass("current");
      $(nextIndex).addClass("current");
      return false;
    } else {
      alert("마지막입니다!");
      return false;
    }
    return false;
  }
  return false;
})
