require 'rubygems'
require 'nokogiri'
require 'find'
require 'exifr'
require 'aws-sdk'

IMAGE_DIR = './_images'
CSS_DIR = './styles'
JS_DIR = './scripts'
INDEX = './index.html'
CONFIG_FILE = './_config.yml'

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

def filename_to_permalink(filename)
  filename.gsub('/', '-').gsub('.jpg', '').gsub('_images-', '')
end

config = YAML.load(File.read(CONFIG_FILE))
AWS.config(config)

def upload_files_to_s3(filenames, bucket_name)
  s3 = AWS::S3.new
  bucket = s3.buckets.create(bucket_name)
  public_urls = []
  filenames.each do |filename|
    basename = File.basename(filename)
    o = bucket.objects[basename]
    if o.nil?
      o.write(:file => filename)
      o.acl = :public_read
    end
    puts "#{ filename } => #{ o.public_url }"
    public_urls << o.public_url
  end
  public_urls
end

images = filter_files(image_files, /.+.jpg/)
styles = filter_files(css_files, /.+.css/)
scripts = filter_files(js_files, /.+.js/).reverse()

File.open("#{ JS_DIR }/z-app.js", 'w') do |file|

  sections = []
  images.each do |image|
    sections << "##{ filename_to_permalink(image) }"
  end

  file.write(
<<-eos
window.addEvent('load', function() {
  var ns = new NavSimple({
    sections: '#{sections.join(',')}',
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
eos
            )
end

s3_images = upload_files_to_s3(images, 'jarodlphotos')

# build the doc
builder = Nokogiri::HTML::Builder.new do |doc|
  doc.html(:lang => 'en') {
    doc.head {
      doc.meta(:name => 'google', :value => 'notranslate') {}
      doc.meta(:property => 'og:image', :content => 'http://jarodlphotos.s3.amazonaws.com/mailman.jpg') {}
      doc.meta(:property => 'fb:admins', :content => '505816573') {}
      doc.meta(:property => 'og:type', :content => 'website') {}
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
      doc.div(:class => 'container') {
        # doc.div(:class => 'alert-message warning', :id => 'howto') {
        #   doc.p {
        #     doc.text 'Use j, k, up, down, or spacebar to navigate. '
        #     doc.a(:href => '#dismiss', :class => 'close', :id => 'dismiss-howto') {
        #       doc.text 'x'
        #     }
        #   }
        # }
        images.each_with_index do |image, i|
          @exif = EXIFR::JPEG.new(image)
          if @exif.width >= 850
            @toolbar_class = 'landscape'
          else
            @toolbar_class = 'portrait'
          end
          doc.div(:id => "#{ filename_to_permalink(image) }",
                  :class => 'photo') {
            doc.img(:src => s3_images[i], :alt => image)
            doc.div(:class => "toolbar #{ @toolbar_class }") {
              doc.p {
                doc.span("#{ @exif.focal_length }mm")
                doc.span(@exif.exposure_time.to_s)
                doc.span("f/#{ @exif.f_number.to_f }")
                doc.span(@exif.model.split(' ').each { |w|
                  w.capitalize!
                }.join(' '))
                doc.span {
                  doc.a(:href => "#{ filename_to_permalink(image) }", :class => 'btn primary') {
                    doc.text 'More..'
                  }
                }
              }
            }
          }
        end
        doc.div(:class => 'bottom') {
          File.open('follow.html') { |f|
            @follow = f.readlines
          }
          doc.cdata @follow
        }
      }
    }
  }
end

File.open(INDEX, 'w') do |file|
  file.write(builder.to_html)
end

images.each_with_index do |image, i|
  perm = filename_to_permalink(image)
  unless File.directory? perm
    Dir.mkdir(perm)
  end
  File.open("#{perm}/index.html", 'w') do |file|
    builder = Nokogiri::HTML::Builder.new do |doc|
      doc.html {
        doc.head {
          doc.meta(:name => 'google', :value => 'notranslate') {}
          doc.meta(:property => 'fb:admins', :content => '505816573') {}
          doc.title {
            doc.text "Jarod Luebbert - #{ perm }"
          }
          styles.each do |style|
            doc.link(
              :rel => "stylesheet",
              :href => "../" + style,
              :type => 'text/css',
              :media => 'screen',
              :charset => 'utf-8'
            )
          end
          scripts.each do |script|
            doc.script(
              :type => 'text/javascript',
              :charset => 'utf-8',
              :src => "../" + script
            )
          end
        }
        doc.body {
          doc.div(:class => 'container') {
            @exif = EXIFR::JPEG.new(image)
            doc.div(:id => "#{ filename_to_permalink(image) }",
                   :class => 'photo') {
              doc.img(:src => s3_images[i], :alt => image)
            }
            # doc.div(:class => 'well') {
            #   doc.h6(:class => 'title') {
            #     doc.text perm
            #   }
            #   doc.div(:class => 'row') {
            #     doc.div(:class => 'span4 columns') {
            #       doc.table {
            #         doc.tr {
            #           doc.td {
            #             doc.strong 'Focal length: '
            #           }
            #           doc.td {
            #             doc.text "#{ @exif.focal_length }mm"
            #           }
            #         }
            #         doc.tr {
            #           doc.td {
            #             doc.strong 'Exposure: '
            #           }
            #           doc.td {
            #             doc.text @exif.exposure_time.to_s
            #           }
            #         }
            #         doc.tr {
            #           doc.td {
            #             doc.strong 'Aperture: '
            #           }
            #           doc.td {
            #             doc.em 'f/'
            #             doc.text @exif.f_number.to_f
            #           }
            #         }
            #         doc.tr {
            #           doc.td {
            #             doc.strong 'Camera: '
            #           }
            #           doc.td {
            #             doc.text @exif.model.split(' ').each { |w| w.capitalize! }.join(' ')
            #           }
            #         }
            #       }
            #       # File.open('share.html') { |f|
            #       #   @share = f.readlines
            #       # }
            #       # doc.div(:class => 'share') {
            #       #   doc.cdata @share
            #       # }
            #     }
            #     doc.div(:class => 'span9 columns') {
            #       File.open(image.gsub('.jpg', '.md')) { |f|
            #         @text = f.readlines
            #       }
            #       doc.text @text
            #     }
            #   }
            # }
            #   doc.div(:class => 'toolbar') {
            #     doc.p {
            #       doc.span("#{ @exif.focal_length }mm")
            #       doc.span(@exif.exposure_time.to_s)
            #       doc.span("f/#{ @exif.f_number.to_f }")
            #       doc.span(@exif.model.split(' ').each { |w|
            #         w.capitalize!
            #       }.join(' '))
            #     }
            #   }
            # }
          }
          doc.div(:class => 'bottom') {
            File.open('follow.html') { |f|
              @follow = f.readlines
            }
            doc.cdata @follow
          }
        }
      }
    end
    file.write(builder.to_html)
  end
end
