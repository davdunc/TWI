
require 'rubygems'
require 'pony'

email_data = {
  :from             =>  'Mailer <mailer@mydomain.com>',
  :to               =>  'gkasera@gmail.com',
  :subject          =>  'Test Email',
  :body             =>  'A plain text body',
 # :html_body        =>  haml :email, # render html email using haml
  :port             =>  '587',
  :via              =>  :smtp,
  :via_options      =>  { 
    :address                  =>  'smtp.gmail.com', 
    :port                     =>  '587', 
    :enable_starttls_auto     =>  true, 
    :user_name                =>  'gkasera@gmail.com', 
    :password                 =>  'kasera84GK', 
    :authentication           =>  :plain, 
    :domain                   =>  'mydomain.com' 
  }
}
Pony.mail(email_data)
