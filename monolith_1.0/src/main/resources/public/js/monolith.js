$(document).ready(function() {
    function hipster(done, error) {
      $.ajax('http://hipsterjesus.com/api/?paras=1&type=hipster-centric').done(function(data) {
        done(data);
      }).fail(function() {
        error({text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."});
      });
    }

    hipster(function(data) {
      $('#content').html(data.text);
    }, function(data) {
      $('#content').html(data.text);
    });
});