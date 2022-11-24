# This is the controller to for the main page for an authenicated user
# for content that cannot be accessed by the public. Might replace this
# in the future with a better path or set of paths, but will keep to
# test authenticated behavior in the meantime
class AuthenticatedController < ApplicationController
  before_action :authenticate_user!
  # GET "/authenticated" OR authenticated_path
  def index
  end
end
