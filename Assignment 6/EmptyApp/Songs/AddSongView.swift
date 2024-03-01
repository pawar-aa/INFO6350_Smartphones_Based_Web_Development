import UIKit

class AddSongView: UIView {
    private let titleLabel = UITextField()
    private let artistTextField = UITextField()
    private let albumTextField = UITextField()
    private let durationTextField = UITextField()
    private let addButton = UIButton(type: .system)
    private let backButton = UIButton(type: .system)
    private let titleLabelView = UILabel()
    private let genreTextField = UITextField()
    private let favoriteSwitch = UISwitch()
    var onAddSong: ((Song) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.systemGreen.cgColor
        ]
        layer.insertSublayer(gradientLayer, at: 0)

        titleLabelView.text = "Add New Song"
        titleLabelView.textColor = .white
        titleLabelView.textAlignment = .center
        titleLabelView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabelView)

        titleLabel.placeholder = "Title"
        titleLabel.textColor = .black
        titleLabel.borderStyle = .roundedRect
        titleLabel.backgroundColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        artistTextField.placeholder = "Artist"
        artistTextField.borderStyle = .roundedRect
        artistTextField.backgroundColor = .white
        artistTextField.textColor = .black
        artistTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(artistTextField)

        albumTextField.placeholder = "Album"
        albumTextField.borderStyle = .roundedRect
        albumTextField.backgroundColor = .white
        albumTextField.textColor = .black
        albumTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(albumTextField)

        genreTextField.placeholder = "Genre"
        genreTextField.borderStyle = .roundedRect
        genreTextField.backgroundColor = .white
        genreTextField.textColor = .black
        genreTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(genreTextField)

        durationTextField.placeholder = "Duration (seconds)"
        durationTextField.borderStyle = .roundedRect
        durationTextField.keyboardType = .decimalPad
        durationTextField.backgroundColor = .white
        durationTextField.textColor = .black
        durationTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(durationTextField)

        favoriteSwitch.isOn = false
        favoriteSwitch.translatesAutoresizingMaskIntoConstraints = false
        addSubview(favoriteSwitch)

        addButton.setTitle("Add", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.backgroundColor = .black
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 5
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addButton)

        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.backgroundColor = .black
        backButton.setTitleColor(.white, for: .normal)
        backButton.layer.cornerRadius = 5
        backButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backButton)

        titleLabelView.frame = CGRect(x: 20, y: 40, width: frame.width - 40, height: 30)
        titleLabel.frame = CGRect(x: 20, y: titleLabelView.frame.maxY + 60, width: frame.width - 40, height: 40)
        artistTextField.frame = CGRect(x: 20, y: titleLabel.frame.maxY + 20, width: frame.width - 40, height: 40)
        albumTextField.frame = CGRect(x: 20, y: artistTextField.frame.maxY + 20, width: frame.width - 40, height: 40)
        genreTextField.frame = CGRect(x: 20, y: albumTextField.frame.maxY + 20, width: frame.width - 40, height: 40)
        durationTextField.frame = CGRect(x: 20, y: genreTextField.frame.maxY + 20, width: frame.width - 40, height: 40)
        favoriteSwitch.frame = CGRect(x: 20, y: durationTextField.frame.maxY + 20, width: 50, height: 30)
        addButton.frame = CGRect(x: (frame.width - 200) / 2, y: favoriteSwitch.frame.maxY + 20, width: 200, height: 50)
        backButton.frame = CGRect(x: (frame.width - 200) / 2, y: addButton.frame.maxY + 20, width: 200, height: 50)
    }

    @objc private func addButtonTapped() {
        guard let title = titleLabel.text,
              let artistName = artistTextField.text,
              let albumTitle = albumTextField.text,
              let durationString = durationTextField.text,
              let genre = genreTextField.text,
              let duration = Double(durationString) else {
            print("Error 1")
            return
        }

        guard let artistID = getOrAddArtistID(artistName: artistName) else {
            print("Error 2")
            return
        }

        guard let albumID = getOrAddAlbumID(albumTitle: albumTitle, artistID: artistID) else {
            print("Error 3")
            return
        }
        
        guard let genreID = getOrAddGenreID(genreName: genre) else {
                print("Error: Unable to get or add genre ID")
                return
            }
        
        let newSongID = (songs.map { $0.id }.max() ?? 0) + 1

        let newSong = Song(id: newSongID, artistID: artistID, albumID: albumID, genreID: genreID, title: title, duration: duration, favorite: favoriteSwitch.isOn)

        onAddSong?(newSong)
        removeFromSuperview()
    }

    @objc private func backButtonTapped() {
        removeFromSuperview()
    }

    private func getOrAddArtistID(artistName: String) -> Int? {
        if let existingArtist = artists.first(where: { $0.name == artistName }) {
            return existingArtist.id
        } else {
            let newArtistID = (artists.map { $0.id }.max() ?? 0) + 1
            let newArtist = Artist(id: newArtistID, name: artistName)
            artists.append(newArtist)
            return newArtistID
        }
    }

    private func getOrAddAlbumID(albumTitle: String, artistID: Int) -> Int? {
        if let existingAlbum = albums.first(where: { $0.title == albumTitle}) {
            return existingAlbum.id
        } else {
            let newAlbumID = (albums.map { $0.id }.max() ?? 0) + 1
            let newAlbum = Album(id: newAlbumID, artistID: artistID, title: albumTitle, releaseDate: "")
            albums.append(newAlbum)
            return newAlbumID
        }
    }

    private func getOrAddGenreID(genreName: String) -> Int? {
        if let existingGenre = genres.first(where: { $0.name == genreName }) {
            return existingGenre.id
        } else {
            let newGenreID = (genres.map { $0.id }.max() ?? 0) + 1
            let newGenre = Genre(id: newGenreID, name: genreName)
            genres.append(newGenre)
            return newGenreID
        }
    }
}
