# LRConnection

[![Pod Version](http://img.shields.io/cocoapods/v/LRConnection.svg?style=flat)](https://cocoapods.org/pods/LRConnection)
[![Pod Platform](http://img.shields.io/cocoapods/p/LRConnection.svg?style=flat)](https://cocoapods.org/pods/LRConnection)
[![Pod License](http://img.shields.io/cocoapods/l/LRConnection.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0.html)

LRConnection is an HTTP library that makes networking for iOS easier

## Installation
* Podfile
```ruby
pod 'LRConnection'
```
* Manually
> add LRConnection.framework to "General->Embedded Binaries"

## Requirements
Minimum iOS 8.0

## Making HTTP Requests
* Objective-C
```objective-c
LRConnectionManager *manager = [LRConnectionManager sharedManager];
[manager requestURL:urlString method:LRHTTPMethodGET params:params progress:nil success:^(NSData * _Nonnull data) {
    // success callback
} failure:^(NSError * _Nonnull error) {
    // failure callback
}];
```
* Swift
```swift
let manager = LRConnectionManager.shared()
manager.requestURL(urlString, method: .GET, params: params, progress: nil, success: { (data) in
    // success callback
}, failure: { (error) in
    // failure callback
})
```
