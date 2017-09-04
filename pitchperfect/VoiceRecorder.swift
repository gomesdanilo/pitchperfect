//
//  VoiceRecorder.swift
//  pitchperfect
//
//  Created by Danilo Gomes on 04/09/2017.
//  Copyright © 2017 Danilo Gomes. All rights reserved.
//

import UIKit
import  AVFoundation

class VoiceRecorder : NSObject{
    
    var audioRecorder: AVAudioRecorder!
    var recordedVoice: RecordedVoice?
    
    override init() {
        super.init()
        configureAudioSession()
    }
    
    
    func configureAudioSession() {
    
        let session = AVAudioSession.sharedInstance()
        do {
            
            try session.setCategory(AVAudioSessionCategoryRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
            try  session.setActive(true)
            session.requestRecordPermission{ (granted) in
                // done
            }
        } catch {
            // error
        }
    }
    
    
    func record(){
        print("record")
        do {
            let filePath = createFilePathOnDocumentsFolder()
            audioRecorder = try AVAudioRecorder(url: filePath as URL, settings: [:])
            audioRecorder.delegate = self
        } catch {
            // Error
        }
        
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stop(){
        print("stop record")
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    private func createFilePathOnDocumentsFolder() -> NSURL {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        let documentsFolder = paths[0]
        let filePath = NSURL(fileURLWithPath: documentsFolder).appendingPathComponent("audio.wav")!
        return filePath as NSURL
    }
}

extension VoiceRecorder : AVAudioRecorderDelegate {

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // Done
        print("audioRecorderDidFinishRecording")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        // Error
        print("audioRecorderEncodeErrorDidOccur")
    }

}
