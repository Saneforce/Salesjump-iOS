//
//  Custom Text Field.swift
//  SAN SALES
//
//  Created by Anbu j on 16/12/24.
//

import Foundation
import UIKit

protocol CustomTextFieldDelegate: AnyObject {
    func customTextField(_ customTextField: CustomTextField, didUpdateText text: String,tags:[Int])
}

//class CustomTextField: UIView, UITextFieldDelegate {
//
//    // MARK: - Properties
//    weak var delegate: CustomTextFieldDelegate? // Delegate property
//    var tags: [Int] = []
//
//    // MARK: - UI Components
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Title"
//        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
//        label.alpha = 1
//        return label
//    }()
//
//    let textField: UITextField = {
//        let tf = UITextField()
//        tf.borderStyle = .roundedRect
//        tf.font = UIFont.systemFont(ofSize: 16)
//        tf.textColor = .black
//        return tf
//    }()
//
//    // MARK: - Initializers
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//        setupConstraints()
//        setupActions()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupView()
//        setupConstraints()
//        setupActions()
//    }
//
//    // MARK: - Setup Methods
//    private func setupView() {
//        addSubview(titleLabel)
//        addSubview(textField)
//        textField.delegate = self // Set the delegate
//    }
//
//    private func setupConstraints() {
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        textField.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
//            titleLabel.topAnchor.constraint(equalTo: topAnchor),
//
//            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
//            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
//            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
//            textField.heightAnchor.constraint(equalToConstant: 40),
//            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//    }
//
//    private func setupActions() {
//        textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
//        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
//    }
//
//    // MARK: - Actions
//    @objc private func textFieldDidBeginEditing() {
//        animateTitle(visible: true)
//    }
//
//    @objc private func textFieldDidEndEditing() {
//        if let text = textField.text, !text.isEmpty {
//            delegate?.customTextField(self, didUpdateText: text, tags: tags) // Notify delegate
//        }
//    }
//
//    private func animateTitle(visible: Bool) {
//        UIView.animate(withDuration: 0.3) {
//            self.titleLabel.alpha = visible ? 1 : 1
//            self.titleLabel.transform = visible ? .identity : CGAffineTransform(translationX: 0, y: 0)
//        }
//    }
//
//    // MARK: - UITextFieldDelegate Methods
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentText = textField.text ?? ""
//        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
//        delegate?.customTextField(self, didUpdateText: updatedText, tags: tags) // Notify delegate
//        return true
//    }
//
//    // MARK: - Configuration
//    func configure(title: String, placeholder: String) {
//        titleLabel.text = title
//        textField.placeholder = placeholder
//    }
//}


class CustomTextField: UIView, UITextViewDelegate {

    // MARK: - Properties
    weak var delegate: CustomTextFieldDelegate?
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

    let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .black
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 5
        tv.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        return tv
    }()

    // Height constraint for dynamic adjustment
    private var textViewHeightConstraint: NSLayoutConstraint?

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
        addSubview(textView)
        textView.delegate = self
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),

            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Initialize height constraint for the text view
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 40)
        textViewHeightConstraint?.isActive = true
    }

    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

        // Update height constraint if the new height is different
        if textViewHeightConstraint?.constant != newSize.height {
            textViewHeightConstraint?.constant = newSize.height
            layoutIfNeeded() // Trigger layout updates
        }

        delegate?.customTextField(self, didUpdateText: textView.text, tags: tags)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        animateTitle(visible: true)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.text.isEmpty {
            delegate?.customTextField(self, didUpdateText: textView.text, tags: tags)
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
        textView.text = placeholder
        textView.textColor = .lightGray
        updateTitleLabel(setTital: title)
    }
}
