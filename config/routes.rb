RedmineApp::Application.routes.draw do
  get '/auth/:provider/callback', :to => 'crowd_oauth#callback'
  get '/auth/failure' , :to => 'crowd_oauth#failure'
end
