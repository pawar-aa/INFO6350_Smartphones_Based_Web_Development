import Foundation
import UIKit
class MainWindow: UIWindow {

    var mainView: UIView!
    private var btnSongs: UIButton!
    private var btnArtists: UIButton!
    private var btnAlbums: UIButton!
    private var btnGenres: UIButton!
    private var viewButton: UIButton!
    private var updateButton: UIButton!
    private var deleteButton: UIButton!
    private var textView: UITextView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        mainView = UIView(frame: UIScreen.main.bounds)
        mainView.backgroundColor = .white
        self.addSubview(mainView)

        let buttonWidth: CGFloat = 200
        let buttonHeight: CGFloat = 50
        let spacing: CGFloat = 20

        let totalButtonHeight = CGFloat(4) * (buttonHeight + spacing) - spacing
        let startY = (UIScreen.main.bounds.height - totalButtonHeight - buttonHeight - spacing) / 2

        btnSongs = createButton(title: "Show All Songs", action: #selector(showAllSongsButtonTapped))
        btnSongs.addTarget(self, action: #selector(showAllSongsButtonTapped), for: .touchUpInside)
        btnSongs.frame = CGRect(x: (UIScreen.main.bounds.width - buttonWidth) / 2, y: startY, width: buttonWidth, height: buttonHeight)
        mainView.addSubview(btnSongs)

        let nextButtonY = startY + buttonHeight + spacing

        btnArtists = createButton(title: "Show All Artists", action: #selector(showAllArtistsButtonTapped))
        btnArtists.frame = CGRect(x: (UIScreen.main.bounds.width - buttonWidth) / 2, y: nextButtonY, width: buttonWidth, height: buttonHeight)
        mainView.addSubview(btnArtists)

        let nextButtonY2 = nextButtonY + buttonHeight + spacing

        btnAlbums = createButton(title: "Show All Albums", action: #selector(showAllAlbumsButtonTapped))
        btnAlbums.frame = CGRect(x: (UIScreen.main.bounds.width - buttonWidth) / 2, y: nextButtonY2, width: buttonWidth, height: buttonHeight)
        mainView.addSubview(btnAlbums)

        let nextButtonY3 = nextButtonY2 + buttonHeight + spacing

        btnGenres = createButton(title: "Show All Genres", action: #selector(showAllGenresButtonTapped))
        btnGenres.frame = CGRect(x: (UIScreen.main.bounds.width - buttonWidth) / 2, y: nextButtonY3, width: buttonWidth, height: buttonHeight)
        mainView.addSubview(btnGenres)

        let exitButton = UIButton(type: .system)
        exitButton.setTitle("Exit", for: .normal)
        exitButton.setTitleColor(.white, for: .normal)
        exitButton.backgroundColor = UIColor.red
        exitButton.layer.cornerRadius = 10
        exitButton.frame = CGRect(x: (UIScreen.main.bounds.width - buttonWidth) / 2, y: nextButtonY3 + buttonHeight + spacing, width: buttonWidth, height: buttonHeight)
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        mainView.addSubview(exitButton)
        applyGradientBackground()
        addTitleLabel()
    }

    @objc func showAllSongsButtonTapped() {
        let allSongsView = ShowAllSongsView(frame: UIScreen.main.bounds)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.addSubview(allSongsView)
        }
    }

    @objc func showAllArtistsButtonTapped() {
        let allArtistsView = ShowAllArtistsView(frame: UIScreen.main.bounds)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.addSubview(allArtistsView)
        }
    }

    @objc func showAllAlbumsButtonTapped() {
        let allAlbumsView = ShowAllAlbumsView(frame: UIScreen.main.bounds)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.addSubview(allAlbumsView)
        }
    }

    @objc func showAllGenresButtonTapped() {
        let allGenresView = ShowAllGenresView(frame: UIScreen.main.bounds, genres: genres)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.addSubview(allGenresView)
        }
    }

    @objc func addButtonTapped() {
        let alert = UIAlertController(title: "Not Implemented Yet", message: "Can't perform operation", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        var topViewController = UIApplication.shared.windows.first?.rootViewController
        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }
        topViewController?.present(alert, animated: true, completion: nil)
    }

    @objc func exitButtonTapped() {
        exit(0)
    }

    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title.uppercased(), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) // You can adjust the font size as needed
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.5
        button.setTitleColor(.white, for: .normal)
        return button
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func applyGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = mainView.bounds
        gradientLayer.colors = [
            UIColor.systemGreen.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        mainView.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func addTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        let attributedText = NSMutableAttributedString()
        let welcomeText = NSAttributedString(string: "Welcome to\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)])
        let digitalMusicText = NSAttributedString(string: "Digital.Music.App", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 40)])
        attributedText.append(welcomeText)
        attributedText.append(digitalMusicText)
        titleLabel.attributedText = attributedText
        titleLabel.frame = CGRect(x: 20, y: 150, width: UIScreen.main.bounds.width - 40, height: 80)
        mainView.addSubview(titleLabel)
    }
}
