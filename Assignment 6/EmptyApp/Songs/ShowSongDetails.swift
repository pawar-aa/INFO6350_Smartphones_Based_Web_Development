import UIKit

class ShowSongDetails: UIView {
    private var song: Song?
    let titleLabel = UITextField()
    let artistLabel = UITextField()
    let albumLabel = UITextField()
    let durationLabel = UITextField()
    private var backButton: UIButton!
    private var deleteButton: UIButton!
    var onDelete: (() -> Void)?
    var onUpdate: (() -> Void)?
    private var gradientLayer: CAGradientLayer!
    private var favoriteSwitch: UISwitch!
    private var isFavCond: Bool?
    private var updateButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.systemGreen.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
        
        let title = UILabel(frame: CGRect(x: 20, y: 40, width: frame.width - 40, height: 30))
        title.text = "Song Details"
        title.textAlignment = .center
        title.textColor = .white
        addSubview(title)
        
        titleLabel.frame = CGRect(x: 20, y: title.frame.maxY + 60, width: frame.width - 40, height: 40)
        titleLabel.textAlignment = .left
        titleLabel.borderStyle = .roundedRect
        titleLabel.textColor = .black
        titleLabel.backgroundColor = .white
        titleLabel.layer.cornerRadius = 5
        titleLabel.clipsToBounds = true
        addSubview(titleLabel)
        
        artistLabel.frame = CGRect(x: 20, y: titleLabel.frame.maxY + 20, width: frame.width - 40, height: 40)
        artistLabel.textAlignment = .left
        artistLabel.borderStyle = .roundedRect
        artistLabel.textColor = .black
        artistLabel.backgroundColor = .gray
        artistLabel.isUserInteractionEnabled = false
        artistLabel.layer.cornerRadius = 5
        artistLabel.clipsToBounds = true
        addSubview(artistLabel)
        
        albumLabel.frame = CGRect(x: 20, y: artistLabel.frame.maxY + 20, width: frame.width - 40, height: 40)
        albumLabel.textAlignment = .left
        albumLabel.borderStyle = .roundedRect
        albumLabel.isUserInteractionEnabled = false
        albumLabel.textColor = .black
        albumLabel.backgroundColor = .gray
        albumLabel.layer.cornerRadius = 5
        albumLabel.clipsToBounds = true
        addSubview(albumLabel)
        
        durationLabel.frame = CGRect(x: 20, y: albumLabel.frame.maxY + 20, width: frame.width - 40, height: 40)
        durationLabel.textAlignment = .left
        durationLabel.textColor = .black
        durationLabel.backgroundColor = .white
        durationLabel.layer.cornerRadius = 5
        durationLabel.clipsToBounds = true
        addSubview(durationLabel)
        
        favoriteSwitch = UISwitch()
        favoriteSwitch.frame = CGRect(x: 20, y: durationLabel.frame.maxY + 20, width: 50, height: 30)
        addSubview(favoriteSwitch)
        favoriteSwitch.addTarget(self, action: #selector(favoriteSwitchValueChanged(_:)), for: .valueChanged)
        
        let gap: CGFloat = 20
        
        backButton = createButton(title: "Back", action: #selector(backButtonTapped))
        backButton.frame = CGRect(x: (frame.width - 200) / 2, y: favoriteSwitch.frame.maxY + gap, width: 200, height: 50)
        addSubview(backButton)
        
        deleteButton = createButton(title: "Delete", action: #selector(deleteButtonTapped))
        deleteButton.backgroundColor = .red
        deleteButton.frame = CGRect(x: (frame.width - 200) / 2, y: backButton.frame.maxY + gap, width: 200, height: 50)
        addSubview(deleteButton)
        
        updateButton = createButton(title: "Update", action: #selector(updateButtonTapped))
        updateButton.frame = CGRect(x: (frame.width - 200) / 2, y: deleteButton.frame.maxY + gap, width: 200, height: 50)
        addSubview(updateButton)
    }
    
    @objc private func deleteButtonTapped() {
        guard let song = song else { return }

        songs.removeAll { $0.id == song.id }

        onDelete?()
        
        print("Delete song with ID: \(song.id)")
        removeFromSuperview()
    }
    
    @objc private func updateButtonTapped() {
        guard var song = song else { return }
        
        if let title = titleLabel.text {
            song.title = title
        }
        
        if let artistName = artistLabel.text {
            if let artist = artists.first(where: { $0.name == artistName }) {
                song.artistID = artist.id
            } else {
                let newArtistID = artists.count + 1
                let newArtist = Artist(id: newArtistID, name: artistName)
                artists.append(newArtist)
                song.artistID = newArtistID
            }
        }
        
        if let albumTitle = albumLabel.text {
            if let album = albums.first(where: { $0.title == albumTitle }) {
                song.albumID = album.id
            } else {
                let newAlbumID = albums.count + 1
                let newAlbum = Album(id: newAlbumID, artistID: song.artistID, title: albumTitle, releaseDate: "")
                albums.append(newAlbum)
                song.albumID = newAlbumID
            }
        }
        
        if let durationStr = durationLabel.text, let duration = Double(durationStr) {
            song.duration = duration
        }
        
        song.favorite = favoriteSwitch.isOn
        
        if let index = songs.firstIndex(where: { $0.id == song.id }) {
            songs[index] = song
        }
        
        onDelete?()
        removeFromSuperview()
    }

    @objc private func backButtonTapped() {
        removeFromSuperview()
    }
    
    @objc private func favoriteSwitchValueChanged(_ sender: UISwitch) {
        isFavCond = sender.isOn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showDetails(for song: Song) {
        self.song = song
        titleLabel.text = "\(song.title)"
        
        if let artist = artists.first(where: { $0.id == song.artistID }) {
            artistLabel.text = "\(artist.name)"
        } else {
            artistLabel.text = "Artist: Unknown"
        }
        
        if let album = albums.first(where: { $0.id == song.albumID }) {
            albumLabel.text = "\(album.title)"
        } else {
            albumLabel.text = "Album: Unknown"
        }
        
        durationLabel.text = "\(song.duration)"
        
        isFavCond = song.favorite
        
        favoriteSwitch.setOn(isFavCond ?? false, animated: true)
    }
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        
        return button
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
