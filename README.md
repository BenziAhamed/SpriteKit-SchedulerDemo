# SpriteKit-SchedulerDemo
A demonstration of a time based Scheduler for Sprite Kit in Swift

Read more about this [at my blog](http://www.folded-paper.com/home/2015/4/12/lets-build-a-timer-and-scheduler-for-sprite-kit-using-swift).

A scheduler for Sprite Kit that allows you to write code with a fluent API.

### Schedule a recurring event
```swift
    scheduler
      .every(1.0) // every one second
      .perform( self=>GameScene.updateElapsedTimeLabel ) // update the elapsed time label
      .end()
```

### Schedule an event for a specific time
```swift
    scheduler
      .at(10.0) // ten seconds after game starts
      .perform( self=>GameScene.createRandomSprite ) // randomly place a sprite on the scene
      .end()
```


### Schedule an event for later, and repeat 5 times
```swift
    scheduler
      .after(10.0) // ten seconds from now
      .perform( self=>GameScene.createRandomSprite ) // randomly place a sprite on the scene
      .repeat(5) // repeat 5 times
      .end()
```

The demo project displays a label that updates every second with how much time has passed in the game scene, and creates two sprites placed randomly on the screen every second.

**PS** Project was created in XCode 6.3 with Swift 1.2
