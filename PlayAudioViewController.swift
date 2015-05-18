//
//  PlayAudioViewController.swift
//  PitchMyVoice
//
//  Created by Aras Senova on 2015-05-16.
//  Copyright (c) 2015 Aras Senova. All rights reserved.
//

import UIKit
import AVFoundation

class PlayAudioViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0.0
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        stopAllAudio()
    }
    
    @IBAction func playSlow(sender: UIButton) {
        stopAllAudio()
        
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }

    @IBAction func playFast(sender: UIButton) {
        stopAllAudio()
        
        audioPlayer.rate = 2.0
        audioPlayer.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func darthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    @IBAction func reverbAudio(sender: UIButton) {
        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        var unitReverb = AVAudioUnitReverb()
        unitReverb.wetDryMix = 99.5
        
        audioEngine.attachNode(unitReverb)
        audioEngine.connect(audioPlayerNode, to: unitReverb, format: nil)
        audioEngine.connect(unitReverb, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    @IBAction func echoAudio(sender: UIButton) {
        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        var unitReverb = AVAudioUnitDelay()
        unitReverb.delayTime = 1
        
        audioEngine.attachNode(unitReverb)
        audioEngine.connect(audioPlayerNode, to: unitReverb, format: nil)
        audioEngine.connect(unitReverb, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
}
