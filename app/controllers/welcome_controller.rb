# This is the root controller for the application. It currently displays
# different information based on whether there is a logged in user or
# not. In the future, that functionality will likely be delegated to the
# layout, but it makes sense
class WelcomeController < ApplicationController
  # GET "/" OR root_path OR welcome_path
  def index
  end
end
