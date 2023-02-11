//
// TimerHolder.swift
//
// Created by Raul Max on 10/02/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

class TimerHolder: NSObject {
  var timer: Timer?

  @objc func timerFired(_: Timer) {
    print("fired")
  }

  init(at interval: TimeInterval) {
    super.init()
    self.timer = Timer.scheduledTimer(
      timeInterval: interval,
      target: self,
      selector: #selector(timerFired),
      userInfo: nil,
      repeats: false
    )
  }
}
