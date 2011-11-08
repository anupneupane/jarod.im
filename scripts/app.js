// function resize() {
//     var windowHeight = window.getSize().y;
//     var windowWidth = window.getSize().x;
//     var photoHeight = 567;
//     Array.each($$('div.photo'),
//     function(photo) {
//         var img = photo.getElement('img');
//         var padding = (windowHeight - img.getSize().y) / 2;
//         photo.setStyle('padding', padding + 'px 0px');
//     });
// }

// window.addEvent('load',
// function() {
//     resize();
// });

// window.addEvent('resize',
// function() {
//     resize();
// });

// window.addEvent('load', function() {
//     var ns = new NavSimple({
//         sections: '.container>div',
//         offset: {
//             x: 0,
//             y: 0
//         },
//         hashPathOnLoad: true
//     });
//     ns.activate();
//     var fadeBottom = function() {
//       $$('.bottom').set('tween', {duration: 10}).fade('out');
//     };
//     ns.addEvent('nextSection', fadeBottom);
//     ns.addEvent('previousSection', fadeBottom);
//     ns.addEvent('scrollComplete', function(section, curr, ns) {
//       window.location.hash = '#' + section.id;
//       $$('.bottom').set('tween', {duration: 1100}).fade('in');
//     });
// });
