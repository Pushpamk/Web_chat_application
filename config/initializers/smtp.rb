ActionMailer::Base.smtp_settings = {
    :user_name => ENV.fetch('SENDGRID_API_USER'),
    :password => ENV.fetch('SENDGRID_API_PASS'),
    :domain => 'api.zoli.com',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
}
