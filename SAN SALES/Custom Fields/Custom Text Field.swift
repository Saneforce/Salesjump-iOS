//
//  Custom Text Field.swift
//  SAN SALES
//
//  Created by Anbu j on 16/12/24.
//

import Foundation
import UIKit


class CustomTextField: UIView {
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray
        label.alpha = 1 // Initially hidden
        return label
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = .black
        return tf
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        addSubview(titleLabel)
        addSubview(textField)
    }
    
    private func setupConstraints(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title label constraints
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            
            // Text field constraints
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            textField.heightAnchor.constraint(equalToConstant: 40),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor) // For dynamic height
        ])
    }
    
    private func setupActions() {
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
    }
    
    // MARK: - Actions
    @objc private func textFieldDidBeginEditing() {
        animateTitle(visible: true)
    }
    
    @objc private func textFieldDidEndEditing(){
        if textField.text?.isEmpty == true {
            animateTitle(visible: false)
        }
    }
    
    private func animateTitle(visible: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.titleLabel.alpha = visible ? 1 : 1
            self.titleLabel.transform = visible ? .identity : CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    // MARK: - Configuration
    func configure(title: String, placeholder: String) {
        titleLabel.text = title
        textField.placeholder = placeholder
    }
}

