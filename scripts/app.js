function resize() {
    var windowHeight = window.getSize().y;
    var windowWidth = window.getSize().x;
    var photoHeight = 567;
    Array.each($$('div.photo'),
    function(photo) {
        var img = photo.getElement('img');
        var padding = (windowHeight - img.getSize().y) / 2;
        photo.setStyle('padding', padding + 'px 0px');
    });
}

window.addEvent('load',
function() {
    resize();
});

window.addEvent('resize',
function() {
    resize();
});

window.addEvent('load',
function() {
    var ns = new NavSimple({
        sections: '#2011-10-23-calm,#2011-10-23-break,#2011-10-16-spanish-guitarist,#2011-10-15-angel,#2011-10-11-packing,#2011-10-02-boating,#2011-10-01-mailman,#2011-10-01-dog-bed,#2011-09-30-guitar-player,#2011-09-17-waiting,#2011-09-11-cafe,#2011-09-11-blue-and-gold,#2011-09-05-reptile,#2011-09-03-buffalo,#2011-08-24-smitty,#2011-08-23-bug,#2011-08-16-flower,#2011-08-10-italian,#2011-08-10-guitarist,#2011-08-10-concert-girl,#2011-06-30-man-at-gg',
        offset: {
            x: 0,
            y: 0
        }
    });
    ns.activate();
    ns.addEvent('scrollComplete',
    function(section, curr, ns) {
        window.location.hash = '#' + section.id;
    });
});
