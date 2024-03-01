import UIKit

class ShowSongsByGenreView: UIView {
    private var backButton: UIButton!
    private var updateButton: UIButton!
    private var deleteButton: UIButton!
    private var genreTitleTextField: UITextField!
    private var songListScrollView: UIScrollView!
    private var gradientLayer: CAGradientLayer!
    private var genre: Genre
    private var songs: [Song]
    weak var delegate: ShowSongsByGenreViewDelegate?

    init(frame: CGRect, genre: Genre, songs: [Song]) {
        self.genre = genre
        self.songs = songs.filter { $0.genreID == genre.id }
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.systemGreen.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)

        let titleLabel = UILabel(frame: CGRect(x: 20, y: 40, width: frame.width - 40, height: 30))
        titleLabel.text = "Songs in \(genre.name) Genre"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        addSubview(titleLabel)

        genreTitleTextField = UITextField(frame: CGRect(x: 20, y: titleLabel.frame.maxY + 20, width: frame.width - 40, height: 40))
        genreTitleTextField.borderStyle = .roundedRect
        genreTitleTextField.placeholder = "Genre Title"
        genreTitleTextField.text = genre.name
        addSubview(genreTitleTextField)

        songListScrollView = UIScrollView(frame: CGRect(x: 0, y: genreTitleTextField.frame.maxY + 20, width: frame.width, height: frame.height - 300))
        addSubview(songListScrollView)

        var yOffset: CGFloat = 20
        for song in songs {
            let songButton = createSongButton(song: song)
            songButton.frame = CGRect(x: 20, y: yOffset, width: frame.width - 40, height: 60)
            songListScrollView.addSubview(songButton)
            yOffset += 80
        }

        let buttonWidth = (frame.width - 80) / 3
        let buttonHeight: CGFloat = 50
        let gap: CGFloat = 20
        let bottomGap: CGFloat = 30

        updateButton = createButton(title: "Update", action: #selector(updateButtonTapped))
        updateButton.frame = CGRect(x: 20, y: frame.height - buttonHeight - bottomGap, width: buttonWidth, height: buttonHeight)
        addSubview(updateButton)

        let deleteButton = createButton(title: "Delete", action: #selector(deleteButtonTapped))
        deleteButton.frame = CGRect(x: updateButton.frame.maxX + gap, y: frame.height - buttonHeight - bottomGap, width: buttonWidth, height: buttonHeight)
        addSubview(deleteButton)

        backButton = createButton(title: "Back", action: #selector(backButtonTapped))
        backButton.frame = CGRect(x: deleteButton.frame.maxX + gap, y: frame.height - buttonHeight - bottomGap, width: buttonWidth, height: buttonHeight)
        addSubview(backButton)
    }

    private func createSongButton(song: Song) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(song.title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tag = song.id
        button.addTarget(self, action: #selector(songButtonTapped(_:)), for: .touchUpInside)
        return button
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

    @objc private func backButtonTapped() {
        removeFromSuperview()
    }

    @objc private func updateButtonTapped() {
            guard let newGenreName = genreTitleTextField.text else { return }
            // Update genre title in the list of genres
            if let index = genres.firstIndex(where: { $0.id == genre.id }) {
                genres[index].name = newGenreName
                // Notify the delegate
                delegate?.genreNameUpdated(newName: newGenreName, forGenreID: genre.id)
            }
            // Optionally, you might want to update the genre title displayed on the screen
            genre.name = newGenreName
            
            removeFromSuperview()
        }


    @objc private func deleteButtonTapped() {
        // Check if the genre has associated songs
        let hasAssociatedSongs = songs.contains(where: { $0.genreID == genre.id })
        if hasAssociatedSongs {
            // Show alert that genre cannot be deleted
            let alert = UIAlertController(title: "Error", message: "Genre cannot be deleted as it has associated songs.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                rootViewController.present(alert, animated: true, completion: nil)
            }
        } else {
            // Remove the genre from the list of genres
            if let index = genres.firstIndex(where: { $0.id == genre.id }) {
                genres.remove(at: index)
            }
            // Remove the view from the superview
            removeFromSuperview()
        }
    }

    @objc private func songButtonTapped(_ sender: UIButton) {
        // Handle song selection (e.g., play the song)
        if let selectedSong = songs.first(where: { $0.id == sender.tag }) {
            print("Selected song: \(selectedSong.title)")
            // Implement your logic here for playing the selected song
        }
    }
}
