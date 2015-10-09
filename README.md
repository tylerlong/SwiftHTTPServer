# About

A tiny http server engine written in Swift programming language.

The code is based on [glock45/swifter](https://github.com/glock45/swifter) and subject to the same license as the original project.

This project is compatible with Carthage.


### How to start ?

```swift
let server = HttpServer()
server["/hello"] = { .OK(.HTML("You asked for " + $0.url)) }
server.start()

```


### How to share files ? 

```swift
let server = HttpServer()
server["/home/(.+)"] = HttpHandlers.directory("~/")
server.start()
```


### How to redirect ?

```swift
let server = HttpServer()
server["/redirect"] = { request in
  return .MovedPermanently("http://www.google.com")
}
server.start()
```


### Carthage ? Yes.

```
github "tylerlong/SwiftHTTPServer"
```
