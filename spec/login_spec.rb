require 'spec_helper'

describe "Login" do
  it "logins to specific platform" do
    on(LoginPage).login_with("login@example.com", "mypassword")
  end
end
