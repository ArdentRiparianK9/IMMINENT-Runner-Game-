//
//  MenuScene.swift
//  Scene Test
//
//  Created by Kayla A. Yang  on 21/4/2023.
//

import UIKit
import SpriteKit
import AVFoundation
class MenuScene: SKScene {
    //You can add a: var _____:SKemittternode for a animated bg
    
    var newGameButtonNode: SKSpriteNode!
    var difficultyButtonNode: SKSpriteNode!
    var difficultyLabelNode: SKLabelNode!
    var returnButtonNode: SKSpriteNode!
    //var stopButtonNode: SKSpriteNode!


    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func didMove(to view: SKView) {
       // stopButtonNode = self.childNode(withName: "stopButton") as? SKSpriteNode
        newGameButtonNode = self.childNode(withName: "newGameButton") as? SKSpriteNode
        newGameButtonNode.anchorPoint = CGPoint(x: 0, y: 0)
        
        difficultyButtonNode = self.childNode(withName: "difficultyButton") as? SKSpriteNode
        difficultyButtonNode.anchorPoint = CGPoint(x: 0, y: 0)
        
        difficultyLabelNode = self.childNode(withName: "difficultyLabel") as? SKLabelNode
        difficultyLabelNode.scene?.anchorPoint = CGPoint(x: 0, y: 0)
        
        returnButtonNode = self.childNode(withName: "returnButton") as? SKSpriteNode
        returnButtonNode.scene?.anchorPoint = CGPoint(x: 0, y: 0)
        //let userDefaults = UserDefaults.standard
        
       /* if userDefaults.bool(forKey: "Hard"){
            difficultyLabelNode.text = "Hard"
        }else{
            difficultyLabelNode.text = "Easy"
        }*/
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "newGameButton" {
                let transition = SKTransition.crossFade(withDuration: 0.5)
                //let gameScene = GameScene(size: self.size) Use format below
                let gameScene = SKScene(fileNamed: "GameScene") as! GameScene
                self.view?.presentScene(gameScene, transition: transition)
                
                
            }else if nodesArray.first?.name == "returnButton"{
                let transition = SKTransition.crossFade(withDuration: 0.5)
                //let gameScene = GameScene(size: self.size) Use format below
                let nextScene = SKScene(fileNamed: "SettingsScene") as! SettingsScene
                self.view?.presentScene(nextScene, transition: transition)
            }
            
            
        }
        // UNused Placeholder
        func changeDifficulty(){
            let userDefaults = UserDefaults.standard
            
            if difficultyLabelNode.text == "Easy" {
                difficultyLabelNode.text = "Hard"
                userDefaults.set(true, forKey: "Hard")
            } else{
                difficultyLabelNode.text = "Easy"
                userDefaults.set(false, forKey: "Hard")
            }
            userDefaults.synchronize()
        }
        
    }
}
