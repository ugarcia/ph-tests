var page = require('webpage').create();

page.open('https://www.herthabsc-bonus.de/login', function(status) {
  var title = page.evaluate(function() {
    document.querySelector('input[name=username]').value = '{{user}}';
    document.querySelector('input[name=password]').value = '{{password}}';
    document.querySelector('#submitbutton').click();
    return document.title;
  });
  console.log(status, title);
  // phantom.exit();
});
