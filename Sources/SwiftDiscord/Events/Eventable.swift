//
// Eventable.swift
//
// Created by Raul Max on 06/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation
import NIO

protocol Eventable: AnyObject {
  var listeners: [EventListener] { get set }

  func on(event: DiscordEvents, completion: @escaping (Data) -> Void) -> Int
  func emit(event: DiscordEvents, with data: Data)
}
