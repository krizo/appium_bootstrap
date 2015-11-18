# appium_bootstrap
Simple bootstrap for starting developing mobile UI tests in appium with rspec.

It contains file structure, rspec configuration, page objects, all required gems and a simple spec as an example. Everything needed to start writing tests for a new mobile automation project.

### Setup

1. Clone Appium repository: `git clone https://github.com/appium/appium.git`
2. Make sure you have node installed
    ```
    #> node -v
    v0.10.32
    
    #> npm -v
    3.3.9
    ```
    If not, install it from homebrew `brew install node`
3. Make sure you have [ideviceinstaller](https://github.com/libimobiledevice/ideviceinstaller) - app manager for iOS to install, upgrade, archive, restore the app. 
  If not:
  `brew install --HEAD ideviceinstaller`
4. Make sure you have ant installed

    ```
    #> ant -version
    Apache Ant(TM) version 1.9.6 compiled on June 29 2015
    ```

    If not install it from homebrew `brew install ant`
5. Make sure you have Android SDK API 16+ installed.
    Run `android sdk update` to open sdk manager.
6. Run `./reset.sh` in the appium dir.
7. To start the appium server run `node .`
8. You will need ruby version 2.1+


### Basic usage
 Make sure appium server is running, run it if it is not `node .`
 Go to your tests dir.
 To run the tests run
 ```
    PLATFORM=ANDROID|IOS
    APP=/Absolute/Path/To/The/App
    rspec <path-to-the-spec>
```

### Developing guide
#### Specs
Your spec files should contain only a test flow - business logic to be ran. The implemantion of particular steps goes in platform-specific code. See Page objects section.
``` ruby
describe "Reports regression" do
  before(:all) do
    # setup stuff
  end
  
  describe "Total Sales" do
    it "Login first" do
      on(LoginPage).login_with("my_email@example.com", "my_password")
    end

    it "Go to reports" do
      on(NavigationPage).go_to('reports')
    end

    it 'Checks total sales' do
      expect(on(ReportPage).get_total_sales_value).to eq 1000
    end
    #...
```
#### Page objects
This pattern allows you to keep your implementation separated from business logic and also to be specific for particular platform (Android, iOS). Sometimes a business function required different steps to be performed on different platforms, so that's another benefit of keeping it separated. 
Follow this pattern to keep pages files in order:
```
.
.
├── Gemfile
├── Gemfile.lock
└── spec
    ├── login_spec.rb
    ├── spec_helper.rb
    └── support
        ├── caps_builder.rb
        ├── mobile_page.rb
        └── pages
            ├── reports
            │   ├── android
            │   │   └── reports_page.rb <- implementation for android
            │   └── ios
            │       └── reports_page.rb <- implementation for ios
            └── reports_page.rb  <- general Login Page interface
```
##### Your page interface 
``` ruby
class ReportsPage
  include PageObject
  include MobilePage

  def get_total_sales_value
    mobile_platform.get_total_sales_value
  end
  #...
end
```

###### Page implementation for Android:
``` ruby
module Android
  class ReportsPage
    include PageObject

    def get_total_sales_value
      xpath("//android.widget.TextView[@text='TOTAL SALES']/..//android.widget.TextSwitcher[1]/android.widget.TextView").text
    end
  end
end
```
##### Page implementation for iOS:
``` ruby
module IOS
  class ReportsPage
    include PageObject
    
    paragraph(:total_sales, xpath: "//UIAStaticText[@name='TOTAL SALES']")

    def get_total_sales_value
      total_sales
    end
  end
end
```





