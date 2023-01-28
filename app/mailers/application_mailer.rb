# Application Mailer Class
#
# This is the class that all other mailers in the application will
# inherit from by default. Shared code or utility methods for mailers
# belongs here
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
