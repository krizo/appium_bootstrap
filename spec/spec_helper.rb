require 'page-object'
require 'page-object/page_factory'
require 'appium_lib'
require 'pry'
require 'require_all'

require_rel 'support'

RSpec.configure do |config|
  config.include PageObject::PageFactory
  config.include CapabilityBuilder

  config.before(:all) do
    config = {
      caps: capabilities,
      appium_lib: {
        debug: ENV['DEBUG'].to_s.downcase != 'false',
        wait: 0
      }
    }
    @browser = Appium::Driver.new(config).start_driver
    Appium.promote_appium_methods(RSpec::Core::ExampleGroup)
  end

  config.after(:each) do
    # Step debugger
    binding.pry if  ENV['PRY'] == 'all'
    # Debug failing steps
    binding.pry if (ENV['PRY'] == 'failing' && RSpec.current_example.exception)
    # Capture screenshot if exception
    @browser.save_screenshot (RSpec.current_example.description + ".png").gsub " ", "_" if (RSpec.current_example.exception && (ENV['SCREENSHOT'] == "true"))
  end

  config.after(:all) do
    @browser.quit unless @browser.nil?
  end
end
