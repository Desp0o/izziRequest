
public enum IzziRequestErrors: Error {
  case invalidURL(url: String)
  case httpResponseError
  case statusCodeError(statusCode: Int, response: String?)
  case noData
  case decodeError(error: Error)
  case encodingError(error: Error)
  case timeoutError
  
  public var description: String {
    switch self {
    case .invalidURL(let url):
      return "Invalid URL: \(url)"
    case .httpResponseError:
      return "Failed to receive a valid HTTP response."
    case .statusCodeError(let statusCode, let response):
      return "HTTP Error: Status code \(statusCode). Response: \(response ?? "No response body")"
    case .noData:
      return "No data received from the server."
    case .encodingError(let error):
      return "❌ Encoding error: \(error.localizedDescription)"
    case .timeoutError:
      return "❌ Request timed out."
    case .decodeError(let error):
      if let decodingError = error as? DecodingError {
        switch decodingError {
        case .keyNotFound(let key, _):
          return "❌ Missing key in JSON: \(key.stringValue)"
        case .typeMismatch(let type, let context):
          return "❌ Type mismatch for \(type): \(context.debugDescription)"
        case .valueNotFound(let type, let context):
          return "❌ Expected value of type \(type) but found nil: \(context.debugDescription)"
        case .dataCorrupted(let context):
          return "❌ Data corrupted: \(context.debugDescription)"
        @unknown default:
          return "❌ Unknown decoding error: \(error.localizedDescription)"
        }
      }
      return "❌ Decoding error: \(error.localizedDescription)"
    }
  }
}
