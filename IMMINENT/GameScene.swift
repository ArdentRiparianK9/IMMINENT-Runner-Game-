//
//  GameScene.swift
//  Scene Test
//
//  Created by Kayla A. Yang  on 21/4/2023.
//

import SpriteKit
import UIKit
import GameplayKit
// game tested works

/// This is IMMINENT my first successful endless runner game. It has many cool visuals and music tracks, it posses very few bugs and as of 2023 I have not found any. The game has simple controls with a left and right full screen buttons. The sound tracks of the game are copy right free and are wordless.
/// The method in which you score points in this game is by running for as long as possible while avoiding the disruption fileds, delaying your jumps also scores points. These fields have been designed to move quickly and push the Player back, if you keep your eyes off the screen for just a moment its 'game over', because in the span of a less that a second you will be pushed into the 'no go zone'. Note, the fields are also hard to see and have bouncy properties.
/// Part of what makes the game difficult is not the controls themselves, but the fast pace of the game. You need to not only know when to jump but you also need to pay attention not to not just the obstacles but the platforms themselves. Combine that with the fact that your goal is not to just survive but score points through delayed jumps makes the timing all the more important.
///
/// In short, time is not on your side, learn fast or die, hence the name 'IMMINENT'.
///
///
struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Pacer: UInt32 = 0b1
    static let eDash: UInt32 = 0b1000 // eDash
    static let Rock: UInt32 = 0b10  //eField
    static let Scorer: UInt32 = 0b100
    static let Bottom: UInt32 = 0b100
}

var highscore = 0
class GameScene: SKScene, SKPhysicsContactDelegate {
    // lets the music play
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var stopButtonNode: SKSpriteNode!
    var pauseButtonNode: SKSpriteNode!
    var jumpButtonNode: SKSpriteNode!
    var dashButtonNode: SKSpriteNode!
    
    var startX = 3000
    var startY = 200
    var startY2 = 800
    var touchStartTime: Date? = nil
    var touchEndTime: Date? = nil
    var rocks: [SKSpriteNode] = []
    
    let label = SKLabelNode(fontNamed:"Futura")
    func generateLabel(){

        label.fontColor = SKColor.red
        label.text = String(highscore)
        label.fontSize = 50
        label.position = CGPoint(x:frame.midX,y:980)
        addChild(label)
    }
    func updateScore(){
        highscore = highscore + 1
        label.text = String(highscore)
    }
       
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        scene?.backgroundColor = UIColor(hue: 0.6, saturation: 1, brightness: 0.25, alpha: 1)
        /*Hex:  */
        physicsWorld.gravity.dy = -16
        
        // note location for portrait is x= 745 y= 1120
        // landscape is x= 1115 y=765
        pauseButtonNode = self.childNode(withName: "pauseButton") as? SKSpriteNode
        pauseButtonNode.anchorPoint = CGPoint(x: 0, y: 0)
        print ("pausebutton")
        // Pause button
        stopButtonNode = self.childNode(withName: "stopButton") as? SKSpriteNode
        stopButtonNode.anchorPoint = CGPoint(x: 0, y: 0)
        print ("stopbutton")
        
        jumpButtonNode = self.childNode(withName: "jumpButton") as? SKSpriteNode
        jumpButtonNode.anchorPoint = CGPoint(x: 0, y: 0)
        print ("jumpbutton")
        
        dashButtonNode = self.childNode(withName: "dashButton") as? SKSpriteNode
        dashButtonNode.anchorPoint = CGPoint(x: 0, y: 0)
        print ("dashbutton")
        
        generateLabel()
        createBoundary()
        buildPacer()
        animatePacer()
        createBoundary2()
        createWallL()
        //createPlatform()
        startRocks(image: "Pink bar", size: CGSize(width: 2000, height: 20), delay: 2)
        
        //startRocks(image: "Pink bar", size: CGSize(width: 600, height: 30), delay: 4)
        startRocks2(image: "Green glitch bar", size: CGSize(width: 1000, height: 20), delay: 4)
        startRocks3(image: "Green bar", size: CGSize(width: 600, height: 20), delay: 3)
        startField(image: "bounceRing", size: CGSize(width: 200, height: 200), delay: 4)
        //startRocks(image: "Pink Bar", size: CGSize(width: 300, height: 30), delay: 2)
        
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       

        //Movement
        
        touchStartTime = Date()
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "stopButton" {
                let transition = SKTransition.crossFade(withDuration: 0.5)
                let menuScene = SKScene(fileNamed: "MenuScene") as! MenuScene
                self.view?.presentScene(menuScene, transition: transition)
                
                
            }else if  nodesArray.first?.name == "pauseButton"{
                pausePlay()
            }else if nodesArray.first?.name == "jumpButton"{
                pacer.physicsBody?.velocity.dy = 1000
            }else if nodesArray.first?.name == "dashButton"{
                buildDash()
                animateDash()
                highscore = highscore + 1000
            }
            
        }
        func pausePlay(){
            if self.view?.isPaused == true{
                self.view?.isPaused = false
            }else{
                self.view?.isPaused = true
                stopButtonNode.isPaused = false
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        energyDash.removeFromParent()
        touchEndTime = Date()
        // Double jump
        if let start = touchStartTime, let end = touchEndTime {
            let duration = end.timeIntervalSince(start)
            pacer.physicsBody?.velocity.dy = 750 + duration
            print("Touch duration: \(duration) seconds")
            highscore = highscore + Int(round(duration)) * 500
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    private var pacer = SKSpriteNode()
    private var pacerRunFrames: [SKTexture] = []
    
    private var energyDash = SKSpriteNode()
    private var energyDashFrames: [SKTexture] = []
    
    func buildDash(){
        let dashAnimatedAtlas = SKTextureAtlas(named: "eDash")
        var dashFrames: [SKTexture] = []
        
        let numImages = dashAnimatedAtlas.textureNames.count
        for i in 1...numImages{
            let dashTextureName = "eDash\(i)"
            dashFrames.append(dashAnimatedAtlas.textureNamed(dashTextureName))
        }
        energyDashFrames = dashFrames
        let firstFrameTexture = energyDashFrames[0]
        energyDash.name = "eDash"
        
        energyDash = SKSpriteNode(texture: firstFrameTexture)
        energyDash.position = CGPoint(x: pacer.position.x, y: pacer.position.y)
        energyDash.size = CGSize(width: 220, height: 200)
        
        energyDash.physicsBody = SKPhysicsBody(rectangleOf:energyDash.frame.size)
        energyDash.physicsBody!.categoryBitMask = PhysicsCategory.eDash
        
        // Note: Both Contact and Collision is needed
        //        pacer.physicsBody!.contactTestBitMask = PhysicsCategory.Bottom
        //        pacer.physicsBody?.collisionBitMask = PhysicsCategory.Bottom
        energyDash.physicsBody!.usesPreciseCollisionDetection = true
        
        energyDash.physicsBody?.contactTestBitMask = 0b10
        energyDash.physicsBody?.collisionBitMask = 0b10
        
        energyDash.physicsBody?.isDynamic = false
        energyDash.physicsBody?.allowsRotation = false
        energyDash.physicsBody?.affectedByGravity = false
        energyDash.physicsBody?.friction = 0
        
        addChild(energyDash)
    }
   
    func animateDash(){
        energyDash.run(SKAction.repeatForever(
            SKAction.animate(with: energyDashFrames,
                             timePerFrame: 0.01,
                            resize: false,
                            restore: true)),
        withKey: "energyDashOn")
    }
    func updateDashPosition(){
        energyDash.position = CGPoint(x: pacer.position.x, y: pacer.position.y)
    }
    
    func buildPacer(){
        let pacerAnimatedAtlas = SKTextureAtlas(named: "RUNNER")
        var runFrames: [SKTexture] = []
        
        let numImages = pacerAnimatedAtlas.textureNames.count
        for i in 1...numImages{
            let pacerTextureName = "RUNNER\(i)"
            runFrames.append(pacerAnimatedAtlas.textureNamed(pacerTextureName))
        }
        
        pacerRunFrames = runFrames
        let firstFrameTexture = pacerRunFrames[0]
        pacer.name = "pacer"
        pacer = SKSpriteNode(texture: firstFrameTexture)
        pacer.position = CGPoint(x: 200, y: frame.maxY)
        pacer.size = CGSize(width: 200, height: 100)
        
        pacer.physicsBody = SKPhysicsBody(rectangleOf:pacer.frame.size)
        pacer.physicsBody!.categoryBitMask = PhysicsCategory.Pacer
        
        // Note: Both Contact and Collision is needed
        //        pacer.physicsBody!.contactTestBitMask = PhysicsCategory.Bottom
        //        pacer.physicsBody?.collisionBitMask = PhysicsCategory.Bottom
        pacer.physicsBody!.usesPreciseCollisionDetection = true
        pacer.physicsBody?.contactTestBitMask = 0b10
        pacer.physicsBody?.collisionBitMask = 0b10
        
        pacer.physicsBody?.isDynamic = true
        pacer.physicsBody?.allowsRotation = false
        pacer.physicsBody?.affectedByGravity = true
        pacer.physicsBody?.friction = 0
        
        addChild(pacer)
        
    }
    
    func animatePacer(){
        pacer.run(SKAction.repeatForever(
            SKAction.animate(with: pacerRunFrames,
                             timePerFrame: 0.08,
                             resize: false,
                             restore: true)),
                  withKey: "runInPlacePacer")
    }
    // Back barrier
    func createWallL(){
        let wallL = SKSpriteNode(imageNamed: "Cyan bar")
        wallL.size = CGSize(width: 25, height: 5000)
        wallL.color = UIColor.white
        wallL.position = CGPoint(x: 50, y: 0)
        wallL.name = "WallL"
        
        wallL.physicsBody = SKPhysicsBody(rectangleOf: wallL.frame.size)
        wallL.physicsBody!.isDynamic = false
        wallL.physicsBody!.affectedByGravity = false
        wallL.physicsBody!.categoryBitMask = PhysicsCategory.Bottom
        wallL.physicsBody!.contactTestBitMask = PhysicsCategory.Rock
        wallL.physicsBody?.collisionBitMask = PhysicsCategory.Rock
        wallL.physicsBody!.usesPreciseCollisionDetection = true
        
        wallL.physicsBody?.restitution = 0
        wallL.physicsBody!.usesPreciseCollisionDetection = true
        
        self.addChild(wallL)
    }
    
    //The Ground
    func createBoundary(){
        let boundary = SKSpriteNode(imageNamed: "Blue bar")
        boundary.size = CGSize(width: 100000, height: 64)
        boundary.color = UIColor.white
        boundary.position = CGPoint(x: frame.minX, y: frame.minY)
        boundary.name = "boundary"
        
        boundary.physicsBody?.restitution = 0
        boundary.physicsBody = SKPhysicsBody(rectangleOf: boundary.frame.size)
        boundary.physicsBody!.isDynamic = false
        boundary.physicsBody!.affectedByGravity = false
        boundary.physicsBody!.categoryBitMask = PhysicsCategory.Bottom
        boundary.physicsBody!.contactTestBitMask = PhysicsCategory.Pacer
        boundary.physicsBody!.collisionBitMask = PhysicsCategory.Pacer
        boundary.physicsBody!.usesPreciseCollisionDetection = true
        
        
        self.addChild(boundary)
    }
    // The Sky
    func createBoundary2(){
        let boundary = SKSpriteNode(imageNamed: "Blue bar")
        boundary.size = CGSize(width: 100000, height: 64)
        boundary.color = UIColor.white
        boundary.position = CGPoint(x: frame.maxX, y: frame.maxY)
        boundary.name = "boundary2"
        
        boundary.physicsBody?.restitution = 0
        boundary.physicsBody = SKPhysicsBody(rectangleOf: boundary.frame.size)
        boundary.physicsBody!.isDynamic = false
        boundary.physicsBody!.affectedByGravity = false
        boundary.physicsBody!.categoryBitMask = PhysicsCategory.Bottom
        boundary.physicsBody!.contactTestBitMask = PhysicsCategory.Pacer
        boundary.physicsBody!.collisionBitMask = PhysicsCategory.Pacer
        boundary.physicsBody!.usesPreciseCollisionDetection = true
        
        
        self.addChild(boundary)
    }
    //Platforms 1
    
    func buildField(){
        let rock4 = SKSpriteNode(imageNamed: "bounceRing")
        rock4.name = "eField"
        rock4.size = CGSize(width: 250, height: 250)
        rock4.position = CGPoint(x: pacer.position.x + 1000, y: pacer.position.y)
        
        rock4.physicsBody = SKPhysicsBody(rectangleOf: rock4.frame.size)
        rock4.physicsBody!.isDynamic = true
        rock4.physicsBody!.affectedByGravity = false
        rock4.physicsBody!.categoryBitMask = PhysicsCategory.Rock
        
        // 0b1001 refers to anything with a 1 at the front and a 1 at the back, so it refers to Pacer and eDash
        rock4.physicsBody!.contactTestBitMask = PhysicsCategory.eDash | PhysicsCategory.Pacer
        rock4.physicsBody!.collisionBitMask = PhysicsCategory.None
        
        rock4.physicsBody?.restitution = 2
        rock4.physicsBody!.usesPreciseCollisionDetection = true
        
        let moveLeft = SKAction.moveBy(x: -6500, y: 0, duration: 5)
        let moveSequence = SKAction.sequence([moveLeft, SKAction.removeFromParent()])
        rock4.run(moveSequence)
        self.addChild(rock4)
        rocks.append(rock4)
    }
    func startField(image: String, size: CGSize, delay: TimeInterval) {
        let create = SKAction.run { [unowned self] in
            self.buildField()}
        let wait = SKAction.wait(forDuration: delay)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        self.run(repeatForever) }
    
    //The Nodes have been shifted out to allow despawning
    //Functions that create platfomrs
    func createRock(image: String, size: CGSize){
        //generate random number between -100 and 100
        let rock = SKSpriteNode()
        rock.texture = SKTexture(imageNamed: image)
        rock.size = CGSize(width: size.width, height: size.height)
        rock.position = CGPoint(x: startX, y: startY)
        startY = 200
        startY += Int.random(in: -150..<100)
        rock.zPosition = -10
        //rock physics properties
        rock.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rock.frame.size.width, height: rock.frame.size.height))
        rock.physicsBody!.categoryBitMask = PhysicsCategory.Rock
        
        rock.physicsBody?.collisionBitMask = PhysicsCategory.Pacer
        rock.physicsBody!.contactTestBitMask = PhysicsCategory.Pacer
        rock.physicsBody?.collisionBitMask = PhysicsCategory.Bottom
        rock.physicsBody!.contactTestBitMask = PhysicsCategory.Bottom
        rock.physicsBody?.isDynamic = false
        //animate the background
        let moveLeft = SKAction.moveBy(x: -6500, y: 0, duration: 5)
        let moveSequence = SKAction.sequence([moveLeft, SKAction.removeFromParent()])
        rock.run(moveSequence)
        self.addChild(rock)
        rocks.append(rock)
        
        //create scoring block
        let scorer = SKSpriteNode()
        scorer.size = CGSize(width: 40, height: 4000)
        scorer.position = CGPoint(x: 1000, y: -640)
        scorer.color = UIColor.clear
        scorer.physicsBody = SKPhysicsBody(rectangleOf:scorer.frame.size)
        scorer.physicsBody!.categoryBitMask = PhysicsCategory.Scorer
        scorer.physicsBody!.contactTestBitMask = PhysicsCategory.Pacer
        scorer.physicsBody!.collisionBitMask = PhysicsCategory.Scorer
        scorer.physicsBody?.isDynamic = false
        //animate scorer
        let left = SKAction.moveBy(x: -1500, y: 0, duration: 6)
        let sequence = SKAction.sequence([left,SKAction.removeFromParent()])
        scorer.run(sequence)
        self.addChild(scorer)
        
        
    }
    func startRocks(image: String, size: CGSize, delay: TimeInterval) {
        let create = SKAction.run { [unowned self] in
            self.createRock(image: image, size: size) }
        let wait = SKAction.wait(forDuration: delay)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        self.run(repeatForever) }
    
    
    func createRock2(image: String, size: CGSize){
        //generate random number between -100 and 100
        let rock2 = SKSpriteNode()
        var Ypos = rock2.position.y
        Ypos = CGFloat(Int.random(in: 700..<900))
        
        rock2.texture = SKTexture(imageNamed: image)
        rock2.size = CGSize(width: size.width, height: size.height)
        
        rock2.position = CGPoint(x: startX, y: Int(Ypos))
        rock2.zPosition = -10
        //rock physics properties
        rock2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rock2.frame.size.width, height: rock2.frame.size.height))
        rock2.physicsBody!.categoryBitMask = PhysicsCategory.Rock
        
        rock2.physicsBody?.collisionBitMask = PhysicsCategory.Pacer
        rock2.physicsBody!.contactTestBitMask = PhysicsCategory.Pacer
        rock2.physicsBody?.collisionBitMask = PhysicsCategory.Bottom
        rock2.physicsBody!.contactTestBitMask = PhysicsCategory.Bottom
        
        rock2.physicsBody?.isDynamic = false
        //animate the background
        let moveLeft = SKAction.moveBy(x: -6500, y: 0, duration: 5)
        let moveSequence = SKAction.sequence([moveLeft, SKAction.removeFromParent()])
        rock2.run(moveSequence)
        self.addChild(rock2)
        rocks.append(contentsOf: [rock2])
    }
    func startRocks2(image: String, size: CGSize, delay: TimeInterval) {
        let create = SKAction.run { [unowned self] in
            self.createRock2(image: image, size: size) }
        let wait = SKAction.wait(forDuration: delay)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        self.run(repeatForever) }
    
    func createRock3(image: String, size: CGSize){
        //generate random number between -100 and 100
        let rock3 = SKSpriteNode()
        var Ypos = rock3.position.y
        Ypos = CGFloat(Int.random(in: 500..<600))
        
        rock3.texture = SKTexture(imageNamed: image)
        rock3.size = CGSize(width: size.width, height: size.height)
        
        rock3.position = CGPoint(x: startX, y: Int(Ypos))
        rock3.zPosition = -10
        //rock physics properties
        rock3.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rock3.frame.size.width, height: rock3.frame.size.height))
        rock3.physicsBody!.categoryBitMask = PhysicsCategory.Rock
        
        rock3.physicsBody?.collisionBitMask = PhysicsCategory.Pacer
        rock3.physicsBody!.contactTestBitMask = PhysicsCategory.Pacer
        rock3.physicsBody?.collisionBitMask = PhysicsCategory.Bottom
        rock3.physicsBody!.contactTestBitMask = PhysicsCategory.Bottom
        
        rock3.physicsBody?.isDynamic = false
        //animate the background
        let moveLeft = SKAction.moveBy(x: -6500, y: 0, duration: 5)
        let moveSequence = SKAction.sequence([moveLeft, SKAction.removeFromParent()])
        rock3.run(moveSequence)
        self.addChild(rock3)
        rocks.append(contentsOf: [rock3])
    }
    func startRocks3(image: String, size: CGSize, delay: TimeInterval) {
        let create = SKAction.run { [unowned self] in
            self.createRock3(image: image, size: size) }
        let wait = SKAction.wait(forDuration: delay)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        self.run(repeatForever) }
    
    //let nodeA = SKSpriteNode(imageNamed: "bounceRing")
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Code below is unused and does nothing
        if let nodeA = contact.bodyA.node as? SKSpriteNode,
                 let nodeB = contact.bodyB.node as? SKSpriteNode,
                 let nodeC = self.childNode(withName: "pacer") as? SKSpriteNode {
                  if (nodeA.name == "node1" && nodeB.name == "node2" && nodeC.name == "node3") ||
                      (nodeA.name == "node2" && nodeB.name == "node1" && nodeC.name == "node3") {
                      print("Contact between node1, node2, and node3 detected!")
                  }
              }
        
        
        let collsionObject = contact.bodyA.categoryBitMask == PhysicsCategory.Pacer ? contact.bodyB : contact.bodyA
        //        if collsionObject.categoryBitMask == PhysicsCategory.Bottom{
        //            print("alien hit Bottom")
        //            self.view?.isPaused = true
        //        }
        if collsionObject.categoryBitMask == PhysicsCategory.Rock{
            print("touchdown")
        }else if collsionObject.categoryBitMask == PhysicsCategory.eDash{
            print ("field break")
        }
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        updateScore()
        updateDashPosition()
        highscore = highscore + 1
        
        //cameraUpdate()
        if pacer.position.x <= 200{
            pacer.physicsBody?.velocity.dx = 15
        }else{
            pacer.physicsBody?.velocity.dx = 5
        }
            
        if pacer.position.x <= 50{
            pacer.removeFromParent()
            scene?.isPaused = true
            stopButtonNode.isPaused = false
            
            let transition = SKTransition.crossFade(withDuration: 0.5)
            //let gameScene = GameScene(size: self.size) Use format below
            let nextScene = SKScene(fileNamed: "ScoreScene") as! ScoreScene
            self.view?.presentScene(nextScene, transition: transition)
            
        }else if pacer.position.y <= -100{
            // Ground
            pacer.removeFromParent()
            scene?.isPaused = true
            stopButtonNode.isPaused = false
            let transition = SKTransition.crossFade(withDuration: 0.5)
            //let gameScene = GameScene(size: self.size) Use format below
            let nextScene = SKScene(fileNamed: "ScoreScene") as! ScoreScene
            self.view?.presentScene(nextScene, transition: transition)
        }else if pacer.position.y >= frame.maxY + 10{
            //sky
            pacer.removeFromParent()
            scene?.isPaused = true
            stopButtonNode.isPaused = false
            let transition = SKTransition.crossFade(withDuration: 0.5)
            //let gameScene = GameScene(size: self.size) Use format below
            let nextScene = SKScene(fileNamed: "ScoreScene") as! ScoreScene
            self.view?.presentScene(nextScene, transition: transition)
            
        }
        // Despawns the Rocks off screen
        for rock4 in rocks{
            if rock4.position.x >= -5000{
                self.removeFromParent()
            }
        }
        for rock3 in rocks{
            if rock3.position.x >= -5000{
                self.removeFromParent()
                //print("despawned Rock3")
            }
        }
        for rock2 in rocks{
            if rock2.position.x >= -5000{
                self.removeFromParent()
                //print("despawned Rock2")
            }
        }
        for rock in rocks {
            // despawn the rock if it is off the screen
            if rock.position.x >= -5000 {
                self.removeFromParent()
                //print("despawned Rock1")
            }
        }
        
        
    }
}
