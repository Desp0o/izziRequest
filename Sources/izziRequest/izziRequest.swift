// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@available(macOS 12.0, *)
@available(iOS 15.0.0, *)
public protocol IzziRequestProtocol {
  func request<T: Codable, U: Codable>(
    urlString: String,
    method: HTTPMethod,
    headers: [String: String]?,
    body: U?,
    timeoutInterval: TimeInterval?,
    useCache: Bool,
    cacheExpiry: TimeInterval,
    convertToCamelcase: Bool
  ) async throws -> T
  
  func request<T: Codable>(
    urlString: String,
    method: HTTPMethod,
    headers: [String: String]?,
    timeoutInterval: TimeInterval?,
    useCache: Bool,
    cacheExpiry: TimeInterval,
    convertToCamelcase: Bool
  ) async throws -> T
}

@available(macOS 12.0, *)
@available(iOS 15.0.0, *)
public extension IzziRequestProtocol {
  func request<T: Codable, U: Codable>(
    urlString: String,
    method: HTTPMethod,
    body: U?,
    useCache: Bool = false,
    cacheExpiry: TimeInterval = 300.0,
    convertToCamelcase: Bool = true
  ) async throws -> T {
    return try await request(
      urlString: urlString,
      method: method,
      headers: nil,
      body: body,
      timeoutInterval: nil,
      useCache: useCache,
      cacheExpiry: cacheExpiry,
      convertToCamelcase: convertToCamelcase
    )
  }
  
  func request<T: Codable>(
      urlString: String,
      method: HTTPMethod,
      headers: [String: String]?,
      useCache: Bool = false,
      cacheExpiry: TimeInterval = 300.0,
      convertToCamelcase: Bool = true
    ) async throws -> T {
      return try await request(
        urlString: urlString,
        method: method,
        headers: headers,
        timeoutInterval: nil,
        useCache: useCache,
        cacheExpiry: cacheExpiry,
        convertToCamelcase: convertToCamelcase
      )
    }
  
  func request<T: Codable>(
    urlString: String,
    method: HTTPMethod,
    useCache: Bool = false,
    cacheExpiry: TimeInterval = 300.0,
    convertToCamelcase: Bool = true
  ) async throws -> T {
    return try await request(
      urlString: urlString,
      method: method,
      headers: nil,
      timeoutInterval: nil,
      useCache: useCache,
      cacheExpiry: cacheExpiry,
      convertToCamelcase: convertToCamelcase
    )
  }
}

public final class IzziRequest: IzziRequestProtocol {
  private let defaultTimeout: TimeInterval

  
  public init(defaultTimeout: TimeInterval = 30.0) {
    self.defaultTimeout = defaultTimeout
  }
  
  private func encodeBody<U: Encodable>(_ body: U?) throws -> (Data?, String)? {
    guard let body = body else { return (nil, "") }
    
    if let fileBody = body as? Data {
      return (fileBody, "application/octet-stream")
    }
    
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    let jsonData = try encoder.encode(body)
    return (jsonData, "application/json")
  }
  
  private func cacheKey(for request: URLRequest) -> String? {
    return request.url?.absoluteString
  }
  
  private func currentDateString() -> String {
    HTTPDateFormatter().string(from: Date())
  }
  
  @available(iOS 15, macOS 12.0, *)
  private func networkCall<T: Codable, U: Codable>(
    urlString: String,
    method: HTTPMethod,
    headers: [String: String]? = nil,
    body: U? = nil,
    timeoutInterval: TimeInterval?,
    useCache: Bool,
    cacheExpiry: TimeInterval,
    convertToCamelcase: Bool
  ) async throws -> T {
    guard let url = URL(string: urlString) else {
      throw IzziRequestErrors.invalidURL(url: urlString)
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.rawValue
    urlRequest.timeoutInterval = timeoutInterval ?? defaultTimeout
    
    if let (bodyData, contentType) = try encodeBody(body) {
      urlRequest.httpBody = bodyData
      var updatedHeaders = headers ?? [:]
      updatedHeaders["Content-Type"] = contentType
      for (key, value) in updatedHeaders {
        urlRequest.setValue(value, forHTTPHeaderField: key)
      }
    } else if let headers = headers {
      for (key, value) in headers {
        urlRequest.setValue(value, forHTTPHeaderField: key)
      }
    }
    
    if useCache, method == .GET {
      let cache = URLCache.shared
      if let cachedResponse = cache.cachedResponse(for: urlRequest),
         let httpResponse = cachedResponse.response as? HTTPURLResponse {
        
        if let dateHeader = httpResponse.value(forHTTPHeaderField: "Date"),
           let responseDate = HTTPDateFormatter().date(from: dateHeader),
           Date().timeIntervalSince(responseDate) < cacheExpiry {
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = convertToCamelcase ? .convertFromSnakeCase : .useDefaultKeys
          return try decoder.decode(T.self, from: cachedResponse.data)
        }
      }
    }
    
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw IzziRequestErrors.httpResponseError
    }
    
    guard (200...299).contains(httpResponse.statusCode) else {
      let responseBody = String(data: data, encoding: .utf8)
      throw IzziRequestErrors.statusCodeError(statusCode: httpResponse.statusCode, response: responseBody)
    }
    
    if useCache, method == .GET {
      var newHeaders = (response as? HTTPURLResponse)?.allHeaderFields as? [String: String] ?? [:]
      newHeaders["Date"] = currentDateString()
      let modifiedResponse = HTTPURLResponse(
        url: url,
        statusCode: httpResponse.statusCode,
        httpVersion: "HTTP/1.1",
        headerFields: newHeaders
      ) ?? httpResponse
      
      let cachedResponse = CachedURLResponse(response: modifiedResponse, data: data)
      URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
    }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = convertToCamelcase ? .convertFromSnakeCase : .useDefaultKeys
    return try decoder.decode(T.self, from: data)
  }
  
  @available(macOS 12.0, *)
  @available(iOS 15.0.0, *)
  public func request<T: Codable, U: Codable>(
    urlString: String,
    method: HTTPMethod,
    headers: [String: String]? = nil,
    body: U? = nil,
    timeoutInterval: TimeInterval? = nil,
    useCache: Bool = false,
    cacheExpiry: TimeInterval = 60,
    convertToCamelcase: Bool = true
  ) async throws -> T {
    return try await networkCall(
      urlString: urlString,
      method: method,
      headers: headers,
      body: body,
      timeoutInterval: timeoutInterval,
      useCache: useCache,
      cacheExpiry: cacheExpiry,
      convertToCamelcase: convertToCamelcase
    )
  }
  
  @available(macOS 12.0, *)
  @available(iOS 15.0.0, *)
  public func request<T: Codable>(
    urlString: String,
    method: HTTPMethod,
    headers: [String: String]? = nil,
    timeoutInterval: TimeInterval? = nil,
    useCache: Bool = false,
    cacheExpiry: TimeInterval = 60,
    convertToCamelcase: Bool = true
  ) async throws -> T {
    return try await networkCall(
      urlString: urlString,
      method: method,
      headers: headers,
      body: Optional<Data>.none,
      timeoutInterval: timeoutInterval,
      useCache: useCache,
      cacheExpiry: cacheExpiry,
      convertToCamelcase: convertToCamelcase
    )
  }
}

final class HTTPDateFormatter: DateFormatter, @unchecked Sendable {
  override init() {
    super.init()
    self.locale = Locale(identifier: "en_US_POSIX")
    self.timeZone = TimeZone(secondsFromGMT: 0)
    self.dateFormat = "EEE',' dd MMM yyyy HH':'mm':'ss z"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
