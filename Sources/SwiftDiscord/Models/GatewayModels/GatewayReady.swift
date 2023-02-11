//
// GatewayReady.swift
//
// Created by Raul Max on 10/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

struct GatewayReady: Codable {
  let sessionId: String
  let unavailableGuilds: [UnavailableGuild]
  let user: User
  let version: UInt8
}

extension GatewayReady {
  private enum CodingKeys: String, CodingKey {
    case sessionId = "session_id"
    case unavailableGuilds = "guilds"
    case user
    case version = "v"
  }
}
