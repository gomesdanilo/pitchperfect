//
//  VoicePlayer.swift
//  pitchperfect
//
//  Created by Danilo Gomes on 04/09/2017.
//  Copyright © 2017 Danilo Gomes. All rights reserved.
//

import UIKit
import AVFoundation

enum VoiceMode {
    case slow
    case fast
    case lowPitch
    case highPitch
    case echo
    case reverb
}

class VoicePlayer : NSObject, AVAudioPlayerDelegate {
    
    var audioEngine : AVAudioEngine?
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    var audioFile : AVAudioFile?
    var completionHandler: (String?) -> Void = {_ in }
    
    override init() {
        super.init()
    }
    
    func playAudio(audio : RecordedVoice, mode: VoiceMode, playbackFinished : @escaping (String?) -> Void){
        
        do {
            // Resets any pending timers.
            stop()
            
            completionHandler = playbackFinished
            audioFile = try AVAudioFile(forReading: audio.path!)

            switch (mode) {
                case .slow:
                    try playSound(rate: 0.5)
                case .fast:
                    try playSound(rate: 1.5)
                case .highPitch:
                    try playSound(pitch: 1000)
                case .lowPitch:
                    try playSound(pitch: -1000)
                case .echo:
                    try playSound(echo: true)
                case .reverb:
                    try playSound(reverb: true)
            }
        } catch  {
            playbackFinished("Failed to play audio")
        }
    }
    
    func stop() {
        if let timer = stopTimer {
            timer.invalidate()
            stopTimer = nil
        }

        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.stop()
        }

        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
    func initializeEngine(output: inout [AVAudioNode]){
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine!.attach(audioPlayerNode)
        
        output.append(audioPlayerNode)
    }

    
    func adjustRateAndPitch(rate: Float? = nil, pitch: Float? = nil,
                            output: inout [AVAudioNode]){
        let changeRatePitchNode = AVAudioUnitTimePitch()
        if let pitch = pitch {
            changeRatePitchNode.pitch = pitch
        }
        if let rate = rate {
            changeRatePitchNode.rate = rate
        }
        audioEngine!.attach(changeRatePitchNode)
        
        output.append(changeRatePitchNode)
        
    }

    func adjustEcho(echo: Bool = false, output: inout [AVAudioNode]){
        
        if(echo){
            let echoNode = AVAudioUnitDistortion()
            echoNode.loadFactoryPreset(.multiEcho1)
            audioEngine!.attach(echoNode)
            output.append(echoNode)
        }
    }

    
    func adjustReverb(reverb: Bool = false, output: inout [AVAudioNode]){
        if(reverb)
        {
            let reverbNode = AVAudioUnitReverb()
            reverbNode.loadFactoryPreset(.cathedral)
            reverbNode.wetDryMix = 50
            audioEngine!.attach(reverbNode)
            
            output.append(reverbNode)
        }
    }
    
    func getPlaybackTime(rate: Float? = nil) -> Double {
        
        var timeInSeconds: Double = 0
        
        if let lastRenderTime = self.audioPlayerNode.lastRenderTime,
           let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
            
            if let rate = rate {
                timeInSeconds = Double(self.audioFile!.length - playerTime.sampleTime) / Double(self.audioFile!.processingFormat.sampleRate) / Double(rate)
            } else {
                timeInSeconds = Double(self.audioFile!.length - playerTime.sampleTime) / Double(self.audioFile!.processingFormat.sampleRate)
            }
        }
        return timeInSeconds;
    }
    

    func schedulePlay(rate: Float? = nil) throws {
        
        audioPlayerNode.stop()
        audioPlayerNode!.scheduleFile(audioFile!, at: nil) {
            
            let playbackTime = self.getPlaybackTime(rate: rate)

            self.stopTimer = Timer(timeInterval: playbackTime, repeats: false, block: { (timer) in
                self.stop()
                self.completionHandler(nil)
            })
            RunLoop.main.add(self.stopTimer!, forMode: RunLoopMode.defaultRunLoopMode)
        }
        
        do {
            try audioEngine!.start()
            audioPlayerNode.play()
        } catch {
            // Error
            throw error
        }
    }
    
    func playSound(rate: Float? = nil, pitch: Float? = nil,
                   echo: Bool = false, reverb: Bool = false) throws {
        
        var audioNodes : [AVAudioNode] = []
        
        initializeEngine(output: &audioNodes)
        adjustRateAndPitch(rate: rate, pitch: pitch, output: &audioNodes)
        adjustEcho(echo: echo, output: &audioNodes)
        adjustReverb(reverb: reverb, output: &audioNodes)
        
        audioNodes.append(audioEngine!.outputNode)
        
        connectAudioNodes(nodes: audioNodes)

        try schedulePlay(rate: rate)
    }

    func connectAudioNodes(nodes: [AVAudioNode]) {
        for x in 0..<nodes.count-1 {
            audioEngine?.connect(nodes[x], to: nodes[x+1], format: audioFile!.processingFormat)
        }
    }
}
