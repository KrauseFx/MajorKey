# SendGrid-Swift

![swift4](https://img.shields.io/badge/swift-v4.0-green.svg) ![macOS](https://img.shields.io/badge/os-macOS-blue.svg) ![iOS](https://img.shields.io/badge/os-iOS-blue.svg) ![Linux\*](https://img.shields.io/badge/os-Linux\*-blue.svg)

This library allows you to quickly and easily send emails through SendGrid using Swift.

## Important: Version 1.0.0 Breaking Changes

Versions 1.0.0 and higher have been migrated to Swift 4 and adds Linux support, which contains code-breaking API changes.

**Previous Breaking Changes**

- Versions 0.2.0 and higher uses Swift 3, which introduces breaking changes from previous versions.
- Versions 0.1.0 and higher have been migrated over to use SendGrid's [V3 Mail Send Endpoint](https://sendgrid.com/docs/API_Reference/Web_API_v3/Mail/index.html), which contains code-breaking changes.

## \*A Note About Linux

While this library does function on Linux via the Swift Package Manager, it relies upon the [open source Foundation library](https://github.com/apple/swift-corelibs-foundation) (specifically `URLSession`).  As it stands, [`URLSession` hasn't been fully implemented yet](https://github.com/apple/swift-corelibs-foundation/blob/master/Docs/Status.md). While this library uses what has been implemented to make the HTTP requests, critical implementations such as invalidating the session are unavailable, which could lead to unexpected behaviors such as memory leaks. This being said, Linux supported in this library should be treated as *experimental*.

## Full Documentation

Full documentation of the library is available [here](http://scottkawai.github.io/sendgrid-swift/docs/).

## Table Of Contents

- [Installation](#installation)
    + [With Cocoapods](#with-cocoapods)
    + [Swift Package Manager](#swift-package-manager)
    + [As A Submodule](#as-a-submodule)
- [Usage](#usage)
    + [Authorization](#authorization)
    + [API Calls](#api-calls)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Installation

### With Cocoapods

Add the following to your Podfile:

```ruby
pod 'SendGrid', :git => 'https://github.com/scottkawai/sendgrid-swift.git'
```

### Swift Package Manager

Add the following to your Package.swift:

```swift
// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        .package(
            url: "https://github.com/scottkawai/sendgrid-swift.git",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "MyApp",
            dependencies: ["SendGrid"])
    ]
)
```

**Note!** Make sure you also list "SendGrid" as a dependency in the "targets" section of your manifest.

### As A Submodule

Add this repo as a submodule to your project and update:

```shell
cd /path/to/your/project
git submodule add https://github.com/scottkawai/sendgrid-swift.git
```

This will add a `sendgrid-swift` folder to your directory. Next, you need to add all the Swift files under `/sendgrid-swift/Sources/` to your project.

## Usage

### Authorization

The V3 endpoint supports authorization via API keys (preferred) and basic authentication via your SendGrid username and password (*Note:* the Mail Send API only allows API keys). Using the `Session` class, you can configure an instance with your authorization method to be used over and over again to send email requests:

It is also highly recommended that you do not hard-code any credentials in your code. If you're running this on Linux, it's recommended that you use environment variables instead, like so:

```swift
///
/// Assuming you set your SendGrid API key as an environment variable
/// named "SG_API_KEY"...
///
let session = Session()
guard let myApiKey = ProcessInfo.processInfo.environment["SG_API_KEY"] else { 
    print("Unable to retrieve API key")
    return
}
session.authentication = Authentication.apiKey(myApiKey)

///
/// Alternatively `Session` has a singleton instance that you can 
/// configure once and reuse throughout your code.
///
///     Session.shared.authentication = Authentication.apiKey(myApiKey)
```

### API Calls

All the available API calls are located in their own folders under the `./Sources/SendGrid/API` folder, and each one has its own README explaining how to use it. Below is a list of the currently available API calls:

- Statistics
    + [Global Stats](http://scottkawai.github.io/sendgrid-swift/docs/Structs/Statistic/Global.html)
    + [Category Stats](http://scottkawai.github.io/sendgrid-swift/docs/Structs/Statistic/Category.html)
    + [Subuser Stats](http://scottkawai.github.io/sendgrid-swift/docs/Structs/Statistic/Subuser.html)
- Subuser API
    + [Get](http://scottkawai.github.io/sendgrid-swift/docs/Structs/Subuser/Get.html)
- Suppressions
    + Blocks API
        * [Get](http://scottkawai.github.io/sendgrid-swift/docs/Structs/Block.html#/s:8SendGrid5BlockV3GetC)
        * [Delete](http://scottkawai.github.io/sendgrid-swift/docs/Structs/Block/Delete.html)
    + Bounces API
        * [Get](http://scottkawai.github.io/sendgrid-swift/docs/Structs/Bounce.html#/s:8SendGrid6BounceV3GetC)
        * [Delete](http://scottkawai.github.io/sendgrid-swift/docs/Structs/Bounce/Delete.html)
    + Invalid Emails API
        * [Get](http://scottkawai.github.io/sendgrid-swift/docs/Structs/InvalidEmail.html#/s:8SendGrid12InvalidEmailV3GetC)
        * [Delete](http://scottkawai.github.io/sendgrid-swift/docs/Structs/InvalidEmail/Delete.html)
    + Global Unsubscribes API
        * [Get](http://scottkawai.github.io/sendgrid-swift/docs/Structs/GlobalUnsubscribe.html#/s:8SendGrid17GlobalUnsubscribeV3GetC)
        * [Add](http://scottkawai.github.io/sendgrid-swift/docs/Structs/GlobalUnsubscribe/Add.html)
        * [Delete](http://scottkawai.github.io/sendgrid-swift/docs/Structs/GlobalUnsubscribe/Delete.html)
    + Spam Reports API
        * [Get](http://scottkawai.github.io/sendgrid-swift/docs/Structs/SpamReport.html#/s:8SendGrid10SpamReportV3GetC)
        * [Delete](http://scottkawai.github.io/sendgrid-swift/docs/Structs/SpamReport/Delete.html)
- [Mail Send](http://scottkawai.github.io/sendgrid-swift/docs/Classes/Email.html)

## Development

If you're developing on macOS, you an generate an Xcode project by running the following:

```shell
cd /path/to/sendgrid-swift
swift package generate-xcodeproj
```

This project also contains a Dockerfile and a docker-compose.yml file which runs Ubuntu 16.04 with Swift 4 installed. Running `docker-compose up` will execute the `swift build` command in the Linux container. If you want to run other commands, you can run `docker-compose run --rm app <command>`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-fancy-new-feature`)
3. Commit your changes (`git commit -am 'Added fancy new feature'`)
4. Write tests for any changes and ensure existing tests pass
    - **Note!** Be sure that your changes also work on Linux. You can use the Docker container to quickly test this by running `docker-compose run --rm app swift test`
5. Push to the branch (`git push origin my-fancy-new-feature`)
6. Create a new Pull Request

## License

The MIT License (MIT)

Copyright (c) 2017 Scott K.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.