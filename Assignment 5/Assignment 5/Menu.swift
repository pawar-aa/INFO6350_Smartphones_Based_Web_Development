import Foundation

class Menu {
    func showMainMenu() {
        print("Welcome to the Music App!")
        print("1. Create Playlist")
        print("2. Show Playlists")
        print("3. All Songs")
        print("4. Favorite Songs")
        print("5. Exit")
        handleInput()
    }
    
    private func handleInput() {
        guard let choice = readLine(), let option = Int(choice) else {
            print("Invalid input. Please enter a number.")
            handleInput()
            return
        }
        
        switch option {
        case 1:
            Playlist.createPlaylist()
        case 2:
            Playlist.showPlaylists()
        case 3:
            Song.displayAllSongs()
        case 4:
            Playlist.showFavoriteSongs()
        case 5:
            exit(0)
        default:
            print("Invalid option. Please try again.")
        }
        
        showMainMenu()
    }
}
