![Image](https://github.com/user-attachments/assets/7a840238-79ea-4a79-99c8-5bea1f1dcb33)

# izziRequest 

**IzziRequest**  is a super lightweight Swift package that helps you efficiently manage network calls in your application. It supports all key aspects of modern networking, including HTTP methods, request bodies, headers, timeout control, and flexible caching.

![Static Badge](https://img.shields.io/badge/Swit-6.0-orange) ![Static Badge](https://img.shields.io/badge/iOS-16.6%2B-white) ![Static Badge](https://img.shields.io/badge/Version%20-%203.0.0-skyblue) ![Static Badge](https://img.shields.io/badge/LICENSE-MIT-yellow) ![Static Badge](https://img.shields.io/badge/SPM-SUCCESS-green)

## Features 🚀  
- **Flexible code**  
- **Support for HTTP methods:** GET, POST, PUT, PATCH, DELETE  
- **Customizable timeoutInterval** to prevent the app from freezing  
- **Supports file upload using multipart requests**  
- **Caching for GET requests to optimize performance.**
- **Customizable caching duration.**
- **Supports auto encoding and decoding to snake_case**  
- **Well-defined error handling**  
- **Works with any `Codable` model using generics**  
- **Uses `async/await` for better performance**  
- **Automatically sets `Content-Type` based on the request body**  
- **Supports custom headers for additional flexibility**  

## API Reference
 
| Parameter         | Type                 | Description                                           | Default |
|------------------|----------------------|-------------------------------------------------------|---------|
| `urlString`       | `String`             | API endpoint URL.                                     | N/A     |
| `method`          | `HTTPMethod`         | HTTP request method.                                  | N/A     |
| `body`            | `Codable`            | Request payload.                                      | N/A     |
| `headers`         | `[String: String]`   | HTTP headers.                                         | N/A     |
| `timeoutInterval` | `TimeInterval`       | Request timeout duration.                             | nil     |
| `useCache`        | `Bool`               | Enables caching for GET requests.                     | false   |
| `convertToCamelcase`        | `Bool`               | Enables conversion of JSON keys from snake_case to camelCase during decoding.                     | true   |
| `cacheExpiry`     | `TimeInterval`       | Cache validity duration.                              | 300.0   |

## 🐍➡️🐪 Auto Encoding & Decoding to Camel Case  

When you have a request model using `snake_case`, it automatically converts to `camelCase` in Swift.  

```json
{
  "first_name": "Hablo",
  "last_name": "Escobar"
}
```
Swift decodes it as:

```swift
struct MyModel: Codable {
    let firstName: String
    let lastName: String
}
```


## 📖 IzziRequest Usage Guide  

By default, **IzziRequest** has a **timeout interval of 30 seconds** to prevent the app from freezing.  

To start using **IzziRequest**, inject it into your `ViewModel`:  

```swift
import IzziRequest

final class ViewModel {
  private let izziReq: IzziRequestProtocol
  
  init(izziReq: IzziRequestProtocol = IzziRequest()) {
    self.izziReq = izziReq
  }
}
```
⏳ If you want to set a custom timeout interval, you can do it like this:

```swift
import IzziRequest

final class ViewModel {
  private let izziReq: IzziRequestProtocol
  
  init(izziReq: IzziRequestProtocol = IzziRequest(defaultTimeout: 60)) {
    self.izziReq = izziReq
  }
}
```
### GET Method  

#### 🟢 Simple GET Request  
A basic GET request without headers or custom timeout.  

```swift
let api = "http://localhost:3002/get_method"
  
func foo() {
   Task {
     do {
       let response: MyResponseModel =  try await izziReq.request(urlString: api, method: .GET)
       print(response)
     } catch {
       print(error)
     }
   }
 }
```
#### 🟢 GET Request with Headers
Pass custom headers, such as an authorization token.

```swift
let api = "http://localhost:3002/get_method"
let headers = ["Authorization" : "Bearer token"]
  
func foo() {
    Task {
      do {
        let response: MyResponseModel =  try await izziReq.request(
          urlString: api,
          method: .GET,
          headers: headers
        )
        print(response)
      } catch {
        print(error)
      }
    }
  }

```
#### 🟢 GET Request with Headers and Custom Timeout
Specify a custom timeout interval (e.g., 120 seconds).

```swift
let api = "http://localhost:3002/get_method"
let headers = ["Authorization" : "Bearer token"]
let interval: TimeInterval = 120
  
func foo() {
    Task {
      do {
        let response: MyResponseModel =  try await izziReq.request(
          urlString: api,
          method: .GET,
          headers: headers,
          timeoutInterval: interval
        )
        print(response)
      } catch {
        print(error)
      }
    }
  }

```





### POST Method  

#### 🟡 POST Request with Headers and Body  
Send a POST request with headers and a request body.  

```swift
let api = "http://localhost:3002/post_method"
let headers = ["Authorization" : "Bearer token"]
let reqBody = LoginModel(email: "example@test.com", password: "12345678")
  
func foo() {
    Task {
      do {
        let response: MyResponseModel =  try await izziReq.request(
          urlString: api,
          method: .POST,
          headers: headers,
          body: reqBody
        )
        print(response)
      } catch {
        print(error)
      }
    }
  }

```

#### 🟡 POST Request with Headers, Body, and Custom Timeout
Set a custom timeout interval (e.g., 15 seconds).

```swift
  let api = "http://localhost:3002/post_method"
  let headers = ["Authorization" : "Bearer token"]
  let reqBody = LoginModel(email: "example@test.com", password: "12345678")
  let interval: TimeInterval = 15
  
  func foo() {
    Task {
      do {
        let response: MyResponseModel =  try await izziReq.request(
          urlString: api,
          method: .POST,
          headers: headers,
          body: reqBody,
          timeoutInterval: interval
        )
        print(response)
      } catch {
        print(error)
      }
    }
  }
```

### 💡 You can also use the DELETE, PUT, and PATCH methods, just like we had above with the GET and POST methods.


## 💾 Caching
#### GET method with caching
use with default cacheExpiry duration (5 minutes)
``` swift
  let api = "http://localhost:3002/get_method_with_caching"
  
  func foo() {
    Task {
      do {
        let response: MyResponseModel =  try await izziReq.request(
          urlString: api,
          method: .GET,
          useCache: true
        )
        print(response)
      } catch {
        print(error)
      }
    }
  }
```

or use with custom cacheExpiry duration
``` swift
  let api = "http://localhost:3002/get_method_with_caching"
  
  func foo() {
    Task {
      do {
        let response: MyResponseModel =  try await izziReq.request(
          urlString: api,
          method: .GET,
          useCache: true,
          cacheExpiry: 600.0
        )
        print(response)
      } catch {
        print(error)
      }
    }
  }
```


## 🖥️  Installation via Swift Package Manager 
- **Open your project.**
- **Go to File → Add Package Dependencies.**
- **Enter URL: https://github.com/Desp0o/izziRequest.git.**
- **Click Add Package.**
