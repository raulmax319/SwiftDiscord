//
// SessionStartLimit.swift
//
// Created by Raul Max on 10/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

struct SessionStartLimit: Codable {
  let total: Int
  let remaining: Int
  let resetAfter: TimeInterval
  let maxConcurrency: Int
}

extension SessionStartLimit {
  private enum CodingKeys: String, CodingKey {
    case total, remaining
    case resetAfter = "reset_after"
    case maxConcurrency = "max_concurrency"
  }
}
