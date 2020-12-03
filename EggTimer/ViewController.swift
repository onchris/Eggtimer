//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let eggTimes = ["Soft": 5 * 60, "Medium": 7 * 60, "Hard": 12 * 60]
    var secondsRemaining = 0
    var timer = Timer()
    var ratio = Float(0)
    var player: AVAudioPlayer?
    
    @IBOutlet weak var viewMessage: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBAction func hardnessSelector(_ sender: UIButton) {
        timer.invalidate()
        
        let hardness = sender.currentTitle!
        print(hardness)
        
        secondsRemaining = eggTimes[hardness]!
        ratio = Float(1) / Float(secondsRemaining)
        viewMessage.text = hardness
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateTimer() {
        if secondsRemaining > 0 {
            print ("\(self.secondsRemaining) seconds")
            progressBar.progress = 1 - (Float(ratio) * Float(secondsRemaining))
            secondsRemaining -= 1
        } else {
            timer.invalidate()
            progressBar.progress = 1
            viewMessage.text = "Done!"
            playSound()
        }
    }

    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
