//
// GatewayPayloadHandlerDelegate.swift
//
// Created by Raul Max on 10/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation
import NIO
import NIOWebSocket

protocol GatewayPayloadHandlerDelegate: AnyObject {
  func handleBinary(_ bytes: ByteBuffer)
  func handleText(_ string: String)
  func handleClose(_ code: WebSocketErrorCode)
}
