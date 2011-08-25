function resize() {
  var windowHeight = window.getSize().y;
  var windowWidth = window.getSize().x;
  var photoHeight = 567;
  var padding = (windowHeight - 567) / 2;
  Array.each($$('div.photo'), function(photo) {
    photo.setStyle('padding', padding + 'px 0px');
    photo.addEvent('mouseenter', function() {
      this.getElement('.toolbar').fade('in');
    });
    photo.addEvent('mouseleave', function() {
      this.getElement('.toolbar').fade('out');
    });
  });
  var howto = document.id('howto');
  var height = howto.getSize().y;
  if (padding / 2 > 15) {
    howto.setStyle('bottom', (padding / 2) - height);
  }
  else {
    howto.setStyle('bottom', 15);
  }
  var left = windowWidth / 2 - (howto.getSize().x / 2);
  howto.setStyle('left', left);
}
window.addEvent('domready', function() {
  resize();
});
window.addEvent('resize', function() {
  resize();
});
