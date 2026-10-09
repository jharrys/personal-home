# Install ruby's filewatcher

require 'filewatcher'

Filewatcher.new(['/Users/jharrys/']).watch do |filename, event|
  puts "#{filename} #{event}"
end

