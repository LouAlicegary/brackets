require "application_responder"

class ApiController < ActionController::Base

  # this is needed if using respond_with in controllers
  # TODO: What's the point of using an ApplicationResponder?
  self.responder = ApplicationResponder
  respond_to :json

  def not_found
    render nothing: true,  status: 404 and return
  end

end
