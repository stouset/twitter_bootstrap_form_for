//= require bootstrap-datepicker/core

$(function() {
  // Initialize the datepicker.
  $('[data-behaviour~=datepicker]').each(function(){
    var element = $(this);
    var options = {};

    // Convert data attributes whoes names begin with "datepicker" to options
    // on the datepicker.
    $.each(element.data(), function(k,v) {
      if (k.match("^datepicker")) {
        // Remove "datepicker" from the name and make the first letter lower case
        // "datepickerAutoclose" becomes "autoclose"
        option = k.replace(/^datepicker/, '');
        option = option.charAt(0).toLowerCase() + option.slice(1);
        options[option] = v;
      }
    });

    element.datepicker(options);
  });
});
