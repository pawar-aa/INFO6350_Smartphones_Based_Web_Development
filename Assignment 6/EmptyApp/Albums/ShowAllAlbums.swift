import UIKit

class ShowAllAlbumsView: UIView, EditAlbumDelegate, UISearchBarDelegate {
    private var backButton: UIButton!
    private var addButton: UIButton!
    private var albumListScrollView: UIScrollView!
    private var gradientLayer: CAGradientLayer!
    private var searchBar: UISearchBar!
    private var filteredAlbums = [Album]()

    func updateAlbumButtons() {
        albumListScrollView.subviews.forEach { $0.removeFromSuperview() }
        let albumsToDisplay = searchBar.text?.isEmpty ?? true ? albums : filteredAlbums
        var contentHeight: CGFloat = 20
        for _ in albumsToDisplay {
            let buttonHeight: CGFloat = 60
            contentHeight += buttonHeight + 20
        }
        albumListScrollView.contentSize = CGSize(width: frame.width, height: contentHeight)
        var yOffset: CGFloat = 20
        for album in albumsToDisplay {
            let albumButton = createAlbumButton(album: album)
            albumButton.frame = CGRect(x: 20, y: yOffset, width: frame.width - 40, height: 60)
            albumListScrollView.addSubview(albumButton)
            yOffset += 80
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.systemGreen.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 40, width: frame.width - 40, height: 30))
        titleLabel.text = "All Albums"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        addSubview(titleLabel)
        
        searchBar = UISearchBar(frame: CGRect(x: 20, y: 80, width: frame.width - 40, height: 50))
        searchBar.delegate = self
        addSubview(searchBar)
        
        albumListScrollView = UIScrollView(frame: CGRect(x: 0, y: 140, width: frame.width, height: frame.height - 240))
        addSubview(albumListScrollView)
        updateAlbumButtons()
        
        let _: CGFloat = 20
        let buttonWidth: CGFloat = 150
        let buttonHeight: CGFloat = 50
        let buttonSpacing: CGFloat = 20

        backButton = createButton(title: "Back", action: #selector(backButtonTapped))
        backButton.frame = CGRect(x: (frame.width - buttonWidth * 2 - buttonSpacing) / 2, y: albumListScrollView.frame.maxY + 20, width: buttonWidth, height: buttonHeight)
        addSubview(backButton)

        addButton = createButton(title: "Add New", action: #selector(addNewButtonTapped))
        addButton.frame = CGRect(x: backButton.frame.maxX + buttonSpacing, y: backButton.frame.origin.y, width: buttonWidth, height: buttonHeight)
        addSubview(addButton)

    }

    @objc private func addNewButtonTapped() {
        let addAlbumView = AddAlbumView(frame: UIScreen.main.bounds)
        addAlbumView.onAddButtonTapped = { [weak self] albumName, releaseDate, artistName in
            let newAlbumID = (albums.last?.id ?? 0) + 1
            let newAlbum = Album(id: newAlbumID, artistID: -1, title: albumName, releaseDate: releaseDate)
            albums.append(newAlbum)
            print("New artist name:", artistName)
            self?.updateAlbumButtons()
            addAlbumView.removeFromSuperview()
        }
        UIApplication.shared.keyWindow?.addSubview(addAlbumView)
    }


    private func createAlbumButton(album: Album) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(album.title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(albumButtonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tag = album.id
        return button
    }

    @objc private func backButtonTapped() {
        removeFromSuperview()
    }

    func albumNameUpdated(newName: String) {
        updateAlbumButtons()
    }

    @objc private func albumButtonTapped(_ sender: UIButton) {
        if let selectedAlbum = albums.first(where: { $0.id == sender.tag }) {
            let editAlbumView = EditAlbumView(frame: UIScreen.main.bounds, album: selectedAlbum)
            editAlbumView.delegate = self
            UIApplication.shared.keyWindow?.addSubview(editAlbumView)
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredAlbums = albums.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        updateAlbumButtons()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
