require 'rubygems'
require 'nokogiri'
require 'find'

IMAGE_DIR = './images'
CSS_DIR = './styles'
JS_DIR = './scripts'
INDEX = './index.html'

image_files = []
css_files = []
js_files = []

Find.find(IMAGE_DIR) do |f| image_files << f end
Find.find(CSS_DIR) do |f| css_files << f end
Find.find(JS_DIR) do |f| js_files << f end

def filter_files(files, regex)
  arr = []
  files.each do |filename|
    if filename =~ regex
      arr << filename.gsub(/^.\//, '')
    end
  end
  arr
end

images = filter_files(image_files, /.+.jpg/)
styles = filter_files(css_files, /.+.css/)
scripts = filter_files(js_files, /.+.js/).reverse()

# build the doc
builder = Nokogiri::HTML::Builder.new do |doc|
  doc.html {
    doc.head {
      doc.title {
        doc.text 'Jarod Luebbert'
      }
      styles.each do |style|
        doc.link(
          :rel => "stylesheet",
          :href => style,
          :type => 'text/css',
          :media => 'screen',
          :charset => 'utf-8'
        )
      end
      scripts.each do |script|
        doc.script(
          :type => 'text/javascript',
          :charset => 'utf-8',
          :src => script
        )
      end
    }
    doc.body {
      doc.div(:id => 'howto') {
        doc.text 'Use j, k, up, down, or spacebar to navigate.'
      }
      images.each_with_index do |image, i|
        doc.div(:id => "#{i}", :class => 'photo') {
          doc.img(:src => image, :alt => image)
        }
      end
    }
  }
end

File.open(INDEX, 'w') do |file|
  file.write(builder.to_html)
end

File.open('./scripts/z-app.js', 'w') do |file|
  sections = []
  (0..images.size()-1).to_a.each do |i|
    sections << "#" + i.to_s
  end
  file.write(
<<-eos
window.addEvent('load', function() {
  var ns = new NavSimple({
    sections: '#{sections.join(',')}',
    offset: { x: 0, y: 0 }
  });
  ns.activate();
  ns.addEvent('scrollComplete', function(section, curr, ns) {
    window.location.hash = '#' + curr;
  });
  ns.addEvent('nextSection', function(section, curr, ns) {
    $('howto').fade('out');
  });
  ns.addEvent('previousSection', function(section, curr, ns) {
    $('howto').fade('out');
  });
});
eos
            )
end
