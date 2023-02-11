//
// GatewayHello.swift
//
// Created by Raul Max on 10/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

struct GatewayHello: Codable {
  var heartbeatInterval: Int
}

extension GatewayHello {
  private enum CodingKeys: String, CodingKey {
    case heartbeatInterval = "heartbeat_interval"
  }
}
