//
//  ViewController.swift
//  tryAVFoundation
//
//  Created by DboyLiao on 3/2/16.
//  Copyright © 2016 dboyliao. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var player:AVAudioPlayer!
    var updater:CADisplayLink!
    
    @IBOutlet weak var playTime: UISlider!
    
    override func viewDidLoad() {
        let filePath = NSBundle.mainBundle().pathForResource("trump_speech", ofType:"wav")
        
        if let filePath = filePath {
            let url = NSURL(fileURLWithPath:filePath)
            do {
                self.player = try AVAudioPlayer(contentsOfURL:url)
            } catch {
                print("can not instantiate player...")
                self.player = nil
            }
        } else {
            self.player = nil
        }
    }
    
    @IBAction func playAudio(sender: UIButton) {
        
        if self.player != nil {
            updater = CADisplayLink(target:self, selector:"trackAudio")
            updater.addToRunLoop(NSRunLoop.mainRunLoop(), forMode:NSRunLoopCommonModes)
            self.player.delegate = self
            self.player.play()
            
        } else {
            print("no player!")
        }
    }
    
    func trackAudio(){
        let normalizedTime = Float(player.currentTime * 100/player.duration)
        playTime.value = normalizedTime
    }

    @IBAction func pauseAudio(sender: UIButton) {
        
        if let player = self.player {
            player.pause()
        }
        
        if updater != nil {
            updater.invalidate()
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        
        if let player = self.player{
            player.stop()
            player.currentTime = NSTimeInterval(0)
        }
        
        if self.updater != nil {
            updater.invalidate()
        }
        
        self.playTime.value = 0
        print("stop!")
    }
    
    @IBAction func drag(sender: UISlider) {
        
        print("drag!")
        self.player.stop()
        self.player.currentTime = NSTimeInterval(sender.value / sender.maximumValue) * self.player.duration
        self.player.prepareToPlay()
        self.player.play()
    }
    
}

class PlayerView:UIView {
    
    var player:AVPlayer! {
        let layer = self.layer as! AVPlayerLayer
        return layer.player
    }
    
    override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }
    
    func setPlayer(player:AVPlayer) {
        let layer = self.layer as! AVPlayerLayer
        layer.player = player
    }

}

