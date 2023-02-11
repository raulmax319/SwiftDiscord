//
// SwiftDiscord.swift
//
// Created by Raul Max on 06/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation
import NIO
import WebSocketKit

struct Constants {
  static let baseURL = "https://discord.com/api"
  static let apiVersion = 10
  static let encodingType = "json"
}

final public class SwiftDiscord {
  private let token: String
  private let shard: Shard

  public init(token: String) {
    self.token = token

    let restConfig = Self.setupRestConfig(for: token)
    let restManager = RestManager(config: restConfig)
    self.shard = Shard(with: restManager)
  }
}

// MARK: - Public
extension SwiftDiscord {
  public func connect() {
    shard.connect()

    _ = TimerHolder(at: 1)
    RunLoop.main.run()
  }

  public func disconnect() {
    shard.disconnect()
    CFRunLoopStop(RunLoop.main.getCFRunLoop())
  }
}

extension SwiftDiscord {
  internal class func setupRestConfig(for token: String) -> RestConfig {
    let headers = [
      "User-Agent": "Discord Bot (https://github.com/raulmax319/SwiftDiscord, 0.0.1) Swift/5;BUBBLE_HTTP",
      "Authorization": "Bot \(token)"
    ]
    return RestConfig(baseURL: "\(Constants.baseURL)/v\(Constants.apiVersion)", headers: headers)
  }
}
