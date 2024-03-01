import UIKit

class AddAlbumView: UIView {
    private var albumNameTextField: UITextField!
    private var releaseDateTextField: UITextField!
    private var artistNameTextField: UITextField!
    private var addButton: UIButton!
    private var backButton: UIButton!
    private var gradientLayer: CAGradientLayer!
    private var titleLabel = UILabel()
    
    var onAddButtonTapped: ((String, String, String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Add gradient background
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.systemGreen.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
        
        // Back button
        backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        addSubview(backButton)
        
        // Add button
        addButton = UIButton(type: .system)
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addSubview(addButton)

        // Other UI components
        titleLabel.text = "Add New Album"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        albumNameTextField = UITextField()
        albumNameTextField.placeholder = "Album Name"
        albumNameTextField.borderStyle = .roundedRect
        addSubview(albumNameTextField)
        
        releaseDateTextField = UITextField()
        releaseDateTextField.placeholder = "Release Date"
        releaseDateTextField.borderStyle = .roundedRect
        addSubview(releaseDateTextField)
        
        artistNameTextField = UITextField()
        artistNameTextField.placeholder = "Artist Name"
        artistNameTextField.borderStyle = .roundedRect
        addSubview(artistNameTextField)
        
        setupConstraints()
    }
    
    
    
    @objc private func addButtonTapped() {
        guard let albumName = albumNameTextField.text, !albumName.isEmpty,
              let releaseDate = releaseDateTextField.text, !releaseDate.isEmpty,
              let artistName = artistNameTextField.text, !artistName.isEmpty else {
            // Show an alert if any of the fields are empty
            showAlert(message: "Please fill in all fields.")
            return
        }
        
        // Proceed with adding the album
        onAddButtonTapped?(albumName, releaseDate, artistName)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Missing Information", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    private func setupConstraints() {
        titleLabel.frame = CGRect(x: 20, y: 20, width: frame.width - 40, height: 30)
        albumNameTextField.frame = CGRect(x: 20, y: titleLabel.frame.maxY + 20, width: frame.width - 40, height: 40)
        releaseDateTextField.frame = CGRect(x: 20, y: albumNameTextField.frame.maxY + 20, width: frame.width - 40, height: 40)
        artistNameTextField.frame = CGRect(x: 20, y: releaseDateTextField.frame.maxY + 20, width: frame.width - 40, height: 40)
        
        let buttonWidth: CGFloat = 150
        let buttonHeight: CGFloat = 50
        let buttonSpacing: CGFloat = 20

        backButton.frame = CGRect(x: (frame.width - buttonWidth * 2 - buttonSpacing) / 2, y: artistNameTextField.frame.maxY + 20, width: buttonWidth, height: buttonHeight)
        backButton.backgroundColor = .black
        backButton.titleLabel?.textColor = .white
        backButton.layer.cornerRadius = 5
        addButton.frame = CGRect(x: backButton.frame.maxX + buttonSpacing, y: artistNameTextField.frame.maxY + 20, width: buttonWidth, height: buttonHeight)
        addButton.backgroundColor = .black
        addButton.titleLabel?.textColor = .white
        addButton.layer.cornerRadius = 5
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

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
