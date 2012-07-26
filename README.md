VandyMobile
===========

A mobile app for the Vanderbilt Mobile team.

### To set up your local environment: ###

This project uses [CocoaPods](http://cocoapods.org) to manage dependencies.  While you don't need CocoaPods to run the app 
(all dependencies are checked in) you'll need it if you want to add or update pods.

To install CocoaPods, run:

`(sudo) gem install cocoapods`

To add a new pod:

- Edit the `Podfile` and add your dependency.
- run `pod install`

Note:  Pods does not yet fully support the Podfile not living in the same directory as the xcodproj file.  This causes some
incorrect path issues, which can currently be resolved by manually editing the Copy Pods Resources script, and the `Pods.xcconfig file.
