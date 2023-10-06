//
//  VideoPlayerView.swift
//  OpenAI
//
//  Created by Apple on 2023/04/02.
//

import SwiftUI
import AVFoundation

struct VideoPlayerView: UIViewRepresentable {
    let player: AVPlayer
    
    init(url: URL) {
        self.player = AVPlayer(url: url)
    }
    
    func makeUIView(context: Context) -> UIView {
        let videoPlayerView = VideoPlayerUIView(player: player)
        videoPlayerView.clipsToBounds = true
        videoPlayerView.contentMode = .scaleAspectFill
        videoPlayerView.playerLayer.videoGravity = .resizeAspectFill
        return videoPlayerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
    func play() {
        player.play()
    }
}

class VideoPlayerUIView: UIView {
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
