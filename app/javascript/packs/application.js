import "bootstrap";

import "../plugins/flatpickr"

// import { initCardDetailsOnClick } from '../components/card_click'
// initCardDetailsOnClick();

// import { initNavbarWhenScroll } from '../components/navbar'
// initNavbarWhenScroll();

$( document ).ready(function() {

  // hide spinner
  $(".spinner").hide();


  // show spinner on AJAX start
  $(document).ajaxStart(function(){
    $(".spinner").show();
  });

  // hide spinner on AJAX stop
  $(document).ajaxStop(function(){
    $(".spinner").hide();
  });

});
