//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require prevent_mobile_init
//= require jquery.mobile
//= require foundation
//= require cable
//= require react
//= require react_ujs
//= require components
//= require cocoon
//= require_tree .

$(function(){ 
	$(document).foundation(); 
  $(".ui-loader").hide();
  
  $('.js-gallery-img').Am2_SimpleSlider();
});
