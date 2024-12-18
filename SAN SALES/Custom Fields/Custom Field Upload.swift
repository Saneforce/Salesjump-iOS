//
//  Custom Field Upload.swift
//  SAN SALES
//
//  Created by Anbu j on 17/12/24.
//

import Foundation
import UIKit

protocol CustomFieldUploadViewDelegate: AnyObject {
    func CustomFieldUploadDidSelect(_ title: String, isSelected: Bool, tag: Int, tags: [Int],Selectaheckbox:[String:Bool])
}

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
    
    private let dynamicLabel: UILabel = {
        let label = PaddedLabel()
        label.text = "TEST"
        label.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.98, alpha: 1.00)
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.edgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.clipsToBounds  = true
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
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
        imageView.isUserInteractionEnabled = true // Enable user interaction
        return imageView
    }()
    
    private let stackView: UIStackView
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        stackView = UIStackView(arrangedSubviews: [dynamicLabel, imageView1, imageView2])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: frame)
        setupViews()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        stackView = UIStackView(arrangedSubviews: [dynamicLabel, imageView1, imageView2])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        super.init(coder: coder)
        setupViews()
        setupActions()
    }
    
    // MARK: - Setup Methods
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(stackView)
        
        // Constraints for titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // Constraints for stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadImageTapped))
        imageView2.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @objc private func uploadImageTapped() {
        setDynamicLabelText("Uploading...")
        hideCheckImage()
        
        // Simulate an upload process with a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.setDynamicLabelText("Upload Complete")
        }
    }
    
    // MARK: - Public Methods
    
    public func setTitleText(_ text: String) {
        titleLabel.text = text
        titleLabel.alpha = 1 // Make titleLabel visible
    }
    
    public func setDynamicLabelText(_ text: String) {
        dynamicLabel.text = text
    }
    
    public func hideCheckImage() {
        imageView1.isHidden = true
    }
}
