class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def app
    render component: 'App', props: {  }, prerender: false
  end

end
