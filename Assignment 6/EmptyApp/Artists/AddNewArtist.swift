import Foundation
import UIKit

protocol AddArtistDelegate: AnyObject {
    func artistAdded(_ artist: Artist)
}

class AddArtistView: UIView {
    weak var delegate: AddArtistDelegate?
    private var backButton: UIButton!
    private var gradientLayer: CAGradientLayer!

    private var nameLabel: UILabel!
    private var nameTextField: UITextField!
    private var addButton: UIButton!

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
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        addSubview(backButton)
        
        nameLabel = UILabel(frame: CGRect(x: 20, y: 100, width: frame.width - 40, height: 30))
        nameLabel.text = "Artist Name:"
        addSubview(nameLabel)

        nameTextField = UITextField(frame: CGRect(x: 20, y: nameLabel.frame.maxY + 10, width: frame.width - 40, height: 40))
        nameTextField.placeholder = "Enter artist name"
        nameTextField.borderStyle = .roundedRect
        addSubview(nameTextField)

        addButton = UIButton(type: .system)
        addButton.setTitle("Add Artist", for: .normal)
        addButton.frame = CGRect(x: 20, y: nameTextField.frame.maxY + 20, width: frame.width - 40, height: 50)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addSubview(addButton)
    }
    

    @objc private func addButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            // Show an alert or handle the case when the name is empty
            return
        }

        // Find the maximum ID among existing artists
        let maxID = artists.map { $0.id }.max() ?? 0

        // Create a new Artist object with a unique ID
        let newArtist = Artist(id: maxID + 1, name: name)

        // Notify the delegate that a new artist has been added
        delegate?.artistAdded(newArtist)
        removeFromSuperview()
    }
    
    @objc private func backButtonTapped() {
        removeFromSuperview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
