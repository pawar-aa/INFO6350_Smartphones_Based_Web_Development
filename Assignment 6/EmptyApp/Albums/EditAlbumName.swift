import UIKit

protocol EditAlbumDelegate: AnyObject {
    func albumNameUpdated(newName: String)
}

class EditAlbumView: UIView {
    weak var delegate: EditAlbumDelegate?
    
    private var album: Album?
    private var backButton: UIButton!
    private var updateButton: UIButton!
    private var deleteButton: UIButton!
    private var albumNameTextField: UITextField!
    private var releaseDateTextField: UITextField!
    private var songListScrollView: UIScrollView!
    private var gradientLayer: CAGradientLayer!

    init(frame: CGRect, album: Album) {
        self.album = album
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
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)

        let titleLabel = UILabel(frame: CGRect(x: 20, y: 40, width: frame.width - 40, height: 30))
        titleLabel.text = "Edit Album Name"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        addSubview(titleLabel)

        albumNameTextField = UITextField(frame: CGRect(x: 20, y: titleLabel.frame.maxY + 20, width: frame.width - 40, height: 40))
        albumNameTextField.borderStyle = .roundedRect
        albumNameTextField.placeholder = "Album Name"
        albumNameTextField.text = album?.title
        addSubview(albumNameTextField)
        
        // Create and configure release date text field
        releaseDateTextField = UITextField(frame: CGRect(x: 20, y: albumNameTextField.frame.maxY + 20, width: frame.width - 40, height: 40))
        releaseDateTextField.borderStyle = .roundedRect
        releaseDateTextField.placeholder = "Release Date"
        releaseDateTextField.text = album?.releaseDate
        addSubview(releaseDateTextField)

        let scrollView = UIScrollView(frame: CGRect(x: 0, y: releaseDateTextField.frame.maxY + 20, width: frame.width, height: frame.height - releaseDateTextField.frame.maxY - 100))
        scrollView.contentSize = CGSize(width: frame.width, height: 1000)
        addSubview(scrollView)

        songListScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 1000))
        scrollView.addSubview(songListScrollView)

        let buttonWidth = (frame.width - 80) / 3
        let buttonHeight: CGFloat = 50
        let gap: CGFloat = 20
        let bottomGap: CGFloat = 30

        updateButton = createButton(title: "Update", action: #selector(updateButtonTapped))
        updateButton.frame = CGRect(x: 20, y: frame.maxY - bottomGap - buttonHeight, width: buttonWidth, height: buttonHeight)
        addSubview(updateButton)

        let deleteButton = createButton(title: "Delete", action: #selector(deleteButtonTapped))
        deleteButton.frame = CGRect(x: updateButton.frame.maxX + gap, y: frame.maxY - bottomGap - buttonHeight, width: buttonWidth, height: buttonHeight)
        addSubview(deleteButton)

        backButton = createButton(title: "Back", action: #selector(backButtonTapped))
        backButton.frame = CGRect(x: deleteButton.frame.maxX + gap, y: frame.maxY - bottomGap - buttonHeight, width: buttonWidth, height: buttonHeight)
        addSubview(backButton)

        populateSongList()
    }

    private func populateSongList() {
        guard let album = album else { return }

        var yOffset: CGFloat = 20
        for song in songs where song.albumID == album.id {
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
        guard let newName = albumNameTextField.text,
              let newReleaseDate = releaseDateTextField.text,
              let album = album else { return }
        
        if let index = albums.firstIndex(where: { $0.id == album.id }) {
            albums[index].title = newName
            albums[index].releaseDate = newReleaseDate
        }
        
        delegate?.albumNameUpdated(newName: newName)
        
        removeFromSuperview()
    }

    @objc private func backButtonTapped() {
        removeFromSuperview()
    }
    
    @objc private func deleteButtonTapped() {
        guard let album = album else { return }

        let albumSongs = songs.filter { $0.albumID == album.id }
        if !albumSongs.isEmpty {
            let alert = UIAlertController(title: "Error", message: "Album cannot be deleted as it has associated songs.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        } else {
            if let index = albums.firstIndex(where: { $0.id == album.id }) {
                albums.remove(at: index)
            }
            delegate?.albumNameUpdated(newName: "")
            removeFromSuperview()
        }
    }

}
