require 'account_controller'

class CrowdOauthController < AccountController
  unloadable

  def callback
    find_or_register(request.env['omniauth.auth'])
  end

  def failure
    flash[:error] = l(params[:message])
    redirect_to :back
  end

  private
  def find_or_register(auth)
    if user = User.where(:mail => auth.info.email).first
      user.active? ? successful_authentication(user) : account_pending #(user)
    else
      user = User.new do |u|
        u.login = auth.uid
        u.mail = auth.info.email
        u.firstname = auth.info.first_name
        u.lastname = auth.info.last_name
        u.admin = false
        u.language = Setting.default_language
        u.random_password
        u.register
      end
      if Setting['plugin_redmine_crowd']['force_sign_up']=='false'
        account_registration(user)
      else
        register_automatically(user)
      end
    end
  end

  def account_registration(user)
    case Setting.self_registration
      when '1' # account activation by email
        register_by_email_activation(user)
      when '3' # automatic account activation
        register_automatically(user)
      else # manual account activation
        register_manually_by_administrator(user)
    end
  end
end
