//
//  RecordSoundsViewController.swift
//  pitchperfect
//
//  Created by Danilo Gomes on 04/09/2017.
//  Copyright © 2017 Danilo Gomes. All rights reserved.
//

import UIKit

class RecordSoundsViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var recorder : VoiceRecorder?
    var recordedVoice : RecordedVoice?
    
    @IBAction func didClickOnRecord(_ sender: Any) {
        if let rec = recorder {
            rec.record()
            updateUiForRecording()
        }
    }
    
    
    @IBAction func didClickOnStop(_ sender: Any) {
        if let rec = recorder {
            rec.stop()
            updateUiForPaused()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recorder = VoiceRecorder()
        recorder!.delegate = self
        updateUiForPaused()
    }
    
    func updateUiForRecording() {
        recordLabel.text = "Recoding... Tap to stop"
        recordButton.isEnabled = false
        stopButton.isEnabled = true
    }
    
    func updateUiForPaused() {
        recordLabel.text = "Tap to record"
        recordButton.isEnabled = true
        stopButton.isEnabled = false
    }
    
    func goToPlayScreen() {
        self.performSegue(withIdentifier: "play", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "play"){
            if let vc = segue.destination as? PlaySoundsViewController, let rec = recordedVoice {
                vc.recordedVoice = rec
            }
        }
    }
}

extension RecordSoundsViewController : VoiceRecorderDelegate {
    
    func errorRecordingAudio(message: String) {
        AlertMessage.showError(message: message, viewController: self)
    }
    
    func didRecordAudio(audio: RecordedVoice) {
        self.recordedVoice = audio
        goToPlayScreen()
    }
}
