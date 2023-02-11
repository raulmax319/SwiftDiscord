//
// Rest.swift
//
// Created by Raul Max on 08/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

protocol Rest: AnyObject {
  var config: RestConfig { get }

  func get<T: Codable>(
    for type: T.Type,
    to route: DiscordEndpoints,
    completion: @escaping (HttpResponse<T>) -> Void
  )
}
