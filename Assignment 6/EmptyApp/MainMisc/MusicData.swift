import Foundation

struct Artist {
    var id: Int
    var name: String
}

struct Album {
    var id: Int
    var artistID: Int
    var title: String
    var releaseDate: String
}

struct Song {
    var id: Int
    var artistID: Int
    var albumID: Int
    var genreID: Int
    var title: String
    var duration: Double
    var favorite: Bool
}

struct Genre {
    var id: Int
    var name: String
}

var songs: [Song] = [Song(id: 1, artistID: 1, albumID: 1, genreID: 1, title: "Tum Mile", duration: 123, favorite: true),
                     Song(id: 2, artistID: 2, albumID: 1, genreID: 1, title: "Tu Hi Haqeqaat", duration: 789, favorite: false),
                     Song(id: 3, artistID: 3, albumID: 1, genreID: 2, title: "Dil Ibadaat", duration: 456, favorite: false)]

var artists: [Artist] = [Artist(id: 1, name: "Neeraj Shreedhar"),
                         Artist(id: 2, name: "Javed Ali"),
                         Artist(id: 3, name: "KK")]

var albums: [Album] = [Album(id: 1, artistID: 1, title: "Tum Mile", releaseDate: "2009-11-12")]

var genres: [Genre] = [Genre(id: 1, name: "Romantic"),
                       Genre(id: 2, name: "Sad")]
