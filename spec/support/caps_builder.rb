module CapabilityBuilder

  def capabilities(options = {})
    caps = {}
    case ENV['PLATFORM']
    when 'ANDROID'
      caps[:platformName] = 'android'
      caps[:deviceName] = 'Android Emulator'
      caps[:noSign] = true
    when 'IOS'
      caps[:platformName] = 'iOS'
      caps[:deviceName] = 'iPhone Simulator'
      caps[:autoAcceptAlerts] = true
      caps[:udid] = ENV['UDID']
    else
      raise('Unsupported mobile platform. Provide valid (ANDROID or IOS) PLATFORM environment variable')
    end
    caps[:app] = ENV['APP']
    caps[:deviceType] = ENV['DEVICE_TYPE'] || 'phone'
    raise('Provide env variable APP with absolute path to the file with Spotify app ') unless caps[:app]
    caps.merge!(options)
    caps.delete_if { |k, v| v.to_s.empty? }
  end
end
