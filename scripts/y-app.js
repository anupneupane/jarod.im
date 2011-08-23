function resize() {
  var windowHeight = window.getSize().y;
  var photoHeight = 567;
  var padding = (windowHeight - 567) / 2;
  Array.each($$('div.photo'), function(photo) {
    photo.setStyle('padding', padding + 'px 0px');
  });
}
window.addEvent('domready', function() {
  resize();
});
window.addEvent('resize', function() {
  resize();
});
