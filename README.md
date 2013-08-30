# BrightCenter SDK

## Install cocoapods

Make sure you have Ruby gem by running `gem --version`.

Install cocoapods

    $ sudo gem install cocoapods
    $ pod setup

See also: http://cocoapods.org


## To integrate this SDK into your educational app

Go to your XCode project directory and create a text file called `PodFile` with the following contents:

    platform :ios, '5.0'
    pod 'BrightCenterSDK', '~> 1.0.2'

Now open a terminal and change to your XCode project directory. Run the command `pod install`. That's it!
Open the generated YourApp.xcworkspace file with XCode or AppCode (instead of YourApp.xcodeproj).


## For developers of this SDK

Get the dependencies by running `pod install`.

Open the generated BrightCenterSDK.xcworkspace in XCode or AppCode (instead of BrightCenterSDK.xcodeproj)

Run the project in the iPad Simulator or on an actual iPad. For now no connection to the backend is made. Login with "leraar" with no password to access the dummy content.
