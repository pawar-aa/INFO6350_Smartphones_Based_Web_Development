import Foundation
import UIKit

class AddGenre: UIView {
    private var genreNameTextField: UITextField!
    private var addButton: UIButton!
    private var backButton: UIButton!
    private var gradientLayer: CAGradientLayer!

    var onAddGenre: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Add gradient background
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.systemGreen.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)

        // Back button
        backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backButton)
        
        // Other UI components
        let titleLabel = UILabel()
        titleLabel.text = "Add New Genre"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        genreNameTextField = UITextField()
        genreNameTextField.placeholder = "Enter Genre Name"
        genreNameTextField.borderStyle = .roundedRect
        genreNameTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(genreNameTextField)

        addButton = UIButton(type: .system)
        addButton.setTitle("Add", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addButton)

        // Layout constraints
        backButton.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true

        genreNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        genreNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        genreNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true

        addButton.topAnchor.constraint(equalTo: genreNameTextField.bottomAnchor, constant: 20).isActive = true
        addButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    @objc private func addButtonTapped() {
        guard let genreName = genreNameTextField.text, !genreName.isEmpty else { return }
        onAddGenre?(genreName)
        removeFromSuperview()
    }

    @objc private func backButtonTapped() {
        removeFromSuperview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
