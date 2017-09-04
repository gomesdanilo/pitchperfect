//
//  VoiceRecorder.swift
//  pitchperfect
//
//  Created by Danilo Gomes on 04/09/2017.
//  Copyright © 2017 Danilo Gomes. All rights reserved.
//

import UIKit
import  AVFoundation

protocol VoiceRecorderDelegate {
    func didRecordAudio(audio : RecordedVoice)
    func errorRecordingAudio(message : String)
}

class VoiceRecorder : NSObject{
    
    var delegate : VoiceRecorderDelegate?
    
    fileprivate var audioRecorder: AVAudioRecorder!
    fileprivate var recordedVoice: RecordedVoice?
    
    override init() {
        super.init()
        configureAudioSession()
    }
    
    func configureAudioSession() {
    
        let session = AVAudioSession.sharedInstance()
        do {
            
            try session.setCategory(AVAudioSessionCategoryRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
            try session.setActive(true)
            session.requestRecordPermission{ (granted) in
                // done
            }
        } catch {
            // error
        }
    }
    
    
    func record(){
        do {
            self.recordedVoice = RecordedVoice()
            self.recordedVoice!.path = createFilePathOnDocumentsFolder() as URL
            audioRecorder = try AVAudioRecorder(url: self.recordedVoice!.path!, settings: [:])
            audioRecorder.delegate = self
        } catch {
            // Error
        }
        
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stop(){
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
        if let del = self.delegate, let audio = recordedVoice {
            del.didRecordAudio(audio: audio)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        // Error
        if let del = self.delegate {
            del.errorRecordingAudio(message: "Failed to record audio.")
        }
    }
}
