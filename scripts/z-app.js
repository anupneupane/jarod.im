window.addEvent('load', function() {
  var ns = new NavSimple({
    sections: '#0,#1,#2,#3,#4,#5,#6,#7',
    offset: { x: 0, y: 0 }
  });
  ns.activate();
  ns.addEvent('scrollComplete', function(section, curr, ns) {
    window.location.hash = '#' + curr;
  });
  ns.addEvent('nextSection', function(section, curr, ns) {
    $('howto').fade('out');
  });
});
