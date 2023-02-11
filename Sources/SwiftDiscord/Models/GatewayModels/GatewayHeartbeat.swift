//
// GatewayHeartbeat.swift
//
// Created by Raul Max on 10/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

public struct GatewayHeartbeat: Codable {
  let heartbeatInterval: TimeInterval
}

extension GatewayHeartbeat {
  enum CodingKeys: String, CodingKey {
    case heartbeatInterval = "heartbeat_interval"
  }
}
