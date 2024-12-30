//
//  Custom Text Number Field.swift
//  SAN SALES
//
//  Created by Anbu j on 16/12/24.
//

import UIKit

protocol CustomTextNumberFieldDelegate: AnyObject {
    func customTextNumberField(_ customTextField: CustomTextNumberField, didUpdateText text: String, tags: [Int])
}

class CustomTextNumberField: UIView, UITextFieldDelegate {

    // MARK: - Properties
    weak var delegate: CustomTextNumberFieldDelegate?
    var tags: [Int] = []
    var Mandate = 0
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        label.alpha = 1
        return label
    }()

    func updateTitleLabel(setTital:String) {
        if Mandate == 1 {
            // Create attributed text with a red asterisk
            let title = setTital
            let asterisk = " *"
            let attributedString = NSMutableAttributedString(string: title + asterisk)
            
            // Set default title attributes
            attributedString.addAttribute(.foregroundColor, value: titleLabel.textColor!, range: NSRange(location: 0, length: title.count))
            
            // Set red color for the asterisk
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: title.count, length: asterisk.count))
            
            titleLabel.attributedText = attributedString
        } else {
            // Set plain text without an asterisk
            titleLabel.text = setTital
        }
    }
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = .black
        tf.keyboardType = .numberPad
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 40)) // Add padding
        tf.leftViewMode = .always
        return tf
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
        addSubview(textField)
        textField.delegate = self
    
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),

            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            textField.heightAnchor.constraint(equalToConstant: 40),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateTitle(visible: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            delegate?.customTextNumberField(self, didUpdateText: text, tags: tags)
        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            delegate?.customTextNumberField(self, didUpdateText: text, tags: tags)
        }
    }

    // MARK: - Animation
    private func animateTitle(visible: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.titleLabel.alpha = visible ? 1 : 0.5
        }
    }

    // MARK: - Configuration
    func configure(title: String, placeholder: String) {
        titleLabel.text = title
        textField.placeholder = placeholder
        updateTitleLabel(setTital: title)
    }
}
