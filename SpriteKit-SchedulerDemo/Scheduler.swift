//
//  Scheduler.swift
//  A scheduler for Sprite Kit
//
//
//  Created by Benzi on 01/04/15.
//  Copyright (c) 2015 Benzi. All rights reserved.
//


import Foundation
import SpriteKit

/// represents a class that can schedule scheduler events
/// based on their trigger times
final class Scheduler {
    
    var name:String = ""
    
    // game time elapsed counter
    var elapsed:Double = 0.0
    
    // overall duration of the sim
    // if zero, it means infinite duration
    var duration:Double = 0.0
    
    // is the sim running?
    var running = false
    
    // the queue of events to process
    var events = SchedulerEventQueue()
    
    /// start the scheduler
    func start() {
        endDefinition()
        running = true
    }
    
    func pause() {
        running = false
    }
    
    func resume() {
        running = true
    }
    
    var currentEvent:SchedulerEvent? = nil
    
    /// update the sim time
    func update(dt:Double)
    {
        if !running { return }
        
        elapsed += dt
        
        // are we within the sim time
        if duration==0 || elapsed <= duration {
            
            // do we have any events?
            var event = events.top()
            
            while (event != nil && event!.trigger <= elapsed) {
                
                // pop and fire
                events.pop()
                event!.fire()
                
                // is the event repeating?
                // then add it back
                if event!.recurring || event!.numberOfTimes > 1 {
                    event!.numberOfTimes--
                    events.add( event!.updateNextTrigger() )
                }
                
                
                
                // query next event
                event = events.top()
            }
        } else {
            // we reached end of sim
            stop()
        }
    }
    
    /// add a scheduler event
    func add(event:SchedulerEvent){
        events.add(event)
    }
    
    
    func stop() {
        if !running { return }
        running = false
        while events.count > 0 {
            if let event = events.pop() {
                if event.forceTriggerOnSchedulerStop {
                    event.fire()
                }
            }
        }
    }
    

    // FLUENT API
    
    
    func named(name:String) -> Scheduler {
        currentEvent?.name = "\(self.name) - \(name)"
        return self
    }
    
    func ensure() -> Scheduler {
        currentEvent?.ensure()
        return self
    }
    
    func delay(by:Double) -> Scheduler {
        currentEvent?.delay(by)
        return self
    }
    
    func repeat(times:Int) -> Scheduler {
        currentEvent?.repeat(times)
        return self
    }
    
    
    /// required for fluent style API
    func beginDefinition() {
        currentEvent = SchedulerEvent()
    }
    
    /// required for fluent style API
    func end() {
        endDefinition()
    }
    
    func endDefinition() {
        if currentEvent != nil {
            self.add(currentEvent!)
            currentEvent = nil
        }
    }
    
    func perform(action:TargetAction) -> Scheduler {
        currentEvent?.perform(action)
        return self
    }
    
    func withChance(chance:Double) -> Scheduler {
        currentEvent?.setChance(chance)
        return self
    }
    
    
    func now() -> Scheduler {
        return at(self.elapsed)
    }
    
    func after(time:Double) -> Scheduler {
        return at(self.elapsed + time)
    }
    
    /// creates an event will fire at a specified time
    func at(time:Double) -> Scheduler {
        endDefinition()
        beginDefinition()
        
        currentEvent!.initialTrigger = time
        currentEvent!.trigger = time
        currentEvent!.range = 0.0
        currentEvent!.recurring = false
        return self
    }
    
    /// creates an event will fire at a random range after time
    func at(time:Double, range:Double) -> Scheduler {
        endDefinition()
        beginDefinition()
        
        currentEvent!.initialTrigger = time
        currentEvent!.trigger = time + Double(unitRandom()) * range
        currentEvent!.range = range
        currentEvent!.recurring = false
        return self
        
    }
    
    
    /// creates a recurring event spaced time-secs apart
    func every(time:Double) -> Scheduler {
        endDefinition()
        beginDefinition()
        
        currentEvent!.initialTrigger = time
        currentEvent!.trigger = time
        currentEvent!.range = 0.0
        currentEvent!.recurring = true
        return self
        
    }
    
    /// creates a recurring event spaced time-secs and an additional random range apart
    func every(time:Double, range:Double) -> Scheduler {
        endDefinition()
        beginDefinition()
        
        currentEvent!.initialTrigger = time
        currentEvent!.trigger = time + Double(unitRandom()) * range
        currentEvent!.range = range
        currentEvent!.recurring = true
        return self
    }
    
    
}


final class SchedulerEvent {
    
    var trigger:Double = 0.0
    var initialTrigger:Double = 0.0
    var range:Double = 0.0
    var callback:TargetAction? = nil
    var recurring = false
    var probability:Double = 1.0
    var name:String=""
    
    // special handling
    var forceTriggerOnSchedulerStop = false
    var numberOfTimes = 0
    
    var description:String {
        return "\(trigger) - \(name) - task recurring?:\(recurring)"
    }
    
    /// updates self to be repeated again
    func updateNextTrigger() -> SchedulerEvent {
        trigger += initialTrigger + Double(unitRandom())*range
        return self
    }
    
    /// runs the callback
    func fire() {
        if callback != nil && Double(unitRandom()) <= self.probability {
            callback!.performAction()
        }
    }
}

extension SchedulerEvent {
    
    // makes the event run when the scheduler stops
    func ensure() -> SchedulerEvent {
        self.forceTriggerOnSchedulerStop = true
        return self
    }
    
    // delay the event by an amount ogf time
    func delay(by:Double) -> SchedulerEvent {
        self.trigger = self.trigger + by
        return self
    }
    
    // repeat the event x number of times
    func repeat(times:Int) -> SchedulerEvent {
        self.numberOfTimes = times
        self.recurring = false
        return self
    }
    
    //
    func perform(action:TargetAction) -> SchedulerEvent {
        self.callback = action
        return self
    }
    
    func setChance(chance:Double) -> SchedulerEvent {
        self.probability = chance
        return self
    }
    
}


// A scheduler event queue is a priority
// queue that inserts events based on the 
// trigger time
final class SchedulerEventQueue {
    
    private var q = [SchedulerEvent]()
    
    var count:Int {
        return q.count
    }
    
    func add(event:SchedulerEvent){
        // empty queue
        if q.count == 0 {
            q.append(event)
        }
        else {
            // find index to insert
            var insertIndex = 0
            while insertIndex < q.count && q[insertIndex].trigger <= event.trigger {
                insertIndex++
            }
            
            if insertIndex < q.count {
                q.insert(event, atIndex: insertIndex)
            } else {
                q.append(event)
            }
        }
    }
    
    func pop() -> SchedulerEvent? {
        if q.count == 0 { return nil }
        return q.removeAtIndex(0)
    }
    
    func top() -> SchedulerEvent? {
        if q.count == 0 { return nil }
        return q[0]
    }
}
