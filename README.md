# ATSimulatorTools

## Introduction

ATSimulatorTools is a package that can help you manage your simulator.
If you write tests, especially integration tests, you probably bumped into issues with permissions.
For example, you want to sync your data with the calendar or the reminders app, but you need to grant permissions.

With ATSimulatorTools, that can be achieved with only one line of code.

## Installation

### Swift Pacakge Manager

To use ATSimulatorTools with the Swift Package Manager, add a dependency to your Package.swift file:

```
let package = Package(
  dependencies: [
    .package(url: "https://github.com/AviTsadok/ATSimulatorTools", .upToNextMajor(from: "1.0.0"))
  ]
)
```

## Usage

The usage of ATSimulatorTools is very easy - as I said, it's only one line of code.

To grant access to the calendar, just do:

```
try ATSimulatorTools().grantAccess(toPermission: .calendar, allowd: true)
```

And that's it.

## How Does It Work?

If you work with Simulator, your app permissions are saved in a Sqlite3 file, somewhere in your derived data. What the package does, is updating this file according to the parameters the function received.
This may not be the official way, but it does help in many situations when testing.
