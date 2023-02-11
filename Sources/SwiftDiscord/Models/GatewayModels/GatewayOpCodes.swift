//
// GatewayOpCodes.swift
//
// Created by Raul Max on 08/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

public enum GatewayOpCodes: Int, Codable {
  case dispatch
  case heartbeat
  case hello = 10
  case acknowledgement
  case unknown
}

extension GatewayOpCodes {
  public init(from decoder: Decoder) throws {
    self = try GatewayOpCodes(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
