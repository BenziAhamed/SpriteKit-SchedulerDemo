# SpriteKit-SchedulerDemo
A demonstration of a time based Scheduler for Sprite Kit in Swift

Read more about this [at my blog](http://www.folded-paper.com/home/2015/4/12/lets-build-a-timer-and-scheduler-for-sprite-kit-using-swift).

A scheduler for Sprite Kit that allows you to write code like:

```swift
    scheduler
      .every(1.0) // every one second
      .perform( self=>GameScene.updateElapsedTimeLabel ) // update the elapsed time label
      .end()
        
    scheduler
      .every(0.5) // every half second
      .perform( self=>GameScene.createRandomSprite ) // randomly place a sprite on the scene
      .end()
```
