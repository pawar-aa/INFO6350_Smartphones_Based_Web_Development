//
//  Main.swift
//  Assignment 5
//
//  Created by Aashay Pawar on 17/02/24.
//
import Foundation

// Use these credentials
let validUser = User(username: "123", password: "123")

func main() {
    var isLoggedIn = false
        repeat {
            isLoggedIn = login()
        } while !isLoggedIn
        var isRunning = true
        while isRunning {
            print("\n🎵 Welcome to Music Player 🎵\n")
            print("1. Show All Songs")
            print("2. Show All Playlists")
            print("3. Logout")
            print("4. Exit")
        if let choice = readLine(), let intChoice = Int(choice) {
            switch intChoice {
            case 1:
                displayAllSongs()
                var allSongsChoice = 0
                repeat {
                    menuAllSongs()
                    if let input = readLine(), let choice = Int(input) {
                        switch choice {
                        case 1:
                            addNewSong()
                            displayAllSongs()
                        case 2:
                            updateSongByIndex()
                            displayAllSongs()
                        case 3:
                            deleteSongByIndex()
                            displayAllSongs()
                        case 4:
                            print("Enter the index of the song to view details:")
                            if let indexStr = readLine(), let index = Int(indexStr) {
                                if index >= 1 && index <= songs.count {
                                    let song = songs[index - 1]
                                    showSongDetails(song: song)
                                } else {
                                    print("Invalid index")
                                    displayAllSongs()
                                }
                            } else {
                                print("Invalid input")
                                displayAllSongs()
                            }
                        case 5:
                            allSongsChoice = 5
                            displayAllSongs()
                        case 6:
                            displayAllSongs()
                            print("Enter the number of the song you want to add to favorites:")
                            if let songIndexStr = readLine(), let songIndex = Int(songIndexStr) {
                                if songIndex >= 0 && songIndex <= songs.count {
                                    let selectedSong = songs[songIndex-1]
                                    let selectedPlaylist = playlists[0]
                                    selectedPlaylist.songs.append(selectedSong)
                                    print("Song '\(selectedSong.title)' added to '\(selectedPlaylist.name)' successfully!")
                                } else {
                                    print("Invalid song index.")
                                }
                            } else {
                                print("Invalid input for song index.")
                            }
                            break
                        default:
                            print("Invalid choice")
                        }
                    }
                } while allSongsChoice != 5
            case 2:
                displayAllPlaylists()
                var allPlaylistsChoice = 0
                repeat {
                    menuAllPlaylists()
                    if let input = readLine(), let choice = Int(input) {
                        switch choice {
                        case 1:
                            print("Enter the name of the new playlist:")
                                if let playlistName = readLine() {
                                    let newPlaylist = Playlist(name: playlistName, songs: [])
                                    playlists.append(newPlaylist)
                                    print("Playlist '\(playlistName)' created successfully!")
                                } else {
                                    print("Invalid playlist name.")
                                }
                            displayAllPlaylists()
                        case 2:
                            displayAllPlaylists()
                                print("Enter the number of the playlist you want to add songs to:")
                                if let playlistIndexStr = readLine(), let playlistIndex = Int(playlistIndexStr) {
                                    if playlistIndex >= 0 && playlistIndex < playlists.count {
                                        let selectedPlaylist = playlists[playlistIndex]
                                        displayAllSongs()
                                        print("Enter the number of the song you want to add to '\(selectedPlaylist.name)':")
                                        if let songIndexStr = readLine(), let songIndex = Int(songIndexStr) {
                                            if songIndex >= 0 && songIndex <= songs.count {
                                                let selectedSong = songs[songIndex-1]
                                                selectedPlaylist.songs.append(selectedSong)
                                                print("Song '\(selectedSong.title)' added to '\(selectedPlaylist.name)' successfully!")
                                            } else {
                                                print("Invalid song index.")
                                            }
                                        } else {
                                            print("Invalid input for song index.")
                                        }
                                    } else {
                                        print("Invalid playlist index.")
                                    }
                                } else {
                                    print("Invalid input for playlist index.")
                                }
                            displayAllPlaylists()
                        case 3:
                            displayAllPlaylists()
                                print("Enter the number of the playlist you want to update:")
                                if let playlistIndexStr = readLine(), let playlistIndex = Int(playlistIndexStr) {
                                    if playlistIndex >= 0 && playlistIndex < playlists.count {
                                        let selectedPlaylist = playlists[playlistIndex]
                                        print("Enter the new name for '\(selectedPlaylist.name)':")
                                        if let newPlaylistName = readLine() {
                                            selectedPlaylist.name = newPlaylistName
                                            print("Playlist name updated successfully!")
                                        } else {
                                            print("Invalid playlist name.")
                                        }
                                    } else {
                                        print("Invalid playlist index.")
                                    }
                                } else {
                                    print("Invalid input for playlist index.")
                                }
                            displayAllPlaylists()
                        case 4:
                            displayAllPlaylists()
                                print("Enter the number of the playlist you want to delete:")
                                if let playlistIndexStr = readLine(), let playlistIndex = Int(playlistIndexStr) {
                                    if playlistIndex == 0 {
                                        print("ERROR: Cannot delete Favourites")
                                        break
                                    }
                                    if playlists[playlistIndex].songs.isEmpty != true {
                                        print("ERROR: Cannot delete as playlist not empty")
                                        break
                                    }
                                    if playlistIndex >= 0 && playlistIndex < playlists.count {
                                        let deletedPlaylist = playlists.remove(at: playlistIndex)
                                        print("Playlist '\(deletedPlaylist.name)' deleted successfully!")
                                    } else {
                                        print("Invalid playlist index.")
                                    }
                                } else {
                                    print("Invalid input for playlist index.")
                                }
                            displayAllPlaylists()
                        case 5:
                            allPlaylistsChoice = 5
                        case 6:
                            displayAllPlaylists()
                            print("Enter the number of the playlist you want to view:")
                            if let playlistIndexStr = readLine(), let playlistIndex = Int(playlistIndexStr) {
                                if playlistIndex >= 0 && playlistIndex < playlists.count {
                                    let selectedPlaylist = playlists[playlistIndex]
                                    let boxWidth = 38
                                    print("┌──────────────────────────────────────┐")
                                    let playlistTitle = "Playlist: \(selectedPlaylist.name)"
                                    let paddingCount = (boxWidth - playlistTitle.count) / 2
                                    let playlistPadding = String(repeating: " ", count: paddingCount)
                                    print("│\(playlistPadding)\(playlistTitle)\(playlistPadding)│")
                                    print("├──────────────────────────────────────┤")
                                    if selectedPlaylist.songs.isEmpty {
                                        print("│    No songs found in this playlist.  │")
                                    } else {
                                        for song in selectedPlaylist.songs {
                                            let songLine = "│ \(song.title.padding(toLength: 32, withPad: " ", startingAt: 0))     │"
                                            print(songLine)
                                        }
                                    }
                                    print("└──────────────────────────────────────┘")
                                } else {
                                    print("Invalid playlist index.")
                                }
                            } else {
                                print("Invalid input for playlist index.")
                            }
                        case 7:
                            displayAllPlaylists()
                            print("Enter the number of the playlist from which you want to remove a song:")
                            if let playlistIndexStr = readLine(), let playlistIndex = Int(playlistIndexStr) {
                                if playlistIndex >= 0 && playlistIndex < playlists.count {
                                    let selectedPlaylist = playlists[playlistIndex]
                                    print("Playlist: \(selectedPlaylist.name)")
                                    if selectedPlaylist.songs.isEmpty {
                                        print("No songs found in this playlist.")
                                    } else {
                                        print("Songs:")
                                        for (index, song) in selectedPlaylist.songs.enumerated() {
                                            print("\(index). \(song.title)")
                                        }
                                        print("Enter the number of the song you want to remove from '\(selectedPlaylist.name)':")
                                        if let songIndexStr = readLine(), let songIndex = Int(songIndexStr) {
                                            if songIndex >= 0 && songIndex < selectedPlaylist.songs.count {
                                                let removedSong = selectedPlaylist.songs.remove(at: songIndex)
                                                print("Song '\(removedSong.title)' removed from '\(selectedPlaylist.name)' successfully!")
                                            } else {
                                                print("Invalid song index.")
                                            }
                                        } else {
                                            print("Invalid input for song index.")
                                        }
                                    }
                                } else {
                                    print("Invalid playlist index.")
                                }
                            } else {
                                print("Invalid input for playlist index.")
                            }
                            break

                        default:
                            print("Invalid choice")
                        }
                    }
                } while allPlaylistsChoice != 5
            case 3:
                print("Logged out successfully!")
                isLoggedIn = false
                main()
                isRunning = false
            case 4:
                print("Goodbye!")
                isRunning = false
            default:
                print("Invalid choice")
            }
        } else {
            print("Invalid input")
        }
    }
}

main()
