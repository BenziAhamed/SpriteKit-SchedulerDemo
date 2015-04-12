//
//  TargetAction.swift
//
//  Created by Benzi on 30/03/15.
//  Copyright (c) 2015 Benzi. All rights reserved.
//

import Foundation

protocol TargetAction {
    func performAction()
}


final class Callback<T: AnyObject> : TargetAction {
    
    weak var target: T?
    let action: (T) -> () -> ()
    
    init(_ target:T, _ action:(T) -> () -> ()) {
        self.target = target
        self.action = action
    }
    
    func performAction() -> () {
        if let t = target {
            action(t)()
        }
    }
}

infix operator => {}
func => <T:AnyObject>(t:T, action:(T)->()->()) -> TargetAction {
    return Callback(t, action)
}