//
//  AppDelegate.swift
//  Scene Test
//
//  Created by Kayla A. Yang  on 21/4/2023.
//

import UIKit
import AVFoundation
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var sfx: AVAudioPlayer?
    let fileNames: [Int: String] = [
        1: "Imminent",
        2: "Escaton",
        3: "Primeaval"
    ]
    func sfxSetup(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("Audio file not found")
            return
        }
        do {
            sfx = try AVAudioPlayer(contentsOf: url)
            sfx?.numberOfLoops = -1 // play indefinitely
            sfx?.prepareToPlay()
        } catch {
            print("Error initializing audio player: \(error.localizedDescription)")
        }
    }
    
//    func playImminent() {
//        let url = Bundle.main.url(forResource: "Imminent", withExtension: "mp3")
//        sfx = try! AVAudioPlayer(contentsOf: url!)
//        sfx.play()
//     }
//    func playEscaton() {
//        let url = Bundle.main.url(forResource: "Escaton", withExtension: "mp3")
//        sfx = try! AVAudioPlayer(contentsOf: url!)
//        sfx.play()
//     }
//    func playPrimeaval(){
//        let url = Bundle.main.url(forResource: "Primeaval", withExtension: "mp3")
//        sfx = try! AVAudioPlayer(contentsOf: url!)
//        sfx.play()
//    }

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sfxSetup(fileName: "Imminent")
        sfx?.play()
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


}

