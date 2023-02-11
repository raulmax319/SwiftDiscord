//
// HttpResponse.swift
//
// Created by Raul Max on 09/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

struct HttpResponse<T: Codable>: Codable {
  let statusCode: Int
  let body: T?
  let error: HttpError?
}
