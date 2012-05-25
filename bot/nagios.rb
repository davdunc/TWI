require 'cinch'
require 'rubygems'
require 'active_resource'

class Nagios
  include Cinch::Plugin

  listen_to :random_number

  def listen(m, number)
    Channel("#cinch-bots").send "I got a random number: #{number}"
  end
end

bot = Cinch::Bot.new do
  configure do |c|
    c.nick            = "nagios"
    c.server          = "irc.thoughtworks.com"
    c.channels        = ["#devcloud"]
    c.verbose         = true
    c.plugins.plugins = [Nagios]
  end
end

bot.start
