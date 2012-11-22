resilience-ios
==============

Installation
------------
The resilience build requires XCode 4.5+ and ruby 1.9.x with bundler.
````
gem install xcoder
gem install cocoapods
cd Resilience
pod install
````
Building
--------

### To build and run unit tests:
````
rake debug:build
````
### To upload to testflight:
````
rake debug:testflight
````
XCode / AppCode
---------------
open the Resilience workspace: `Resilience.xcworkspace`