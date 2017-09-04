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
    
    var recoder : VoiceRecorder?
    
    @IBAction func didClickOnRecord(_ sender: Any) {
        recoder?.record()
        updateUiForRecording()
    }
    
    
    @IBAction func didClickOnStop(_ sender: Any) {
        recoder?.stop()
        updateUiForPaused()
        goToPlayScreen()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recoder = VoiceRecorder()
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
            
            
        }
    }
    
    
}
