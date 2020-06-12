class ApplicationController < ActionController::Base

  def hello
    render html: "<h1> hello, world! <h1>"
  end
end
