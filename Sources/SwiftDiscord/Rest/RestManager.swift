//
// RestManager.swift
//
// Created by Raul Max on 08/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

class RestManager: Rest {
  private var session: URLSession {
    return URLSession(configuration: config.sessionConfiguration)
  }

  private var decoder: JSONDecoder {
    return JSONDecoder()
  }

  public let config: RestConfig

  init(config: RestConfig) {
    self.config = config
  }

  func get<T: Codable>(
    for type: T.Type,
    to route: DiscordEndpoints,
    completion: @escaping (HttpResponse<T>) -> Void
  ) {
    do {
      let request = try buildRequest(to: route.value, method: .GET)
      let task = execute(with: request) { [unowned self] data, response in
        let result = handleResult(T.self, for: (data, response))
        completion(result)
      }
      task.resume()
    } catch {
      Logger.log(.error, error)

      if let httpError = error as? HttpError {
        completion(
          HttpResponse<T>(statusCode: httpError.statusCode, body: nil, error: httpError)
        )
      } else {
        completion(
          HttpResponse<T>(statusCode: 0, body: nil, error: HttpError(error.localizedDescription))
        )
      }
    }
  }
}

// MARK: - Private
extension RestManager {
  private func buildRequest(to endPoint: String, with body: Data? = nil, method: HttpMethod) throws -> URLRequest {
    let url = "\(config.baseURL)\(endPoint)"

    guard let baseURL = URL(string: url) else {
      throw HttpError("Invalid URL: \(url)")
    }

    var request = URLRequest(url: baseURL)
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = config.headers

    if let body {
      request.httpBody = body
    }

    return request
  }

  private func execute(
    with request: URLRequest,
    completion: @escaping (Data, URLResponse) -> Void
  ) -> URLSessionDataTask {
    return session.dataTask(with: request) { data, response, error in
      guard let data, let response, error == nil else {
        let error = error ?? URLError(.badServerResponse)
        Logger.log(.error, "Couldn't complete the request, cause: \(error.localizedDescription)")
        return
      }

      completion(data, response)
    }
  }

  private func handleResult<T: Codable>(
    _ type: T.Type,
    for tupple: (data: Data, response: URLResponse)
  ) -> HttpResponse<T> {
    do {
      guard let response = tupple.response as? HTTPURLResponse else {
        return HttpResponse(statusCode: 0, body: nil, error: HttpError("No response"))
      }

      switch response.statusCode {
      case 200, 201, 304:
        let result = try decoder.decode(T.self, from: tupple.data)
        return HttpResponse(statusCode: response.statusCode, body: result, error: nil)
      default:
        let result = try decoder.decode(HttpError.self, from: tupple.data)
        return HttpResponse(statusCode: response.statusCode, body: nil, error: result)
      }
    } catch {
      return HttpResponse(
        statusCode: (tupple.response as? HTTPURLResponse)?.statusCode ?? 0,
        body: nil,
        error: HttpError(error.localizedDescription)
      )
    }
  }
}
