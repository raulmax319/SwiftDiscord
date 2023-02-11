//
// GatewayInfo.swift
//
// Created by Raul Max on 09/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

struct GatewayInfo: Codable {
  let url: String
  let shards: Int
  let sessionStartLimit: SessionStartLimit
}

extension GatewayInfo {
  private enum CodingKeys: String, CodingKey {
    case url, shards
    case sessionStartLimit = "session_start_limit"
  }
}
