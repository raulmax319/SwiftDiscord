//
// Logger.swift
//
// Created by Raul Max on 07/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

public struct Logger {
  static public func log(_ type: LogType, _ obj: Any...) {
    #if DEBUG
      print("[SwiftDiscord] \(type.rawValue)\(obj)")
    #endif
  }
}

extension Logger {
  public enum LogType: String {
    case warn = "⚠️ Warning: "
    case error = "🛑 Error: "
    case info = "ℹ️ Info: "
  }
}
