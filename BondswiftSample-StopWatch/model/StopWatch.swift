//
//  StopWatch.swift
//  BondswiftSample-StopWatch
//
//  Created by 田　甜 on 2017/01/19.
//  Copyright © 2017年 田　甜. All rights reserved.
//

import Foundation

import Bond
import ReactiveKit

class StopWatch {
    
    enum State {
        case startable
        case stoppable
        case resumable
    }
    
    var time = Observable<TimeInterval>(TimeInterval(0))
    var state = Observable<State>(.startable)
    
    let disposeBag = DisposeBag()
    
    private var timer: Timer?
    private var startTime: Date?
    private var initialTime: TimeInterval = 0
    
    func start() {
        startTimer(withInitialTime: 0)
        state.next(.stoppable)
    }
    
    func resume() {
        startTimer(withInitialTime: initialTime)
        state.next(.stoppable)
    }
    
    func stop() {
        timer?.invalidate()
        initialTime += Date().timeIntervalSince(self.startTime!)
        state.next(.resumable)
    }
    
    func clear() {
        initialTime = 0
        state.next(.startable)
    }
    
    private func startTimer(withInitialTime initialTime: Double) {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (timer: Timer) -> Void in
            let time = Date().timeIntervalSince(self.startTime!) + initialTime
            self.time.next(time)
        }
    }
}
