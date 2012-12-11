class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper  # make the module SessionHelper available in Controllers; it is automatically available in views/session
end
