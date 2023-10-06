//
//  AudioRecorder.swift
//  OpenAI
//
//  Created by Apple on 2023/04/02.
//

import Foundation
import AVFoundation

class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    @Published var isRecording = false
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        try? recordingSession.setCategory(.record, mode: .default)
        try? recordingSession.setActive(true)
        
        let url = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        try? audioRecorder = AVAudioRecorder(url: url, settings: settings)
        audioRecorder.delegate = self
        audioRecorder.record()
        
        isRecording = true
    }
    
    func stopRecording() {
        audioRecorder.stop()
        isRecording = false
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func recognizeSpeech(apiKey: String, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let audioData = try Data(contentsOf: audioRecorder.url)
            print(audioRecorder.url)
            requestOpenAIAPITranscription(apiKey: apiKey, audioData: audioData, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
}

func requestOpenAIAPITranscription(apiKey: String, audioData: Data, completion: @escaping (Result<String, Error>) -> Void) {
    let urlString = "https://api.openai.com/v1/audio/transcriptions"
    
    guard let url = URL(string: urlString) else {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        completion(.failure(error))
        return
    }
    
    let boundary = "Boundary-\(UUID().uuidString)"
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    let modelName = "whisper-1"
    var data = Data()
    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
    data.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
    data.append("\(modelName)\r\n".data(using: .utf8)!)
    
    data.append("--\(boundary)\r\n".data(using: .utf8)!)
    data.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.m4a\"\r\n".data(using: .utf8)!)
    data.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
    data.append(audioData)
    data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

    let task = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
            completion(.failure(error))
            return
        }

        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let json = jsonObject as? [String: Any], let text = json["transcription"] as? String else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                completion(.failure(error))
                return
            }

            completion(.success(text))
        } catch {
            completion(.failure(error))
        }
    }
    task.resume()
}

