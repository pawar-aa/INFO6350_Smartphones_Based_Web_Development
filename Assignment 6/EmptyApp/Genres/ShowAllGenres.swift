import UIKit

protocol ShowSongsByGenreViewDelegate: AnyObject {
    func genreNameUpdated(newName: String, forGenreID genreID: Int)
}

class ShowAllGenresView: UIView, UISearchBarDelegate, ShowSongsByGenreViewDelegate {
    private var backButton: UIButton!
    private var addButton: UIButton!
    private var genreListScrollView: UIScrollView!
    private var gradientLayer: CAGradientLayer!
    private var searchBar: UISearchBar!
    var filteredGenres: [Genre] = []

    init(frame: CGRect, genres: [Genre]) {
        super.init(frame: frame)

        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.systemGreen.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)

        let titleLabel = UILabel(frame: CGRect(x: 20, y: 40, width: frame.width - 40, height: 30))
        titleLabel.text = "All Genres"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        addSubview(titleLabel)

        searchBar = UISearchBar(frame: CGRect(x: 20, y: 80, width: frame.width - 40, height: 50))
        searchBar.delegate = self
        addSubview(searchBar)

        genreListScrollView = UIScrollView(frame: CGRect(x: 0, y: 140, width: frame.width, height: frame.height - 240))
        addSubview(genreListScrollView)

        filteredGenres = genres
        updateGenreButtons()

        let buttonWidth: CGFloat = 150
        let buttonHeight: CGFloat = 50
        let buttonSpacing: CGFloat = 20

        backButton = createButton(title: "Back", action: #selector(backButtonTapped))
        backButton.frame = CGRect(x: (frame.width - buttonWidth * 2 - buttonSpacing) / 2, y: genreListScrollView.frame.maxY + 20, width: buttonWidth, height: buttonHeight)
        addSubview(backButton)

        addButton = createButton(title: "Add New", action: #selector(addNewButtonTapped))
        addButton.frame = CGRect(x: backButton.frame.maxX + buttonSpacing, y: backButton.frame.origin.y, width: buttonWidth, height: buttonHeight)
        addSubview(addButton)
    }

    func updateGenreButtons() {
        genreListScrollView.subviews.forEach { $0.removeFromSuperview() }
        var contentHeight: CGFloat = 20
        for _ in filteredGenres {
            let buttonHeight: CGFloat = 60
            contentHeight += buttonHeight + 20
        }
        genreListScrollView.contentSize = CGSize(width: frame.width, height: contentHeight)
        var yOffset: CGFloat = 20
        for genre in filteredGenres {
            let genreButton = createGenreButton(genre: genre)
            genreButton.frame = CGRect(x: 20, y: yOffset, width: frame.width - 40, height: 60)
            genreListScrollView.addSubview(genreButton)
            yOffset += 80
        }
    }

    @objc private func addNewButtonTapped() {
        let addGenreView = AddGenre(frame: UIScreen.main.bounds)
        addGenreView.onAddGenre = { [weak self] genreName in
            let maxID = genres.map { $0.id }.max() ?? 0
            let newGenre = Genre(id: maxID + 1, name: genreName)
            genres.append(newGenre)
            self?.filteredGenres = genres
            self?.updateGenreButtons()
            addGenreView.removeFromSuperview()
        }
        UIApplication.shared.keyWindow?.addSubview(addGenreView)
    }

    private func createGenreButton(genre: Genre) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(genre.name, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tag = genre.id
        button.addTarget(self, action: #selector(genreButtonTapped(_:)), for: .touchUpInside)
        return button
    }

    @objc private func backButtonTapped() {
        removeFromSuperview()
    }

    @objc private func genreButtonTapped(_ sender: UIButton) {
        if let selectedGenre = filteredGenres.first(where: { $0.id == sender.tag }) {
            let filteredSongs = songs.filter { $0.genreID == selectedGenre.id }
            let showSongsByGenreView = ShowSongsByGenreView(frame: UIScreen.main.bounds, genre: selectedGenre, songs: filteredSongs)
            showSongsByGenreView.delegate = self // Set the delegate
            UIApplication.shared.keyWindow?.addSubview(showSongsByGenreView)
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

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredGenres = searchText.isEmpty ? genres : genres.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        updateGenreButtons()
    }
    
    func genreNameUpdated(newName: String, forGenreID genreID: Int) {
            // Update UI to reflect the updated genre name
            if let index = filteredGenres.firstIndex(where: { $0.id == genreID }) {
                filteredGenres[index].name = newName
                updateGenreButtons()
            }
        }
}
