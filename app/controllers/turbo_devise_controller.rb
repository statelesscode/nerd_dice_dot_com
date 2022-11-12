# credit for solution: article
# Better Programming - Devise Auth Setup in Rails 7 by Nick Francisci
# https://betterprogramming.pub/devise-auth-setup-in-rails-7-44240aaed4be
# credit for solution: video
# Go Rails -  How to use Devise with Hotwire & Turbo.js by Chris Oliver
# https://gorails.com/episodes/devise-hotwire-turbo

#######################################################################
# TECH DEBT: Remove when version of Devise is released that integrates
#            with Turbo without requiring workarounds
#######################################################################
class TurboDeviseController < ApplicationController
  class Responder < ActionController::Responder
    def to_turbo_stream
      controller.render(options.merge(formats: :html))
    rescue ActionView::MissingTemplate => e
      # raise the error if get?
      raise e if get?

      recover_from_devise_missing_template
    end

    private

      def recover_from_devise_missing_template
        # return with 422 or redirect otherwise
        if has_errors? && default_action
          render rendering_options.merge(formats: :html, status: :unprocessable_entity)
        elsif @controller.controller_name == "registrations" && @controller.action_name == "destroy"
          redirect_to "/"
        else
          redirect_to navigation_location
        end
      end
  end

  self.responder = Responder
  respond_to :html, :turbo_stream
end
