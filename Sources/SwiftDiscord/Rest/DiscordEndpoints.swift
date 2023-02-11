//
// DiscprdEndpoints.swift
//
// Created by Raul Max on 09/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

public enum DiscordEndpoints {
  case gateway
  case me
  case myGuilds
  case getGuild(id: Snowflake)
  case getUser(id: String)
}

extension DiscordEndpoints {
  public var value: String {
    switch self {
    case .gateway:
      return "/gateway/bot"
    case .me:
      return "/users/@me"
    case .getUser(let id):
      return "/users/\(id)"
    case .myGuilds:
      return "/users/@me/guilds"
    case .getGuild(let id):
      return "/guilds/\(id)"
    }
  }
}
