
# izziRequest 

**IzziRequest** is a super lightweight Swift package that helps you efficiently manage network calls in your application.  

## Features 🚀  
- **Flexible code**  
- **Support for HTTP methods:** GET, POST, PUT, PATCH, DELETE  
- **Customizable timeoutInterval** to prevent the app from freezing  
- **Supports file upload using multipart requests**  
- **Supports auto encoding and decoding to snake_case**  
- **Well-defined error handling**  
- **Works with any `Codable` model using generics**  
- **Uses `async/await` for better performance**  
- **Automatically sets `Content-Type` based on the request body**  
- **Supports custom headers for additional flexibility**  

## API Reference
 
| Parameter        | Type                   | Description                         |
| :-------------- | :-------------------- | :---------------------------------- |
| `urlString`     | `String`              | API endpoint URL.     |
| `method`        | `HTTPMethod`          | HTTP request method.  |
| `body`          | `Codable`             | Request payload.      |
| `headers`       | `[String: String]`    | HTTP headers.         |
| `timeoutInterval` | `TimeInterval`      | Request timeout.      |

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
final class ViewModel {
  private let izziReq: IzziRequest
  
  init(izziReq: IzziRequest = IzziRequest()) {
    self.izziReq = izziReq
  }
}
```
⏳ If you want to set a custom timeout interval, you can do it like this:

```swift
final class ViewModel {
  private let izziReq: IzziRequest
  
  init(izziReq: IzziRequest = IzziRequest(defaultTimeout: 60)) {
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
🟡 POST Request with Headers, Body, and Custom Timeout

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

#### 💡 You can also use the DELETE, PUT, and PATCH methods, just like we had above with the GET and POST methods.

## 🖥️  Installation via Swift Package Manager 
- **Open your project.**
- **Go to File → Add Package Dependencies.**
- **Enter URL: https://github.com/Desp0o/izziRequest.git.**
- **Click Add Package.**
