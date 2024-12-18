//
//  Header UILabel.swift
//  SAN SALES
//
//  Created by Anbu j on 18/12/24.
//

import Foundation
import UIKit

class HeaderLabel: UIView {
    
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.alpha = 1 // Initially visible
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        addSubview(titleLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0), // Align to leading with padding
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor), // Vertically center
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -0) // Ensure no overlap with trailing
        ])
    }
    
    // MARK: - Configuration
    func configure(title: String) {
        titleLabel.text = title
    }
}


