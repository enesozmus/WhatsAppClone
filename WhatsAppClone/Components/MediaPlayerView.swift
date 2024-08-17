//
//  MediaPlayerView.swift
//  WhatsAppClone
//
//  Created by enesozmus on 17.08.2024.
//

import AVKit
import SwiftUI


// MARK: View
struct MediaPlayerView: View {
    
    // MARK: Properties
    let player: AVPlayer
    let dismissPlayer: () -> Void
    
    var body: some View {
        VideoPlayer(player: player)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .overlay(alignment: .topLeading) {
                cancelButton()
                    .padding()
            }
            .onAppear { player.play() }
    }
    
    private func cancelButton() -> some View {
        Button {
            dismissPlayer()
        } label: {
            Image(systemName: "xmark")
                .scaledToFit()
                .imageScale(.large)
                .padding(10)
                .foregroundStyle(.white)
                .background(.white.opacity(0.5))
                .clipShape(Circle())
                .shadow(radius: 5)
                .padding(2)
                .bold()
        }
    }
}
