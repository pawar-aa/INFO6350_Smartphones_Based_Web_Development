import UIKit

class ShowAllSongsView: UIView, UISearchBarDelegate {

    private var backButton: UIButton!
    private var songListScrollView: UIScrollView!
    private var gradientLayer: CAGradientLayer!
    private var addButton: UIButton!
    private var searchBar: UISearchBar!

    override init(frame: CGRect) {
        super.init(frame: frame)

        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.systemGreen.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)

        let titleLabel = UILabel(frame: CGRect(x: 20, y: 40, width: frame.width - 40, height: 30))
        titleLabel.text = "All Songs"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        addSubview(titleLabel)

        // Add search bar
        searchBar = UISearchBar(frame: CGRect(x: 20, y: titleLabel.frame.maxY + 10, width: frame.width - 40, height: 40))
        searchBar.delegate = self
        addSubview(searchBar)

        songListScrollView = UIScrollView(frame: CGRect(x: 0, y: searchBar.frame.maxY + 10, width: frame.width, height: frame.height - 200))
        addSubview(songListScrollView)
        
        // Load all songs initially
        reloadData()
        
        let gap: CGFloat = -10
        let buttonWidth: CGFloat = 150
        let buttonHeight: CGFloat = 50
        let buttonSpacing: CGFloat = 20

        let totalButtonWidth = buttonWidth * 2 + buttonSpacing

        backButton = createButton(title: "Back", action: #selector(backButtonTapped))
        backButton.frame = CGRect(x: (frame.width - totalButtonWidth) / 2, y: songListScrollView.frame.maxY + gap, width: buttonWidth, height: buttonHeight)
        addSubview(backButton)

        addButton = createButton(title: "Add New", action: #selector(addNewSongButtonTapped))
        addButton.frame = CGRect(x: backButton.frame.maxX + buttonSpacing, y: backButton.frame.origin.y, width: buttonWidth, height: buttonHeight)
        addSubview(addButton)


    }

    // Implement UISearchBarDelegate method for search functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // If search text is empty, reload all songs
            reloadData()
        } else {
            // Filter songs based on search text
            let filteredSongs = songs.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            displayFilteredSongs(filteredSongs)
        }
    }
    
    // Display filtered songs
    private func displayFilteredSongs(_ filteredSongs: [Song]) {
        songListScrollView.subviews.forEach { $0.removeFromSuperview() }
        
        var yOffset: CGFloat = 20
        for song in filteredSongs {
            let songButton = createSongButton(song: song)
            songButton.frame = CGRect(x: 20, y: yOffset, width: frame.width - 40, height: 60)
            songListScrollView.addSubview(songButton)
            yOffset += 80
        }
        
        let contentHeight = yOffset + 20
        songListScrollView.contentSize = CGSize(width: frame.width, height: contentHeight)
    }

    @objc private func addNewSongButtonTapped() {
        let addSongView = AddSongView(frame: UIScreen.main.bounds)
        addSongView.onAddSong = { [weak self] newSong in
            songs.append(newSong)
            self?.reloadData()
        }
        UIApplication.shared.keyWindow?.addSubview(addSongView)
    }

    private func createSongButton(song: Song) -> UIButton {
        let button = UIButton(type: .system)
        let artistName = artists.first(where: { $0.id == song.artistID })?.name ?? "Unknown Artist"
        let buttonText = "\(song.title) - \(artistName)"
        button.setTitle(buttonText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(songButtonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        let buttonWidth = button.frame.width
        let buttonHeight = button.frame.height
        
        let durationLabel = UILabel(frame: CGRect(x: buttonWidth - 100, y: 0, width: 90, height: buttonHeight))
        durationLabel.text = "\(song.duration) sec"
        durationLabel.font = UIFont.systemFont(ofSize: 12)
        durationLabel.textColor = .lightGray
        durationLabel.textAlignment = .right
        button.addSubview(durationLabel)
        
        button.tag = song.id
        
        return button
    }
    
    @objc private func backButtonTapped() {
        removeFromSuperview()
    }

    @objc private func songButtonTapped(_ sender: UIButton) {
        if let selectedSong = songs.first(where: { $0.id == sender.tag }) {
            let showSongDetailsView = ShowSongDetails(frame: UIScreen.main.bounds)
            showSongDetailsView.showDetails(for: selectedSong)
            showSongDetailsView.onDelete = { [weak self] in
                self?.reloadData()
            }
            UIApplication.shared.keyWindow?.addSubview(showSongDetailsView)
        }
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    func reloadData() {
        // Reload all songs
        displayFilteredSongs(songs)
    }
}
