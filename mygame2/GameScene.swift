//
//  GameScene.swift
//  mygame2
//
//  Created by 杨培文 on 14/12/23.
//  Copyright (c) 2014年 杨培文. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene,SKPhysicsContactDelegate {
    var labelx:SKLabelNode = SKLabelNode(text: "")
    var labely:SKLabelNode = SKLabelNode(text: "")
    var tishi = SKSpriteNode(imageNamed: "denglu")
    var ran = 0
    var imgs = ["denglu","duankai","chaliuliang","psw","zidongdenglu"]
    var spd = 0.02
    override func didMoveToView(view: SKView) {
        //        self.physicsWorld.gravity = CGVectorMake(0, -9.8)
        self.backgroundColor=SKColor.blackColor()
        self.scaleMode = SKSceneScaleMode.AspectFill
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.friction = 0.5
        self.physicsWorld.contactDelegate = self
        if motionManager.accelerometerAvailable {
            motionManager.accelerometerUpdateInterval = spd
            motionManager.startAccelerometerUpdates()
            NSTimer.scheduledTimerWithTimeInterval(spd, target: self, selector: "refresh", userInfo: nil, repeats: true)
            labelx.position = CGPoint(x: 200, y: 700)
            labely.position = CGPoint(x: 200, y: 650)
            rand()
            
            addChild(labelx)
            addChild(labely)
        }
    }
    
    func rand(){
        ran = Int(arc4random()%(imgs.count+4))
        if ran >= imgs.count{
            var sprite = SKSpriteNode(imageNamed: imgs[0])
            sprite.xScale = 0.3
            sprite.yScale = 0.3
            
            var circle = SKShapeNode(circleOfRadius: 50)
            circle.position = CGPoint(x: sprite.size.width, y: -sprite.size.height)
            sprite.addChild(circle)
            
            var circle2 = SKShapeNode(circleOfRadius: 50)
            circle2.position = CGPoint(x: -sprite.size.width, y: -sprite.size.height)
            
            sprite.addChild(circle2)
            sprite.position = CGPoint(x: 100, y: 100)
            
            sprite.physicsBody=SKPhysicsBody(rectangleOfSize: sprite.size)
            sprite.physicsBody?.pinned = true
            tishi.removeFromParent()
            tishi=sprite
            self.addChild(tishi)
            
        }else {
            var sprite = SKSpriteNode(imageNamed: imgs[Int(ran)])
            sprite.xScale = 0.3
            sprite.yScale = 0.3
            sprite.position = CGPoint(x: 100, y: 100)
            sprite.physicsBody=SKPhysicsBody(rectangleOfSize: sprite.size)
            sprite.physicsBody?.pinned = true
            
            tishi.removeFromParent()
            tishi=sprite
            self.addChild(tishi)
        }
        
    }
    let motionManager = CMMotionManager()
    let pi = 3.1415926
    var gravity = 9.8*3
    func refresh(){
        if let a = motionManager.accelerometerData
        {
            let x = a.acceleration.x
            let y = a.acceleration.y
            let z = a.acceleration.z
            
            if Double.abs(x) < 0.1 && Double.abs(y) < 0.1{
                gravity = 0
            }else if Double.abs(x) > 1.5 || Double.abs(y) > 1.5{
                gravity = 9.8*9
            }else {
                gravity = 9.8*3
            }
            
            let gx = -y*gravity
            let gy = x*gravity
            self.physicsWorld.gravity.dx=CGFloat(gx)
            self.physicsWorld.gravity.dy=CGFloat(gy)
            labelx.text = "x=\(gx)"
            labely.text = "y=\(gy)"
        }
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if touches.count == 4{
            self.removeAllChildren()
            self.backgroundColor=SKColor.blackColor()
            self.scaleMode = SKSceneScaleMode.AspectFill
            self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
            self.physicsBody?.friction = 0.5
            addChild(labelx)
            addChild(labely)
            rand()
        }else {
            for touch: AnyObject in touches {
                if ran >= imgs.count{
                    var sprite = SKSpriteNode(imageNamed: imgs[0])
                    sprite.xScale = 0.3
                    sprite.yScale = 0.3
                    sprite.name = "车"
                    
                    let location = touch.locationInNode(self)
                    sprite.position = location
                    
                    sprite.physicsBody=SKPhysicsBody(rectangleOfSize: sprite.size)
                    sprite.physicsBody?.contactTestBitMask = 0xFFFF
                    sprite.physicsBody?.friction=0.6
                    
                    var circle = SKShapeNode(circleOfRadius: 50)
                    circle.position = CGPoint(x: sprite.size.width, y: -sprite.size.height)
//                    circle.name = "轮"
                    circle.physicsBody = SKPhysicsBody(circleOfRadius: 50)
                    circle.physicsBody?.pinned = true
                    circle.physicsBody?.mass = 1
                    sprite.addChild(circle)
                    
                    var circle2 = SKShapeNode(circleOfRadius: 50)
                    
                    circle2.position = CGPoint(x: -sprite.size.width, y: -sprite.size.height)
//                    circle2.name = "轮"
                    circle2.physicsBody = SKPhysicsBody(circleOfRadius: 50)
                    circle2.physicsBody?.pinned = true
                    circle2.physicsBody?.mass = 1
                    
                    sprite.addChild(circle2)
                    
                    self.addChild(sprite)
                    
                }else {
                    var sprite = SKSpriteNode(imageNamed: imgs[Int(ran)])
                    sprite.xScale = 0.3
                    sprite.yScale = 0.3
                    sprite.name=imgs[Int(ran)]
                    let location = touch.locationInNode(self)
                    sprite.position = location
                    
                    sprite.physicsBody=SKPhysicsBody(rectangleOfSize: sprite.size)
                    sprite.physicsBody?.friction=0.4
                    sprite.physicsBody?.restitution=0.3
                    
                    if ran == 3 {
                        sprite.physicsBody?.mass=10
                    }
                    
                    self.addChild(sprite)
                }
                
                rand()
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if var nodea = contact.bodyA.node{
            if var nodeb = contact.bodyB.node{
                if var namea = nodea.name {
                    if var nameb = nodeb.name{
                        if namea != nameb{
                            if nameb == "车"{
                                var tmp = nodea
                                nodea=nodeb
                                nodeb=tmp
                            }
                            xiancheng({
                                nodeb.position = CGPoint(x: nodea.position.x, y: nodea.position.y+nodea.frame.height/2+nodeb.frame.height/2)
                                nodea.runAction(SKAction.rotateToAngle(0, duration: 0))
                                nodeb.runAction(SKAction.rotateToAngle(0, duration: 0))
                                nodea.speed=0
                                nodeb.speed=0
                                self.physicsWorld.addJoint(SKPhysicsJointPin.jointWithBodyA(nodea.physicsBody, bodyB: nodeb.physicsBody, anchor: CGPoint(x: nodea.position.x-nodeb.frame.width/2, y: nodea.position.y+nodeb.frame.height/2)))
                                self.physicsWorld.addJoint(SKPhysicsJointPin.jointWithBodyA(nodea.physicsBody, bodyB: nodeb.physicsBody, anchor: CGPoint(x: nodea.position.x+nodeb.frame.width/2, y: nodea.position.y+nodeb.frame.height/2)))
                                
                                nodea.name=nil
                                nodeb.name=nil
                                println("\(namea),\(nameb)")
                            })
                        }
                    }
                }
            }
        }
    }
    
    func xiancheng(code:dispatch_block_t){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), code)
    }
    func ui(code:dispatch_block_t){
        dispatch_async(dispatch_get_main_queue(), code)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
