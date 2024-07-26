//
//  SettingsScene.swift
//  Scene Test
//
//  Created by Kayla A. Yang  on 18/5/2023.
//

import UIKit
import SpriteKit
import AVFoundation
class SettingsScene: SKScene {
    
    var returnButtonNode: SKSpriteNode!
    var audioButtonNode: SKSpriteNode!
    var audioLabelNode: SKLabelNode!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    override func didMove(to view: SKView) {
        if appDelegate.sfx?.isPlaying == false {
            appDelegate.sfx?.play()
        }

       // stopButtonNode = self.childNode(withName: "stopButton") as? SKSpriteNode
        returnButtonNode = self.childNode(withName: "returnButton") as? SKSpriteNode
        returnButtonNode.anchorPoint = CGPoint(x: 0, y: 0)
        audioButtonNode = self.childNode(withName: "audioButton") as? SKSpriteNode
        audioButtonNode.anchorPoint = CGPoint(x: 0, y: 0)
        
        audioLabelNode = self.childNode(withName: "musicLabel") as? SKLabelNode
        audioLabelNode.scene?.anchorPoint = CGPoint(x: 0, y: 0)
//        difficultyButtonNode = self.childNode(withName: "difficultyButton") as? SKSpriteNode
//        difficultyButtonNode.anchorPoint = CGPoint(x: 0, y: 0)
//
//        difficultyLabelNode = self.childNode(withName: "difficultyLabel") as? SKLabelNode
//        difficultyLabelNode.scene?.anchorPoint = CGPoint(x: 0, y: 0)
        
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
            
            if nodesArray.first?.name == "returnButton" {
                let transition = SKTransition.crossFade(withDuration: 0.5)
                //let gameScene = GameScene(size: self.size) Use format below
                let nextScene = SKScene(fileNamed: "MenuScene") as! MenuScene
                self.view?.presentScene(nextScene, transition: transition)
                
                // This else if : Is a place holder
            } else if nodesArray.first?.name == "audioButton"{
                // Note this is not used but is left over

                changeTrack()
                
                
            }
            
            
        }
        
// Function can be placed here
        func changeTrack(){
            let userDefaults = UserDefaults.standard
            if  audioLabelNode.text == "Imminent" {
                audioLabelNode.text = "Escaton"
                appDelegate.sfx?.stop()
                appDelegate.sfxSetup(fileName: "Escaton")
                appDelegate.sfx?.play()
                //playEscaton()
                userDefaults.set(true, forKey: "Escaton")
                userDefaults.set(false, forKey: "Imminent")
            } else{
                if audioLabelNode.text == "Escaton"{
                    audioLabelNode.text = "Primeaval"
                    appDelegate.sfx?.stop()
                    appDelegate.sfxSetup(fileName: "Primeaval")
                    appDelegate.sfx?.play()
                   // playPrimeaval()
                    userDefaults.set(false, forKey: "Escaton")
                    userDefaults.set(true, forKey: "Primeval")
                }else{
                    audioLabelNode.text = "Imminent"
                    appDelegate.sfx?.stop()
                    appDelegate.sfxSetup(fileName: "Imminent")
                    appDelegate.sfx?.play()
                    //playImminent()
                    userDefaults.set(false, forKey: "Primeaval")
                    userDefaults.set(true, forKey: "Imminent")

                }

            }
// Right now only the Imminent and Escaton work
            userDefaults.synchronize()
        }
    }
}
