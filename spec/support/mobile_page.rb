module MobilePage
  include PageObject::PageFactory

  attr_reader :mobile_platform

  def initialize_page
    include_mobile_platform
  end

  def method_missing(m, *args, &block)
    mobile_platform.send(m, *args, &block)
  end

  private

  def include_mobile_platform
    case $driver.appium_device
    when :android
      @mobile_platform = on("Android::#{self.class}")
    when :ios
      @mobile_platform = on("IOS::#{self.class}")
    else
      raise('Unsupported mobile platform')
    end
    Appium.promote_appium_methods(@mobile_platform.class)
  end
end
