//
//  Playlist.swift
//  Assignment 5
//
//  Created by Aashay Pawar on 17/02/24.
//

import Foundation

class Playlist: Codable {
    var name: String
    var songs: [Song]
    
    init(name: String, songs: [Song]) {
        self.name = name
        self.songs = songs
    }
}

func displayAllPlaylists() {
    let boxWidth = 38
    let title = "All Playlists 🎵"
    let paddingCount = (boxWidth - title.count) / 2
    let padding = String(repeating: " ", count: paddingCount)
    print("┌──────────────────────────────────────┐")
    print("│\(padding)\(title)\(padding)│")
    print("├──────────────────────────────────────┤")
    if playlists.isEmpty {
        print("│         No playlists found           │")
    } else {
        for (index, playlist) in playlists.enumerated() {
            let line = "│ \(index). \(playlist.name.padding(toLength: 32, withPad: " ", startingAt: 0))  │"
            print(line)
        }
    }
    print("└──────────────────────────────────────┘")
}

func menuAllPlaylists() {
    print("\n1. Create a New Playlist")
    print("2. Add Songs to a Playlist")
    print("3. Update Playlist Name")
    print("4. Delete a Playlist")
    print("5. 🔙")
    print("6. Show songs in Playlist")
    print("7. Remove Songs from a Playlist")
}
