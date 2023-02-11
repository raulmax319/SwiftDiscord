//
// RestConfig.swift
//
// Created by Raul Max on 08/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

struct RestConfig {
  var baseURL: String
  var headers: [String: String]
  var timeout: Int
  var sessionConfiguration: URLSessionConfiguration

  init(
    baseURL: String,
    headers: [String: String],
    timeout: Int = 30,
    sessionConfiguration: URLSessionConfiguration = .default
  ) {
    self.baseURL = baseURL
    self.headers = headers
    self.timeout = timeout
    self.sessionConfiguration = sessionConfiguration
  }
}
