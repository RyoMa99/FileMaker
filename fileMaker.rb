require "optparse"
require "faker"
require "fileUtils"

opt = OptionParser.new

folderSize = 0
fileCount = 0
caseName = ""

dir_path = "test-data"
Dir.mkdir(dir_path,0755) unless Dir.exist?(dir_path)

opt.on("-t SIZE","total folder size. ex)10g 5k 7") do |totalSize|
  caseName << "#{totalSize}_"
  /([0-9]+)([g|m|k]?)/ =~ totalSize
  prefix = 1
  case $2
  when "g"
    prefix = 1024 * 1024 * 1024
  when "m"
    prefix = 1024 * 1024
  when "k"
    prefix = 1024
  end
  folderSize = $1.to_i * prefix
end

opt.on("-c COUNT","total file count. ex)1 250") do |count|
  caseName << "#{count}_"
  fileCount = count.to_i
end

opt.parse(ARGV)


dir_path << "/#{caseName}"
if Dir.exist?(dir_path)
  puts "same testcase exsisted. can I overwrite it?[y/n]"
  input = STDIN.gets.chomp
  if input == "y"
    FileUtils.rm_r(dir_path)
    Dir.mkdir(dir_path,0755) 
  else
    exit
  end
else
  Dir.mkdir(dir_path,0755) 
end

fileCount.times do |i|
  File.open("#{dir_path}/dummy#{i}.#{Faker::File.extension}","w") do |file|
    file.write(Faker::Lorem.characters(number: (folderSize/fileCount).ceil))
  end
end
