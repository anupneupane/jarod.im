window.addEvent('load', function() {
  var ns = new NavSimple({
    sections: '#2011-09-03-buffalo,#2011-08-24-smitty,#2011-08-23-bug,#2011-08-16-flower,#2011-08-12-winelands,#2011-08-10-italian,#2011-08-10-guitarist,#2011-08-10-foster-the-people,#2011-08-10-concert-girl,#2011-06-30-man-at-gg,#2011-06-30-hat',
    offset: { x: 0, y: 0 }
  });
  ns.activate();
  ns.addEvent('scrollComplete', function(section, curr, ns) {
    window.location.hash = '#' + section.id;
  });
  ns.addEvent('nextSection', function(section, curr, ns) {
    $('howto').fade('out');
  });
  ns.addEvent('previousSection', function(section, curr, ns) {
    $('howto').fade('out');
  });
});
