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
    timeoutInterval: TimeInterval?
  ) async throws -> T
  
  func request<T: Codable>(
    urlString: String,
    method: HTTPMethod,
    headers: [String: String]?,
    timeoutInterval: TimeInterval?
  ) async throws -> T
}

@available(macOS 12.0, *)
@available(iOS 15.0.0, *)
public extension IzziRequestProtocol{
  func request<T: Codable, U: Codable>(
    urlString: String,
    method: HTTPMethod,
    body: U?
  ) async throws -> T {
    return try await request(
      urlString: urlString,
      method: method,
      headers: nil,
      body: body,
      timeoutInterval: nil
    )
  }
  
  func request<T: Codable>(
    urlString: String,
    method: HTTPMethod
  ) async throws -> T {
    return try await request(
      urlString: urlString,
      method: method,
      headers: nil,
      timeoutInterval: nil
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
    
    do {
      let encoder = JSONEncoder()
      encoder.keyEncodingStrategy = .convertToSnakeCase
      let jsonData = try encoder.encode(body)
      return (jsonData, "application/json")
    } catch {
      throw IzziRequestErrors.encodingError(error: error)
    }
  }
  
  @available(iOS 15, macOS 12.0, *)
  private func networkCall<T: Codable, U: Codable>(
    urlString: String,
    method: HTTPMethod,
    headers: [String: String]? = nil,
    body: U? = nil,
    timeoutInterval: TimeInterval?
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
    }
    
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw IzziRequestErrors.httpResponseError
    }
    
    guard (200...299).contains(httpResponse.statusCode) else {
      let responseBody = String(data: data, encoding: .utf8)
      throw IzziRequestErrors.statusCodeError(statusCode: httpResponse.statusCode, response: responseBody)
    }
    
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      return try decoder.decode(T.self, from: data)
    } catch {
      throw IzziRequestErrors.decodeError(error: error)
    }
  }
  
  @available(macOS 12.0, *)
  @available(iOS 15.0.0, *)
  public func request<T: Codable, U: Codable>(
    urlString: String,
    method: HTTPMethod,
    headers: [String: String]? = nil,
    body: U? = nil,
    timeoutInterval: TimeInterval? = nil
  ) async throws -> T {
    return try await networkCall(
      urlString: urlString,
      method: method,
      headers: headers,
      body: body,
      timeoutInterval: timeoutInterval
    )
  }
  
  @available(macOS 12.0, *)
  @available(iOS 15.0.0, *)
  public func request<T: Codable>(
    urlString: String,
    method: HTTPMethod,
    headers: [String: String]? = nil,
    timeoutInterval: TimeInterval? = nil
  ) async throws -> T {
    return try await networkCall(
      urlString: urlString,
      method: method,
      headers: headers,
      body: Optional<Data>.none,
      timeoutInterval: timeoutInterval
    )
  }
}
