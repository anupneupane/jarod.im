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
      o.write(:file => filename)
      o.acl = :public_read
    puts "#{ filename } => #{ o.public_url }"
    public_urls << o.public_url
  end
  public_urls
end

images = filter_files(image_files, /.+.jpg/)

s3_images = upload_files_to_s3(images, 'jarodlphotos')
puts "Permalinks"

images.each_with_index do |image, i|
  puts filename_to_permalink(image)
  puts s3_images[i]
end
