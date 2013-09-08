require 'sinatra'
require 'twilio-ruby'
require 'puma'

class ExampleMailGunRuby < Sinatra::Base
	configure do
	  set :notify_number, ENV['NOTIFY_NUMBER']
	  set :twilio_number, ENV['TWILIO_NUMBER']
	  set :twilio_sid, ENV['TWILIO_SID']
	  set :twilio_token, ENV['TWILIO_TOKEN']
	end

	def twilio_auth
		account_sid = settings.twilio_sid
		auth_token = settings.twilio_token
		client = Twilio::REST::Client.new account_sid, auth_token
	end

	def send_sms_with_twilio(number, subject)
		client = twilio_auth
		client.account.sms.messages.create(
	    :from => "+#{settings.twilio_number}", 
		  :to => "+#{number}", 
	    :body => subject
	  ) 
	end

	def notify(subject)
		send_sms_with_twilio(settings.notify_number, subject)
	end

	post '/new_email' do
		mail = params
		if mail['subject'].include? "[IMPORTANT]"
			notify("IMPORTANT EMAIL RECEIVED #{mail['subject']}")
		end
	end
end

