//
// DiscordEvent.swift
//
// Created by Raul Max on 10/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

public enum DiscordEvents: String, Codable {
  case createChannel = "CHANNEL_CREATE"
  case createGuild = "GUILD_CREATE"
  case createMessage = "MESSAGE_CREATE"
  case updatePresence = "PRESENCE_UPDATE"
  case ready = "READY"
  case resumed = "RESUMED"
  case typingStart = "TYPING_START"
  case unknown

  public init(from decoder: Decoder) throws {
    self = try DiscordEvents(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
