//
// GatewayHandler.swift
//
// Created by Raul Max on 09/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation
import WebSocketKit

protocol GatewayHandler: AnyObject {
  func connect()
  func disconnect()
  func reconnect()
}
