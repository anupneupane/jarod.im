function resize() {
  var windowHeight = window.getSize().y;
  var windowWidth = window.getSize().x;
  var photoHeight = 567;
  Array.each($$('div.photo'), function(photo) {
    var img = photo.getElement('img');
    var padding = (windowHeight - img.getSize().y) / 2;
    photo.setStyle('padding', padding + 'px 0px');
    photo.addEvent('mouseenter', function() {
      this.getElement('.toolbar').fade('in');
    });
    photo.addEvent('mouseleave', function() {
      this.getElement('.toolbar').fade('out');
    });
  });
  Array.each($$('div.toolbar'), function(toolbar) {
    toolbar.setStyle('bottom', toolbar.getSize().y);
  });
  // var howto = document.id('howto');
  // document.id('dismiss-howto').addEvent('click', function () {
  //   howto.fade('out');
  // });
  // var height = howto.getSize().y;
  // if (padding / 2 > 15) {
  //   howto.setStyle('top', (padding / 2) - height);
  // }
  // var left = windowWidth / 2 - (howto.getSize().x / 2);
  // howto.setStyle('left', left);
}
window.addEvent('load', function() {
  resize();
});
window.addEvent('resize', function() {
  resize();
});
