//
//  PlaySoundsViewController.swift
//  pitchperfect
//
//  Created by Danilo Gomes on 04/09/2017.
//  Copyright © 2017 Danilo Gomes. All rights reserved.
//

import UIKit

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet var modeButtonList: [UIButton]!
    var recordedVoice : RecordedVoice?
    
    var voicePlayer : VoicePlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUiStopped()
        voicePlayer = VoicePlayer()
    }
    
    func getModeFromTag(_ tag : Int) -> VoiceMode {
        
        switch tag {
            case 0:
                return VoiceMode.slow
            case 1:
                return VoiceMode.fast
            case 2:
                return VoiceMode.highPitch
            case 3:
                return VoiceMode.lowPitch
            case 4:
                return VoiceMode.echo
            case 5:
                return VoiceMode.reverb
            default:
                return VoiceMode.slow
        }
    }
    
    @IBAction func didClickOnRecord(_ sender: UIButton) {
        let mode = getModeFromTag(sender.tag)
        voicePlayer?.playAudio(audio: recordedVoice!, mode: mode)
        updateUiPlaying()
    }
    
    @IBAction func didClickOnStop(_ sender: Any) {
        updateUiStopped()
        voicePlayer?.stop()
    }
    
    
    func updateUiPlaying(){
        
        for btn in modeButtonList {
            btn.isEnabled = false
        }
        
        stopButton.isEnabled = true
    }
    
    func updateUiStopped(){
        
        for btn in modeButtonList {
            btn.isEnabled = true
        }
        
        stopButton.isEnabled = false
    
    }
    

}
