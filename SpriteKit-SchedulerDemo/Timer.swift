//
//  Timer.swift
//
//  Created by Benzi on 30/03/15.
//  Copyright (c) 2015 Benzi. All rights reserved.
//

import Foundation



/// Represents a timer that can be used with Sprite Kit
final public class Timer {
    
    private(set) public var dt:CFTimeInterval = 0

    
    private var previousTime:CFTimeInterval = CFAbsoluteTimeGetCurrent() // needs to be this
    private var shouldCorrectAfterPause = false

    /// pause the timer
    public func pause() {
        advance(CFAbsoluteTimeGetCurrent(), paused:true)
    }
    
    /// unpause the timer
    /// must be called after calling pause to resume
    /// the timer's ability to calculate elapsed time
    /// properly
    public func unpause() {
        advance(CFAbsoluteTimeGetCurrent(), paused:false)
    }
    
    /// advance the timer's elapsed time by the timestep
    /// of the game loop
    public func advance(paused:Bool = false) {
        advance(CFAbsoluteTimeGetCurrent(), paused: paused)
    }
    
    private func advance(currentTime:CFTimeInterval, paused:Bool) {
        if paused {
            shouldCorrectAfterPause = true
            dt = 0
        }
        else  {
            if shouldCorrectAfterPause {
                dt = 0
                shouldCorrectAfterPause = false
            }
            else {
                dt = currentTime - previousTime
            }
            previousTime = currentTime
        }
    }
}
