window.addEvent('load', function() {
  var ns = new NavSimple({
    sections: '#2011-10-01-mailman,#2011-10-01-dog-bed,#2011-09-30-guitar-player,#2011-09-17-waiting,#2011-09-11-cafe,#2011-09-11-blue-and-gold,#2011-09-05-reptile,#2011-09-03-buffalo,#2011-08-24-smitty,#2011-08-23-bug,#2011-08-16-flower,#2011-08-12-winelands,#2011-08-10-italian,#2011-08-10-guitarist,#2011-08-10-concert-girl,#2011-06-30-man-at-gg',
    offset: { x: 0, y: 0 }
  });
  ns.activate();
  // $('goto-top').addEvent('click', function () {
  //   ns.toSection(0, ns);
  // });
  ns.addEvent('scrollComplete', function(section, curr, ns) {
    window.location.hash = '#' + section.id;
  });
  // ns.addEvent('nextSection', function(section, curr, ns) {
  //   $('howto').fade('out');
  // });
  // ns.addEvent('previousSection', function(section, curr, ns) {
  //   $('howto').fade('out');
  // });
});
