import UIKit

protocol EditArtistDelegate: AnyObject {
    func artistNameUpdated(newName: String)
}

class EditArtistView: UIView {
    weak var delegate: EditArtistDelegate?
    
    private var artist: Artist?
    private var backButton: UIButton!
    private var updateButton: UIButton!
    private var artistNameTextField: UITextField!
    private var songListScrollView: UIScrollView!
    private var gradientLayer: CAGradientLayer!

    init(frame: CGRect, artist: Artist) {
        self.artist = artist
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
        titleLabel.text = "Edit Artist Name"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        addSubview(titleLabel)

        artistNameTextField = UITextField(frame: CGRect(x: 20, y: titleLabel.frame.maxY + 20, width: frame.width - 40, height: 40))
        artistNameTextField.borderStyle = .roundedRect
        artistNameTextField.placeholder = "Artist Name"
        artistNameTextField.text = artist?.name
        addSubview(artistNameTextField)

        songListScrollView = UIScrollView(frame: CGRect(x: 0, y: artistNameTextField.frame.maxY + 20, width: frame.width, height: frame.height - artistNameTextField.frame.maxY - 100))
        addSubview(songListScrollView)

        populateSongList()

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

    private func populateSongList() {
        guard let artist = artist else { return }

        var yOffset: CGFloat = 20
        for song in songs where song.artistID == artist.id {
            let songButton = createSongButton(song: song)
            songButton.frame = CGRect(x: 20, y: yOffset, width: frame.width - 40, height: 60)
            songListScrollView.addSubview(songButton)
            yOffset += 80
        }

        songListScrollView.contentSize = CGSize(width: frame.width, height: yOffset)
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

    @objc private func updateButtonTapped() {
        guard let newName = artistNameTextField.text,
              let artist = artist else { return }
        
        if let index = artists.firstIndex(where: { $0.id == artist.id }) {
            artists[index].name = newName
        }
        
        delegate?.artistNameUpdated(newName: newName)
        
        removeFromSuperview()
    }

    @objc private func backButtonTapped() {
        removeFromSuperview()
    }
    
    @objc private func deleteButtonTapped() {
        guard let artist = artist else { return }

        let artistSongs = songs.filter { $0.artistID == artist.id }
        if !artistSongs.isEmpty {
            let alert = UIAlertController(title: "Error", message: "Artist cannot be deleted as it has associated songs.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        } else {
            if let index = artists.firstIndex(where: { $0.id == artist.id }) {
                artists.remove(at: index)
            }
            delegate?.artistNameUpdated(newName: "")
            removeFromSuperview()
        }
    }

}
