require 'cinch'
require 'tempfile'
require 'fileutils'

def create()
	$filename = Time.new.to_s.gsub(/\s+/, "-")
	$path = "/home/gaurav/work/#{$filename}.txt"
	myfile= File.new($path, "w")
	myfile.puts("Topic:")
	myfile.puts("Info:")
	myfile.puts("Action:")
	myfile.close
end

def update(ltf, lta)
file_path = $path
line_to_find = ltf
line_to_add = lta

temp_file = Tempfile.new(file_path)
begin
File.readlines(file_path).each do |line|
    temp_file.puts(line)
    if line =~ /^#{ltf}/
    temp_file.puts(line_to_add)
    end
    end
    temp_file.close
FileUtils.mv(temp_file.path,file_path)
ensure
    temp_file.delete
end
end

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "sifyirc01.thoughtworks.com"
    c.channels = ["#ticket-bot"]
    c.nick = "meetbot"
  end

  on :message, "!startmeeting" do |m|
    create()
    m.reply "Meeting Started: #{Time.new.to_s}. Chair is: #{m.user.nick}"
  end

  on :message, /^!topic (.*)/  do |m, topic|
    m.reply "Meeting Topic: #{topic}"
    update('Topic:', topic)
  end

  on :message, /^!info (.*)/ do |m, info|
    inf =  "#{m.user.nick}: #{info}\n"
    update('Info:', inf)
  end
 
  on :message, /^!action (.*)/ do |m, action|
   act = "#{m.user.nick}: #{action}\n"
   update('Action:', act)
  end 

  on :message, "!endmeeting" do |m|
   # myfile.close
    m.reply "Meeting ends"
    m.reply "Minutes are located at:"
  end 

end 

bot.start

