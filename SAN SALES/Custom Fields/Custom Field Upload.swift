//
//  Custom Field Upload.swift
//  SAN SALES
//
//  Created by Anbu j on 17/12/24.
//

import Foundation
import UIKit

class CustomFieldUpload: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        label.alpha = 0 // Initially hidden
        return label
    }()
    
    // Store reference to the dynamic label inside the stack view
    private let dynamicLabel: UILabel = {
        let label = PaddedLabel()
        label.text = "TEST"
        label.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.98, alpha: 1.00)
        label.font = UIFont.systemFont(ofSize: 14,weight: .semibold)
        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.edgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.clipsToBounds  = true
        return label
    }()
    
    private let imageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "check")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 15)
        ])
        return imageView
    }()
    
    private let imageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "upload")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 25),
            imageView.heightAnchor.constraint(equalToConstant: 25)
        ])
        return imageView
    }()
    
    private let stackView: UIStackView
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        // Initialize the stackView after all its components are ready
        stackView = UIStackView(arrangedSubviews: [dynamicLabel, imageView1, imageView2])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        // Initialize the stackView after all its components are ready
        stackView = UIStackView(arrangedSubviews: [dynamicLabel, imageView1, imageView2])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup Method
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(stackView)
        
        // Add constraints for titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -0)
        ])
        
        // Add constraints for stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -0),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -0)
        ])
    }
    
    public func setTitleText(_ text: String) {
        titleLabel.text = text
        titleLabel.alpha = 1 // Make it visible when updated
    }
    
    /// Update the dynamicLabel text inside stackView
    public func setDynamicLabelText(_ text: String) {
        dynamicLabel.text = text
    }
}



