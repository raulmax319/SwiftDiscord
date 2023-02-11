//
// Shard.swift
//
// Created by Raul Max on 09/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation
import NIO
import NIOWebSocket
import WebSocketKit

final class Shard: NSObject {
  private var gateway: Gateway?
  private let rest: Rest

  /// Shard ID
  private var id: UInt8 = 0

  /// Heartbeat queue
  private var heartbeatQueue: DispatchQueue

  /// Last sequence number for this shard
  private var lastSequence: Int?

  private var acksMissed: Int = 0
  private var isReconnecting = false

  /// Actual session id to resume connection
  private var sessionId: String?

  init(with restManager: Rest) {
    self.rest = restManager
    self.heartbeatQueue = DispatchQueue(label: "swiftdiscord.shard.noId.heartbeat")
    super.init()

    self.gateway = Gateway(with: self)
  }

  convenience init(id: UInt8, restConfig: RestConfig) {
    self.init(with: RestManager(config: restConfig))

    self.id = id
    self.heartbeatQueue = DispatchQueue(label: "swiftdiscord.shard.\(id).heartbeat")
  }
}

extension Shard: GatewayHandler {
  func connect() {
    rest.get(for: GatewayInfo.self, to: .gateway) { [unowned self] result in
      DispatchQueue.global().async { [unowned self] in
        do {
          guard let body = result.body else {
            return
          }

          var headers = [(String, String)]()
          rest.config.headers.forEach { (key, value) in
            headers.append((key, value))
          }

          try gateway?.connect(
            to: "\(body.url)/?v=\(Constants.apiVersion)&encoding=\(Constants.encodingType)",
            with: HTTPHeaders(headers)
          )
        } catch {
          Logger.log(.error, "Could not connect to gateway. Reason: \(error)")
        }
      }
    }
  }

  func disconnect() {
    //
  }

  func reconnect() {
    //
  }
}

// MARK: - Payload Handler
extension Shard: GatewayPayloadHandlerDelegate {
  func send<T: Codable>(_ payload: GatewayPayload<T>) {
    do {
      try gateway?.send(payload)
    } catch {
      Logger.log(.warn, "Unable to send payload on shard \(id). Cause: \(error.localizedDescription)")
    }
  }

  func sendHeartbeat(at interval: Int) {
    let payload = GatewayPayload(
      opCode: .heartbeat,
      data: lastSequence,
      sequence: nil,
      eventName: nil
    )

    acksMissed += 1
    send(payload)

    heartbeatQueue.asyncAfter(
      deadline: .now() + .milliseconds(interval)
    ) { [unowned self] in
      Logger.log(.info, "Sent hearbeat at \(Date())")
      sendHeartbeat(at: interval)
    }
  }

  func handleBinary(_ bytes: ByteBuffer) {
    do {
      let result = try JSONDecoder().decode(UnknownGatewayPayload.self, from: bytes)
      handlePayload(result, bytes)
    } catch {
      Logger.log(.error, error.localizedDescription)
    }
  }

  func handleText(_ string: String) {
    guard let data = string.byteBuffer(using: .utf8) else {
      Logger.log(.error, "Failed to parse Payload, data: \(string)")
      return
    }

    guard let payload = decode(UnknownGatewayPayload.self, from: data) else {
      Logger.log(.error, "Couldn't decode payload, data: \(string)")
      return
    }

    handlePayload(payload, data)
  }

  func handleClose(_ code: WebSocketErrorCode) {
    Logger.log(.warn, "WebSocket Error code: \(code)")
  }

  private func decode<T: Decodable>(_ type: T.Type, from data: ByteBuffer) -> T? {
    return try? JSONDecoder().decode(type.self, from: data)
  }

  private func handlePayload(_ payload: UnknownGatewayPayload, _ data: ByteBuffer) {
    switch payload.opCode {
    case .dispatch:
      lastSequence = payload.sequence
      Logger.log(.info, "Dispatch event")
    case .heartbeat:
      acksMissed -= 1
      Logger.log(.info, "Heartbeat event")
    case .hello:
      guard let hello = decode(GatewayPayload<GatewayHello>.self, from: data)?.data else {
        Logger.log(.error, "Couldn't decode Hello Payload: \(payload)")
        disconnect()
        return
      }

      Logger.log(.info, "Hello event")
      sendHeartbeat(at: hello.heartbeatInterval)
    case .acknowledgement:
      acksMissed -= 1
    default:
      Logger.log(.warn, "Unhandled or unknown event: \(payload.opCode)")
    }
  }
}
