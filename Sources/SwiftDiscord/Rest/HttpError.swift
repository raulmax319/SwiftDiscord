//
// HttpError.swift
//
// Created by Raul Max on 08/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

struct HttpError: Error, Codable {
  let code: Int
  let statusCode: Int
  let error: [String: String]
  let message: String

  init(
    code: Int,
    statusCode: Int,
    error: [String: String],
    message: String
  ) {
    self.code = code
    self.statusCode = statusCode
    self.error = error
    self.message = message
  }

  init(_ message: String) {
    self.message = message
    self.code = 0
    self.statusCode = 0
    self.error = [:]
  }
}
