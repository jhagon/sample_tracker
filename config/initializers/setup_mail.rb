require 'development_mail_interceptor' # put this in the lib directory
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
