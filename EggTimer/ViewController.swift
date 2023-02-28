//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//
//  Updated by Pino Omodei on 28.02.2023
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // dictionary dei tempi di cottura (Keys hardcoded nei tre bottoni)
    let eggTime = ["Soft" : 300, "Medium" : 480, "Hard" : 720]
    
    // gestione del timer
    var counter : Int = 0
    var cookingTime : Int = 0
    var timer = Timer()  // istanzio un (oggetto di classe) Timer
    
    // Outlet delle componenti
    @IBOutlet weak var outletLabel: UILabel!
    let originalLabel = "How do you like your eggs?" // questa secondo me andrebbe nella onLoad(), ma qui non c'è...
    @IBOutlet weak var progressBar: UIProgressView!
    
    // Audio Player: va dichiarato qui se no non funziona!
    var player: AVAudioPlayer!
    
    // Action dei tre bottoni
    @IBAction func hardnessSelected(_ sender: UIButton) {
        // just in case these buttons are tapped multiple times
        timer.invalidate()
        
        // set the timer to the eggTime selected and start it
        cookingTime = eggTime[sender.currentTitle!]!
        counter = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        outletLabel.text = "Cooking " + sender.currentTitle!
        
    }
    
    // executed every second
    @objc func updateCounter() {
        // countdown and manage the completion
        if counter < cookingTime {
            counter += 1
            progressBar.progress = Float(counter) / Float(cookingTime)
        } else {
            timer.invalidate()  // stop the timer
            updateApp()         // give the feedback
        }
    }
    
    // executed at the end
    func updateApp() {
        // alert the user
        outletLabel.text = "DONE!"
        playSound()
        
        // reset after 3 secs
        let deadlineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.outletLabel.text = self.originalLabel
            self.progressBar.progress = 0.0
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
            else {
                print("sound not found")
                return
            }
        print("sound found")
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        player!.play()
    }
}
