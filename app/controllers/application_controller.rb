class ApplicationController < ActionController::Base

  def not_found
    render html: "404| Resource not found: '#{params[:path]}'", status: :not_found
  end
end
