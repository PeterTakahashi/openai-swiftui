//
//  SampleWhisperView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/02.
//

import SwiftUI

struct SampleWhisperView: View {
    @StateObject private var audioRecorder = AudioRecorder()
    @State private var recognizedText = ""
    let apiKey: String = "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"
    
    var body: some View {
        VStack {
            Text("Recognized Text: \(recognizedText)")
                .padding()
            Button(action: {
                if audioRecorder.isRecording {
                    audioRecorder.stopRecording()
                    audioRecorder.recognizeSpeech(apiKey: apiKey) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let text):
                                recognizedText = text
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                } else {
                    audioRecorder.startRecording()
                }
            }) {
                Text(audioRecorder.isRecording ? "Stop Recording" : "Start Recording")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
    }
}


struct SampleWhisperView_Previews: PreviewProvider {
    static var previews: some View {
        SampleWhisperView()
    }
}
