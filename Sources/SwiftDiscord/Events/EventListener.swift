//
// EventListener.swift
//
// Created by Raul Max on 10/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

struct EventListener {
  var eventName: DiscordEvents
  var completion: [(Data) -> Void]
}
