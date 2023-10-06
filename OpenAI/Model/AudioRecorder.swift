//
//  AudioRecorder.swift
//  OpenAI
//
//  Created by Apple on 2023/04/05.
//

import Foundation
import AVFoundation
import Speech
import AudioToolbox

class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
    @Published var isRecording = false
    @Published var recognizedText: String = ""
    private var audioRecorder: AVAudioRecorder!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var speechRecognizer = SFSpeechRecognizer()
    private var audioEngine: AVAudioEngine!
    private var isAuthorized: Bool = false
    private var silenceTimer: Timer?
    private let silenceDuration: TimeInterval = 3.0
    
    override init() {
        super.init()
        self.speechRecognizer?.delegate = self
    }

    func startRecording() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                self.isAuthorized = authStatus == .authorized
                if self.isAuthorized {
                    self.beginRecording()
                } else {
                    print("Speech recognition authorization not granted")
                }
            }
        }
    }
    
    func stopRecording() {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }

        if let recognitionRequest = recognitionRequest {
            recognitionRequest.endAudio()
            self.recognitionRequest = nil
        }

        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)

        // Set the audio session to playback mode
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        try? AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

        DispatchQueue.main.async {
            self.isRecording = false
        }
    }

    private func beginRecording() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

            self.audioEngine = AVAudioEngine()
            let inputNode = self.audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)

            self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = self.recognitionRequest else { return }

            recognitionRequest.shouldReportPartialResults = true

            self.recognitionTask = self.speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
                if let result = result {
                    DispatchQueue.main.async {
                        self.recognizedText = result.bestTranscription.formattedString
                    }
                    
                    self.silenceTimer?.invalidate()
                         self.silenceTimer = Timer.scheduledTimer(withTimeInterval: self.silenceDuration, repeats: false, block: { _ in
                             self.stopRecording()
                    })
                }

                if error != nil {
                    self.stopRecording()
                }
            })

            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
                self.recognitionRequest?.append(buffer)
            }

            self.audioEngine.prepare()
            try self.audioEngine.start()
            self.isRecording = true
        } catch {
            print("Error in setting up the audio session: \(error.localizedDescription)")
        }
    }
}

extension AudioRecorder: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("Speech recognition is now available")
        } else {
            print("Speech recognition is not available")
        }
    }
}
