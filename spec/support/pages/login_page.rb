class LoginPage
  include PageObject
  include MobilePage

  def login_with(email, password)
    mobile_platform.login_with(email, password)
  end
end
