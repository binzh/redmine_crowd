require 'redmine'

Redmine::Plugin.register :redmine_crowd do
  name 'Redmine Crowd Plugin'
  author 'BinZH'
  description 'Atlassian Crowd single sign-on service authentication support for Redmine.'
  version '1.0.0'
  url 'https://github.com/binzh/redmine_crowd'
  author_url 'http://binzh.github.io'

  require 'hook_listener'

  settings :default => {:force_sign_up => true, :close_system_login => false}, :partial => 'settings/redmine_crowd_setting'

  add_menu_item :account_menu, :sign_in_via_crowd, '/auth/crowd', :caption => :sign_in_via_crowd, :first => true, :if => Proc.new { !User.current.logged? }
  delete_menu_item :account_menu, :login
  delete_menu_item :account_menu, :register
  add_menu_item :account_menu, :login, :signin_path, :if => Proc.new { !User.current.logged? && Setting['plugin_redmine_crowd']['close_system_login']!='true' }
  add_menu_item :account_menu, :register, :register_path, :if => Proc.new { !User.current.logged? && Setting.self_registration? && Setting['plugin_redmine_crowd']['close_system_login']!='true' }

end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :crowd, :crowd_server_url => "<crowd_server_url>", :application_name => "<application_name>", :application_password => "<application_password>"
end

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}