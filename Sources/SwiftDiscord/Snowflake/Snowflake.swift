//
// Snowflake.swift
//
// Created by Raul Max on 09/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

/// Reference: https://discord.com/developers/docs/reference#snowflakes
public struct Snowflake {
  /// Discord Epoch which translates to the first second of 2015 (2015-01-01 00:00:00 +0000)
  public static var discordEpoch: Date {
    return Date(timeIntervalSince1970: 1_420_070_400)
  }

  /// Milliseconds since Discord Epoch
  public var timestamp: Date {
    return Date(timeInterval: Double((rawValue >> 22) / 1000), since: Self.discordEpoch)
  }

  /// For every ID that is generated on that process, this number is incremented
  public var increment: UInt16 {
    return UInt16(rawValue & 0xFFF)
  }

  public var processId: UInt8 {
    return UInt8((rawValue & 0x1F000) >> 12)
  }

  public var workerId: UInt8 {
    return UInt8((rawValue & 0x3E0000) >> 17)
  }

  /// The internal ID storage for a snowflake
  public let rawValue: UInt64

  public init(rawValue: UInt64) {
    self.rawValue = rawValue
  }

  /// Produces a fake snowflake with the given time and process id
  public init() {
    var value: UInt64 = 0
    var now: Date

    if #available(macOS 12, *) {
      now = Date.now
    } else {
      now = Date()
    }

    let difference = UInt64(now.timeIntervalSince(Self.discordEpoch) * 1000)
    value |= difference << 12

    // Setup worker id (5 bits)
    value |= 16 << 17

    // Setup process id (5 bits)
    value |= 1 << 12

    // Setup incremented id (11 bits)
    value += 128

    self.rawValue = value
  }
}

extension Snowflake: Codable {
  /// Decode from JSON
  public init(from decoder: Decoder) throws {
    let result = try decoder.singleValueContainer().decode(String.self)

    self.rawValue = UInt64(result) ?? UInt64()
  }

  public func encode(to encoder: Encoder) throws {
    try description.encode(to: encoder)
  }
}

extension Snowflake: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: UInt64) {
    self.rawValue = value
  }

  public typealias IntegerLiteralType = UInt64
}

extension Snowflake: CustomStringConvertible {
  public var description: String {
    return rawValue.description
  }
}

extension Snowflake: RawRepresentable, Equatable {
  public typealias RawValue = UInt64
}

extension Snowflake: Comparable, Hashable {
  public var hashValue: Int {
    return rawValue.hashValue
  }

  public static func < (lhs: Snowflake, rhs: Snowflake) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
}
