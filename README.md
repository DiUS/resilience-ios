resilience-ios
==============

Installation
------------
The resilience build requires XCode 4.5+ and ruby 1.9.x with [bundler](http://gembundler.com/).
````
bundle install
bundle exec rake setup
````
This will generate Resilience/Resilience.xcworkspace which you can then open in XCode / AppCode.

Building artifacts
--------

### To build:
Edit the Rakefile to change the value of 'main_builder.identity' to be the name of the developer certificate you downloaded from the iOS Provisioning Portal. The easy way to do this is find the certificate in your Keychain (hint: it will begin with "iPhone Developer:"), ctrl-click Get Info, and copy the common name.

Then:
````
rake debug:build
````
### To run unit tests:
````
rake debug:test
````
### To upload to testflight:
````
rake debug:testflight
````
