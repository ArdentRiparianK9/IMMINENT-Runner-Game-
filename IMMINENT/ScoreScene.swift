//
//  ScoreScene.swift
//  IMMINENT
//
//  Created by Kayla A. Yang  on 5/6/2023.
//

import SpriteKit
import UIKit
import GameplayKit


class ScoreScene: SKScene {

    var returnButtonNode: SKSpriteNode!
    var playButtonNode: SKSpriteNode!
   // var scoreLabelNode: SKLabelNode!
    
    
    
    func generateLabel(){
        let label = SKLabelNode(fontNamed:"Futura")
        label.fontColor = SKColor.red
        label.text = String(highscore)
        label.fontSize = 200
        label.position = CGPoint(x:frame.midX,y:frame.midY)
        addChild(label)
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func didMove(to view: SKView) {
        if appDelegate.sfx?.isPlaying == false {
            appDelegate.sfx?.play()
        }

       // stopButtonNode = self.childNode(withName: "stopButton") as? SKSpriteNode
        returnButtonNode = self.childNode(withName: "returnButton") as? SKSpriteNode
        returnButtonNode.anchorPoint = CGPoint(x: 0, y: 0)
        playButtonNode = self.childNode(withName: "playButton") as? SKSpriteNode
        playButtonNode.anchorPoint = CGPoint(x: 0, y: 0)
        
//        scoreLabelNode = self.childNode(withName: "hScore1") as? SKLabelNode
//        scoreLabelNode.scene?.anchorPoint = CGPoint(x: 0, y: 0)
        
        generateLabel()
        highscore = 0

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "returnButton" {
                let transition = SKTransition.crossFade(withDuration: 0.5)
                //let gameScene = GameScene(size: self.size) Use format below
                let nextScene = SKScene(fileNamed: "MenuScene") as! MenuScene
                self.view?.presentScene(nextScene, transition: transition)
                
                // This else if : Is a place holder
            } else if nodesArray.first?.name == "playButton"{
                // Note this is not used but is left over
                let transition = SKTransition.crossFade(withDuration: 0.5)
                //let gameScene = GameScene(size: self.size) Use format below
                let nextScene = SKScene(fileNamed: "GameScene") as! GameScene
                self.view?.presentScene(nextScene, transition: transition)
         
                
                
            }
            
            
        }
        
// Function can be placed here


        }
    }
    
    
