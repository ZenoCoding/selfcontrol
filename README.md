# Tycho’s SelfControl fork

Personal fork with daily downtime scheduling, protected schedule disabling, and local Apple Development signing. The original project documentation follows below.

## Build this fork

Install Xcode and CocoaPods, run `pod install`, then `scripts/build-local.sh`. If the command-line tools are selected instead of Xcode, set `DEVELOPER_DIR` to the installed Xcode app’s `Contents/Developer` directory (for example `/Applications/Xcode-beta.app/Contents/Developer`).

The signed build requires an unlocked keychain containing an Apple Development identity for team `RSNC24Q9XR`. Set `SELFCONTROL_SIGN_IDENTITY` to select a particular identity. The app and its privileged helper require matching signatures; an ad-hoc build is insufficient for normal helper installation. The build script uses a macOS 12 deployment target for compatibility with Xcode 27.

Output: `build/DerivedData/Build/Products/Debug/SelfControl.app`.

---

# [SelfControl][website]

<p align="center">
    <img src="./.github/docs/screenshot.png" />
</p>

## About

SelfControl is a free and open-source application for macOS that lets you block **your own** access to distracting websites, your mail servers, or anything else on the Internet. Just set a period of time to block for, add sites to your blocklist, and click "Start Block". Until that timer expires, you will be unable to access those sites—even if you restart your computer or delete the application.

## Credits

Developed by [Charlie Stigler](http://charliestigler.com), [Steve Lambert](http://visitsteve.com), and [others](https://github.com/SelfControlApp/selfcontrol/graphs/contributors). Your contributions very welcome!

SelfControl is now available in 12 languages thanks to [the fine translators credited here](https://github.com/SelfControlApp/selfcontrol/wiki/Translation-Credits).

## License

SelfControl is free software under the GPL. See [this file](./COPYING) for more details.

## Building For Development

Users should always download the latest version of SelfControl from [our website][website]. If you want to contribute to SelfControl, you'll need to learn to build it for development. This can only be done on a Mac running a modern version of macOS.

1. Clone the SelfControl repo from GitHub.
2. Make sure you have a recent version of Xcode and the Xcode command-line tools installed.
3. Install [CocoaPods](https://cocoapods.org/): `sudo gem install cocoapods`
4. Install the SelfControl dependencies using CocoaPods: `pod install`
5. Open the `selfcontrol.xcworkspace` file (**NOT** `selfcontrol.xcodeproj`)
6. Build and run (you may need to update/remove code signing settings to make it build properly)

[website]: https://selfcontrolapp.com/
