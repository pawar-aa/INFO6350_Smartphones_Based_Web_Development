//
//  Song.swift
//  Assignment 5
//
//  Created by Aashay Pawar on 17/02/24.
//

import Foundation

class Song: Codable {
    var id: Int
    var title: String
    var uploadDate: Date
    var genere: String
    var info: String
    var duration: TimeInterval
    init(id: Int, title: String, uploadDate: Date, genere: String, info: String, duration: TimeInterval) {
        self.id = id
        self.title = title
        self.uploadDate = uploadDate
        self.genere =  genere
        self.info = info
        self.duration = duration
    }
}

var songs: [Song] = [
    Song(id: 1, title: "Tum Hi Ho", uploadDate: Date(), genere: "Love", info: "From the movie Aashiqui 2", duration: 269.0),
    Song(id: 2, title: "Chaiyya Chaiyya", uploadDate: Date(), genere: "Dance", info: "From the movie Dil Se", duration: 380.0),
    Song(id: 3, title: "Kal Ho Naa Ho", uploadDate: Date(), genere: "Sad", info: "From the movie Kal Ho Naa Ho", duration: 317.0),
    Song(id: 4, title: "Mere Sapno Ki Rani", uploadDate: Date(), genere: "Love", info: "From the movie Aradhana", duration: 312.0),
    Song(id: 5, title: "Tujhe Dekha To", uploadDate: Date(), genere: "Love", info: "From the movie Dilwale Dulhania Le Jayenge", duration: 318.0),
    Song(id: 6, title: "Senorita", uploadDate: Date(), genere: "Dance", info: "From the movie Zindagi Na Milegi Dobara", duration: 268.0),
    Song(id: 7, title: "Kabira", uploadDate: Date(), genere: "Sad", info: "From the movie Yeh Jawaani Hai Deewani", duration: 206.0),
    Song(id: 8, title: "Dil Diyan Gallan", uploadDate: Date(), genere: "Love", info: "From the movie Tiger Zinda Hai", duration: 277.0),
    Song(id: 9, title: "Gerua", uploadDate: Date(), genere: "Love", info: "From the movie Dilwale", duration: 340.0),
    Song(id: 10, title: "Tum Mile", uploadDate: Date(), genere: "Love", info: "From the movie Tum Mile", duration: 269.0),
    Song(id: 11, title: "Tu Hi Haqeeqat", uploadDate: Date(), genere: "Sad", info: "From the movie Tum Mile", duration: 268.0),
    Song(id: 12, title: "Kya Mujhe Pyaar Hai", uploadDate: Date(), genere: "Love", info: "From the movie Wo Lamhe", duration: 392.0),
    Song(id: 13, title: "Muskurane Ki Wajah Tum Ho", uploadDate: Date(), genere: "Sad", info: "From the movie CityLights", duration: 329.0),
    Song(id: 14, title: "Saajna", uploadDate: Date(), genere: "Sad", info: "From the movie I me Aur Mai", duration: 307.0),
    Song(id: 15, title: "Galliyan", uploadDate: Date(), genere: "Love", info: "From the movie Ek Villain", duration: 299.0)
]

var favourite: [Song] = []
var playlists: [Playlist] = [Playlist(name: "Favourites ❤️", songs: favourite)]

func displayAllSongs() {
    let boxWidth = 38
    let title = "All Available Songs 🎵"
    let paddingCount = (boxWidth - title.count) / 2
    let padding = String(repeating: " ", count: paddingCount)
    print("┌──────────────────────────────────────┐")
    print("│\(padding)\(title)\(padding)│")
    print("├──────────────────────────────────────┤")
    for song in songs {
        let title = "\(song.id). \(song.title)"
        let padding = String(repeating: " ", count: boxWidth - title.count - 2)
        let line = "│ \(title)\(padding) │"
        print(line)
    }
    print("└──────────────────────────────────────┘")
}

func addNewSong() {
    print("Enter the title of the song:")
    guard let title = readLine(), !title.isEmpty else {
        print("Invalid title")
        return
    }
    let newSong = Song(id: songs.count + 1, title: title, uploadDate: Date(), genere: "", info: "", duration: 0.0)
    songs.append(newSong)
    print("Song added successfully!")
}

func updateSongByIndex() {
    print("Enter the index of the song to update:")
    guard let input = readLine(), let index = Int(input) else {
        print("Invalid index")
        return
    }
    guard index >= 1 && index <= songs.count else {
        print("Invalid index")
        return
    }
    var song = songs[index - 1]
    
    print("Enter the new title of the song (press Enter to skip):")
    if let newTitle = readLine(), !newTitle.isEmpty {
        song.title = newTitle
    }
    
    print("Enter the new info of the song (press Enter to skip):")
    if let newInfo = readLine(), !newInfo.isEmpty {
        song.info = newInfo
    }
    
    print("Enter the new duration of the song (press Enter to skip):")
    if let newDurationString = readLine(), !newDurationString.isEmpty {
        if let newDuration = TimeInterval(newDurationString) {
            song.duration = newDuration
        } else {
            print("Invalid duration format. Duration must be a valid number.")
            return
        }
    }
    
    songs[index - 1] = song
    print("Song updated successfully!")
}

func deleteSongByIndex() {
    print("Enter the index of the song to delete:")
    guard let input = readLine(), let index = Int(input) else {
        print("Invalid index")
        return
    }
    guard index >= 1 && index <= songs.count else {
        print("Invalid index")
        return
    }
    
    let songToDelete = songs[index - 1]
    
    if playlists[0].songs.contains(where: { $0.title == songToDelete.title }) {
        print("Cannot delete a song from favorites.")
        return
    }
    
    if favourite.contains(where: { $0.title == songToDelete.title }){
        print("Present in Favourites, cannot delete.")
        return
    }
    
    songs.remove(at: index - 1)
    print("Song deleted successfully!")
}

func showSongDetails(song: Song) {
    print("🎵 \(song.title)")
    print("📅 \(song.uploadDate)")
    print("ℹ️ \(song.info)")
    print("🕜 \(song.duration) seconds")
}

func menuAllSongs() {
    print("\n1. Add a New Song")
    print("2. Update a Song by Index")
    print("3. Delete a Song by Index")
    print("4. Show Song Details")
    print("5. 🔙")
    print("6. Select a Song to Add to Favou")
}
