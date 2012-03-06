require 'cinch'
require 'tempfile'
require 'fileutils'

def create()
filename = Time.new.to_s.gsub(/\s+/, "-")
myfile= File.new("/home/gaurav/work/#{filename}.txt", "w")
return myfile
end

def update()
file_path = '/home/gaurav/work/temp.txt'
line_to_find = 'Info:'
line_to_add = 'I am great, how are you?'

temp_file = Tempfile.new(file_path)
begin
File.readlines(file_path).each do |line|
    temp_file.puts(line)
    if line =~ /^Info:/
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
    filename = Time.new.to_s.gsub(/\s+/, "-")
    myfile= File.new("/home/gaurav/work/#{filename}.txt", "w")
    m.reply "Meeting Started: #{Time.new.to_s}. Chair is: #{m.user.nick}"
    myfile.close
  end

  on :message, /^!topic (.*)/  do |m, topic|
    m.reply "Meeting Topic: #{topic}"
    myfile.puts("Topic: #{topic}\n")
  end

  on :message, /^!info (.*)/ do |m, info|
    myfile.puts("#{m.user.nick} said: #{info}\n")
  end
 
  on :message, /^!action (.*)/ do |m, action|
    myfile.puts("Action Items: #{action}\n")
  end 

  on :message, "!endmeeting" do |m|
    myfile.close
    
    m.reply "Meeting ends"
    
  end 

end 

bot.start

