//= require jquery
//= require bootstrap
//= require_tree .

$(function(){
var clicked = false;
$('text tspan').click(function(e){
  e.stopPropagation();
  var class_base = $(this).parent().attr('id').replace(/\d/g, "");
  var class_install_name = class_base + "_install";
  var class_comment_name = class_base + "_comment";
  $('#flow, #flow2').attr('class', class_install_name);
  $('.info_on_flow').addClass('hide_comment').removeClass('show_comment');
  $("." + class_comment_name).removeClass('hide_comment').addClass('show_comment');
}); 
$('rect').click(function(e){
  e.stopPropagation();
  var class_base = $(this).attr('class').replace(/_bg/g, "");
  var class_install_name = class_base + "_install";
  var class_comment_name = class_base + "_comment";
  $('#flow, #flow2').attr('class', class_install_name);
  $('.info_on_flow').addClass('hide_comment').removeClass('show_comment');
  $("." + class_comment_name).removeClass('hide_comment').addClass('show_comment');
}); 


$('svg').click(function(){
  $('#flow, #flow2').attr('class', "");
})

$('text tspan, rect').mousedown(function(){
  stop();
});

var buttons = $('text tspan');
var index = 0;
var interval = null;
var start = function() {
  interval = setInterval(function(){
    console.log(buttons.length);
    console.log(index);
    $(buttons[index]).click();
    
    if (index == buttons.length) {
      index = 0;
    } else {
      index++;
    }
    }, 4000);
}

var stop = function() {
  clearInterval(interval);
}

start();
});
