//
//  GameScene.swift
//  SpriteKit-SchedulerDemo
//
//  Created by Benzi on 12/04/15.
//  Copyright (c) 2015 Benzi. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override init() {
        
        // force a landscape fill
        
        let width = UIScreen.mainScreen().bounds.width
        let height = UIScreen.mainScreen().bounds.height
        
        let h = min(width, height)
        let w = max(width, height)
        
        super.init(size: CGSizeMake(w, h))
        GameScene.current = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static var current:GameScene! = nil

    

    let timer = Timer() // the timer calculates the time step value dt for every frame
    let scheduler = Scheduler() // an event scheduler
    
    var elapsedTimeLabel: SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor.blackColor()
        createElapsedTimeLabel()
        
        // set scheduled events
        
        scheduler
            .every(1.0) // every one second
            .perform( self=>GameScene.updateElapsedTimeLabel ) // update the elapsed time label
            .end()
        
        scheduler
            .every(0.5) // every half second
            .perform( self=>GameScene.createRandomSprite ) // randomly place a sprite on the scene
            .end()
        
        scheduler.start()
    }
    
    func createElapsedTimeLabel() {
        
        elapsedTimeLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        elapsedTimeLabel.text = "Elapsed time: 0 secs";
        elapsedTimeLabel.position = frame.mid()
        
        self.addChild(elapsedTimeLabel)
    }
    
    func updateElapsedTimeLabel() {
        elapsedTimeLabel.text = "Elapsed time: \(Int(scheduler.elapsed)) secs"
    }
    
    func createRandomSprite() {
        let sprite = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(5.0, 5.0))
        sprite.position = frame.randomPoint()
        self.addChild(sprite)
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        
        /* Called before each frame is rendered */
        
        
        // note that we will not use Sprite Kit's currentTimer parameter
        
        timer.advance()
        scheduler.update(timer.dt)
        
        println("spritekit time:\(currentTime) dt:\(timer.dt) elapsed game time:\(scheduler.elapsed)")
    }
    
}


extension GameScene {
    func pause() {
        self.paused = true
        timer.advance(paused: true)
    }
    
    func unpause() {
        self.paused = false
        timer.advance(paused: false)
    }
}


extension CGRect {
    func mid() -> CGPoint {
        return CGPointMake(midX, midY)
    }
    
    func randomPoint() -> CGPoint {
        return CGPointMake(unitRandom()*maxX, unitRandom()*maxY)
    }
}