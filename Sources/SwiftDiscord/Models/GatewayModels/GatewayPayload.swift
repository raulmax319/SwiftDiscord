//
// GatewayPayload.swift
//
// Created by Raul Max on 08/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

public struct UnknownGatewayPayload: Codable {
  var opCode: GatewayOpCodes
  var sequence: Int?
  var eventName: DiscordEvents?
}

extension UnknownGatewayPayload {
  enum CodingKeys: String, CodingKey {
    case opCode = "op"
    case sequence = "s"
    case eventName = "t"
  }
}

public struct GatewayPayload<T: Codable>: Codable {
  public var opCode: GatewayOpCodes
  public var data: T?
  public var sequence: Int?
  public var eventName: DiscordEvents?
}

extension GatewayPayload {
  enum CodingKeys: String, CodingKey {
    case opCode = "op"
    case data = "d"
    case sequence = "s"
    case eventName = "t"
  }
}
