require "rake"
require 'stringex'
require 'fileutils'
# require "open-uri"

source_dir = "./"
posts_dir = "_posts"
new_post_ext = "md"

#
# From Octopress.
#
desc "Begin a new post in #{source_dir}/#{posts_dir}"
task :create, :title do |t, args|
  mkdir_p "#{source_dir}/#{posts_dir}"
  args.with_defaults(:title => 'new-post')
  title = args.title
  filename = "#{source_dir}/#{posts_dir}/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.#{new_post_ext}"

  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end

  puts "Creating new post: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
    post.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
    post.puts "tags: [en-us]"
    post.puts "---"
  end
end

desc "Process LESS into CSS."
task :less do
  FileUtils.mkdir_p 'css'
  sh "lessc _less/onox.less -x > css/screen.css"
end

# desc "Create a quotes.json file in the _data dir"
# task :get_quotes, [:api_key_location] do |t, args|
#   # Create _data dir if it doesn't exist.
#   Dir.mkdir("./_data") unless File.directory? "./_data"
#   
#   puts "Reading API key..."
#   api_url = "http://api.tumblr.com/v2/blog/turing-machine.tumblr.com/posts/quote?api_key="
#   api_key_file = args.api_key_location || "./_data/api_key"  
#   api_key = File.open(api_key_file, 'r').readlines.first
#   
#   puts "Getting data from Tumblr's API..."
#   File.open("./_data/quotes.json", 'w') do |f|
#     f << open(api_url + api_key).readlines.first
#   end
# end
