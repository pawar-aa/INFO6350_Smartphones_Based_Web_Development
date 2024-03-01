import UIKit

class ShowAllArtistsView: UIView, EditArtistDelegate, UISearchBarDelegate {
    private var backButton: UIButton!
    private var artistListScrollView: UIScrollView!
    private var gradientLayer: CAGradientLayer!
    private var addNewButton: UIButton!
    private var searchBar: UISearchBar!
    
    private var filteredArtists: [Artist] = []

    override init(frame: CGRect) {
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
        titleLabel.text = "All Artists"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        addSubview(titleLabel)

        searchBar = UISearchBar(frame: CGRect(x: 20, y: titleLabel.frame.maxY + 10, width: frame.width - 40, height: 40))
        searchBar.delegate = self
        addSubview(searchBar)

        artistListScrollView = UIScrollView(frame: CGRect(x: 0, y: searchBar.frame.maxY + 10, width: frame.width, height: frame.height - 200))
        addSubview(artistListScrollView)

        updateArtistButtons()

        let buttonGap: CGFloat = 20
        let bottomGap: CGFloat = -40
        let buttonWidth: CGFloat = 150
        let buttonHeight: CGFloat = 50

        backButton = createButton(title: "Back", action: #selector(backButtonTapped))
        backButton.frame = CGRect(x: (frame.width - buttonWidth * 2 - buttonGap) / 2, y: artistListScrollView.frame.maxY + buttonGap, width: buttonWidth, height: buttonHeight)
        addSubview(backButton)

        addNewButton = createButton(title: "Add New", action: #selector(addNewButtonTapped))
        addNewButton.frame = CGRect(x: backButton.frame.maxX + buttonGap, y: backButton.frame.origin.y, width: buttonWidth, height: buttonHeight)
        addSubview(addNewButton)

        // Adjust the frame of the addNewButton to include the bottom gap
        addNewButton.frame.origin.y += bottomGap
        backButton.frame.origin.y += bottomGap

    }

    @objc private func addNewButtonTapped() {
        // Navigate to the view for adding a new artist
        let addArtistView = AddArtistView(frame: UIScreen.main.bounds)
        addArtistView.delegate = self // Set delegate to handle new artist addition
        UIApplication.shared.keyWindow?.addSubview(addArtistView)
    }

    func updateArtistButtons() {
        artistListScrollView.subviews.forEach { $0.removeFromSuperview() }

        let artistsToShow = searchBar.text?.isEmpty ?? true ? artists : filteredArtists

        var contentHeight: CGFloat = 20
        for _ in artistsToShow {
            let buttonHeight: CGFloat = 60
            contentHeight += buttonHeight + 20
        }
        artistListScrollView.contentSize = CGSize(width: frame.width, height: contentHeight)

        var yOffset: CGFloat = 20
        for artist in artistsToShow {
            let artistButton = createArtistButton(artist: artist)
            artistButton.frame = CGRect(x: 20, y: yOffset, width: frame.width - 40, height: 60)
            artistListScrollView.addSubview(artistButton)
            yOffset += 80
        }
    }

    private func createArtistButton(artist: Artist) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(artist.name, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(artistButtonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tag = artist.id
        return button
    }

    @objc private func artistButtonTapped(_ sender: UIButton) {
        if let selectedArtist = artists.first(where: { $0.id == sender.tag }) {
            let editArtistView = EditArtistView(frame: UIScreen.main.bounds, artist: selectedArtist)
            editArtistView.delegate = self
            UIApplication.shared.keyWindow?.addSubview(editArtistView)
        }
    }

    func artistNameUpdated(newName: String) {
        updateArtistButtons()
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

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArtists = artists.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        updateArtistButtons()
    }
}

extension ShowAllArtistsView: AddArtistDelegate {
    func artistAdded(_ newArtist: Artist) {
        artists.append(newArtist)
        updateArtistButtons()
    }
}
