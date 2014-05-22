class HookListener < Redmine::Hook::ViewListener
  render_on :view_account_login_top, :partial => "hooks/sign_in_via_crowd_notice"

  def view_account_login_bottom(context = {})
    context[:controller].send(:render_to_string, {
        :partial => 'hooks/sign_in_via_crowd',
        :locals => context})
  end
end
