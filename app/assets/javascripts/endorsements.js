$(document).ready(function() {

  $('.endorsements-link').click(function(event){
      event.preventDefault();

      var endorsementCount = $(this).siblings('.endorsements-count');

      $.post(this.href, function(response){
        endorsementCount.text(response.new_endorsement_count);
    });
  });
});
