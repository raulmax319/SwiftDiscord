//
// StringExtension.swift
//
// Created by Raul Max on 11/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//
  

import Foundation
import NIO

extension String {
  func byteBuffer(using encoding: Self.Encoding) -> ByteBuffer? {
    guard let data = self.data(using: encoding) else {
      return nil
    }

    return ByteBuffer(data: data)
  }
}
