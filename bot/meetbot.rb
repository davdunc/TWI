require 'cinch'
require 'tempfile'
require 'fileutils'

def create()
	$filename = Time.new.to_s.gsub(/\s+/, "-")
	$path = "/var/www/html/meetinglog/#{$filename}.txt"
	$topic_ar = ["TOPIC"]
	$info_ar = ["INFO"]
	$action_ar = ["ACTION"]
	myfile= File.new($path, "w")
	myfile.puts("Topic:")
	myfile.puts("Info:")
	myfile.puts("Action:")
	myfile.chmod( 0755 )
	myfile.close
end

def update()
        myfile = File.open($path, "w+") do |f|
                f.puts $topic_ar
                f.puts $info_ar
                f.puts $action_ar
        end
end

#def update(ltf, lta)
#file_path = $path
#line_to_find = ltf
#line_to_add = lta

#temp_file = Tempfile.new(file_path)
#temp_file.chmod( 0755 )
#begin
#File.readlines(file_path).each do |line|
#    temp_file.puts(line)
#    if line =~ /^#{ltf}/
#    temp_file.puts(line_to_add)
#    end
#    end
#    temp_file.close
#FileUtils.mv(temp_file.path,file_path)
#ensure
#    temp_file.delete
#end
#end

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.thoughtworks.com"
    c.channels = ["#devcloud","#devops"]
    c.nick = "meetbot"
  end

$mip = false

  on :message, "!startmeeting" do |m|
    	if $mip == false
    	create()
    	m.reply "Meeting Started: #{Time.new.to_s}. Chair is: #{m.user.nick}"
    	m.reply "Meeting Commands:\n !topic -to set the meeting topic \n !info -for any relevent discussion regarding meeting\n !action -to set action item\n !endmeeting -to end the meeting"
    	$mip = true
    	else 
    	m.reply "!!ERROR::One meeting is already running, please do !ticket help for more options."
    	end
  end

  on :message, "!sm" do |m|
        if $mip == false
        create()
        m.reply "Meeting Started: #{Time.new.to_s}. Chair is: #{m.user.nick}"
        m.reply "Meeting Commands:\n !topic -to set the meeting topic \n !info -for any relevent discussion regarding meeting\n !action -to set action item\n !endmeeting -to end the meeting"
        $mip = true
        else
        m.reply "!!ERROR::One meeting is already running, please do !ticket help for more options."
        end
  end


  on :message, "!meeting help" do |m|
    m.reply "Meeting Commands:\n!startmeeting - to start the meeting \n !topic -to set the meeting topic \n !info -for any relevent discussion regarding meeting\n !action -to set action item\n !endmeeting -to end the meeting"
  end

  on :message, /^!topic (.*)/  do |m, topic|
   	if $mip == true
    	m.reply "Meeting Topic: #{topic}"
#    	update('Topic:', topic)
	$topic_ar.push(topic)
  	else
   	m.reply "!!ERROR: No meeting running, please do !ticket help for more options."
   	end
  end

  on :message, /^!info (.*)/ do |m, info|
    	if $mip == true
	inf =  "#{m.user.nick}: #{info}\n"
#    	update('Info:', inf)
	$info_ar.push(inf)
	else
	m.reply "!!ERROR: No meeting running, please do !ticket help for more options."
	end
  end
  on :message, /^!i (.*)/ do |m, info|
        if $mip == true
        inf =  "#{m.user.nick}: #{info}\n"
        $info_ar.push(inf)
        else
        m.reply "!!ERROR: No meeting running, please do !ticket help for more options."
        end
   end  

  on :message, /^!action (.*)/ do |m, action|
	if $mip == true
	act = "#{m.user.nick}: #{action}\n"
#   	update('Action:', act)
	$action_ar.push(act)
	else
	m.reply "!!ERROR: No meeting running, please do !ticket help for more options."
	end
  end 
  on :message, /^!a (.*)/ do |m, action|
        if $mip == true
        act = "#{m.user.nick}: #{action}\n"
        $action_ar.push(act)
        else
        m.reply "!!ERROR: No meeting running, please do !ticket help for more options."
        end
  end

   on :message, "!endmeeting" do |m|
   # myfile.close
   	if $mip == true
	update()
    	m.reply "Meeting ends, Minutes are stored as #{$filename}"
    	m.reply "Minutes are located at: http://10.10.101.103/meetinglog/"
        $mip = false
	else
	m.reply "!!ERROR: No meeting running, please do !ticket help for more options."
	end
  end 

   on :message, "!em" do |m|
   # myfile.close
   	if $mip == true
	update()
    	m.reply "Meeting ends, Minutes are stored as #{$filename}"
    	m.reply "Minutes are located at: http://10.10.101.103/meetinglog/"
        $mip = false
	else
	m.reply "!!ERROR: No meeting running, please do !ticket help for more options."
	end
  end 

end 

bot.start

