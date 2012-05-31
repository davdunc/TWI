require 'cinch'
require 'tempfile'
require 'fileutils'
require 'socket'

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

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.thoughtworks.com"
    c.channels = ["#devcloud","#devops"]
    c.nick = "meetbot"
  end

$mip = false
$host = Socket.gethostname		#hostname of the box
  on :message, "!startmeeting" do |m|
    	if $mip == false
    	create()
    	m.reply "Meeting Started: #{Time.new.to_s}. Chair is: #{m.user.nick}"
    	m.reply "Meeting Commands:
!topic :: To set the meeting topic;
!info/!i :: For any relevent discussion regarding meeting;
!action/!a :: To set action items; 
!endmeeting/!em :: To end meeting"

    	$mip = true
    	else 
    	m.reply "!!ERROR::One meeting is already running, please do !meeting help for more options."
    	end
  end

  on :message, "!sm" do |m|
        if $mip == false
        create()
        m.reply "Meeting Started: #{Time.new.to_s}. Chair is: #{m.user.nick}"
        m.reply "Meeting Commands:
!topic :: To set the meeting topic;
!info/!i :: For any relevent discussion regarding meeting;
!action/!a :: To set action items; 
!endmeeting/!em :: To end meeting"

	$mip = true
        else
        m.reply "!!ERROR::One meeting is already running, please do !meeting help for more options."
        end
  end


  on :message, "!meeting help" do |m|
    m.reply "!startmeeting/!sm :: To start the meeting;
!topic :: To set the meeting topic;
!info/!i :: For any relevent discussion regarding meeting;
!action/!a :: To set action items; 
!endmeeting/!em :: To end meeting."

  end

  on :message, /^!topic (.*)/  do |m, topic|
   	if $mip == true
    	m.reply "Meeting Topic: #{topic}"
#    	update('Topic:', topic)
	$topic_ar.push(topic)
  	else
   	m.reply "!!ERROR: No meeting running, please do !meeting help for more options."
   	end
  end

  on :message, /^!info (.*)/ do |m, info|
    	if $mip == true
	inf =  "#{m.user.nick}: #{info}\n"
#    	update('Info:', inf)
	$info_ar.push(inf)
	else
	m.reply "!!ERROR: No meeting running, please do !meeting help for more options."
	end
  end
  on :message, /^!i (.*)/ do |m, info|
        if $mip == true
        inf =  "#{m.user.nick}: #{info}\n"
        $info_ar.push(inf)
        else
        m.reply "!!ERROR: No meeting running, please do !meeting help for more options."
        end
   end  

  on :message, /^!action (.*)/ do |m, action|
	if $mip == true
	act = "#{m.user.nick}: #{action}\n"
#   	update('Action:', act)
	$action_ar.push(act)
	else
	m.reply "!!ERROR: No meeting running, please do !meeting help for more options."
	end
  end 
  on :message, /^!a (.*)/ do |m, action|
        if $mip == true
        act = "#{m.user.nick}: #{action}\n"
        $action_ar.push(act)
        else
        m.reply "!!ERROR: No meeting running, please do !meeting help for more options."
        end
  end

   on :message, "!endmeeting" do |m|
   # myfile.close
   	if $mip == true
	update()
    	m.reply "Meeting ends, Minutes are stored as #{$filename}"
    	m.reply "Minutes are located at: http://#{$host}/meetinglog/"
        $mip = false
	else
	m.reply "!!ERROR: No meeting running, please do !meeting help for more options."
	end
  end 

   on :message, "!em" do |m|
   # myfile.close
   	if $mip == true
	update()
    	m.reply "Meeting ends, Minutes are stored as #{$filename}"
    	m.reply "Minutes are located at: http://#{$host}/meetinglog/"
        $mip = false
	else
	m.reply "!!ERROR: No meeting running, please do !ticket help for more options."
	end
  end 

end 

bot.start

