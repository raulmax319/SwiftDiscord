//
// Gateway.swift
//
// Created by Raul Max on 08/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation
import NIO
import WebSocketKit

class Gateway: EventEmitter {
  private var eventLoopGroup: EventLoopGroup {
    return MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
  }

  private let encoder = JSONEncoder()

  public var session: WebSocket?
  public unowned var delegate: GatewayPayloadHandlerDelegate

  public init(with delegate: GatewayPayloadHandlerDelegate) {
    self.delegate = delegate
  }

  func connect(to host: String, with headers: HTTPHeaders) throws {
    guard let url = URL(string: host) else {
      throw URLError(.badURL)
    }

    let event = WebSocket.connect(
      to: url.absoluteString,
      on: eventLoopGroup) { [unowned self] ws in
        session = ws

        ws.onBinary { _, bytes in
          self.delegate.handleBinary(bytes)
        }

        ws.onText { _, text in
          self.delegate.handleText(text)
        }
      }

    try event.wait()
  }

  deinit {
    disconnect()
  }

  func disconnect() {
    session?.close(promise: nil)
    session = nil
  }

  func reconnect() {
    guard let session, !session.isClosed else {
      disconnect()
      return
    }
  }

  func send<T: Codable>(_ payload: GatewayPayload<T>) throws {
    let data = try encoder.encode(payload)

    let rawData = [UInt8](data)

    Logger.log(.info, "Trying to send data to the gateway, payload: \(payload)")
    session?.send(raw: rawData, opcode: .text)
  }
}
