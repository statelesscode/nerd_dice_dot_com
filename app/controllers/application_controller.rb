# This is the parent class that all of the other controllers inherit
# from.
# Any code that is universal to all controllers would go here. Default
# behavior can also go here provided you have the ability to undo the
# default behavior in your minority of controllers that do not use the
# default
class ApplicationController < ActionController::Base
  allow_browser versions: :modern
end
