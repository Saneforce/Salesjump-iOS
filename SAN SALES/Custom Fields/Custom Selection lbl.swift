//
//  Custom Selection lbl.swift
//  SAN SALES
//
//  Created by Anbu j on 17/12/24.
//

import Foundation
import UIKit


class CustomSelectionLabel: UIView {
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        label.alpha = 0 // Initially hidden
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "Value"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        addSubview(titleLabel)
        addSubview(valueLabel)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title label constraints
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            
            // Value label constraints
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.heightAnchor.constraint(equalToConstant: 40),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor) // For dynamic height
        ])
    }
    
    // MARK: - Configuration
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
        titleLabel.alpha = value.isEmpty ? 0 : 1
    }
    
    // MARK: - Animation
    func animateTitle(visible: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.titleLabel.alpha = visible ? 1 : 0
        }
    }
}

