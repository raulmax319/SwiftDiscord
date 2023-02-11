//
// EventEmitter.swift
//
// Created by Raul Max on 06/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation
import NIO

class EventEmitter: Eventable {
  var listeners: [EventListener] = [EventListener]()

  @discardableResult
  func on(event: DiscordEvents, completion: @escaping (Data) -> Void) -> Int {
    guard !listeners.isEmpty else {
      let newListener = EventListener(eventName: event, completion: [completion])
      listeners.append(newListener)
      return 0
    }

    var eventHolder = findFirstListener(for: event)

    eventHolder?.completion.append(completion)

    return (eventHolder?.completion.count ?? 1) - 1
  }

  func emit(event: DiscordEvents, with data: Data) {
    guard let listeners = findFirstListener(for: event) else {
      return
    }

    listeners.completion.forEach {
      $0(data)
    }
  }

  private func findFirstListener(for event: DiscordEvents) -> EventListener? {
    return listeners.first {
      $0.eventName == event
    }
  }
}
