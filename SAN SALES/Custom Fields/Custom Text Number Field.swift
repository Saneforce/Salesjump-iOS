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

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        label.alpha = 1
        return label
    }()

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
    }
}



//class CustomTextNumberField: UIView {
//    
//    weak var delegate: CustomTextNumberFieldDelegate?
//    var tags: [Int] = []
//    // MARK: - UI Components
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Title"
//        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
//        label.alpha = 1 // Initially hidden
//        return label
//    }()
//    
//    let textField: UITextField = {
//        let tf = UITextField()
//        tf.borderStyle = .roundedRect
//        tf.font = UIFont.systemFont(ofSize: 16)
//        tf.textColor = .black
//        tf.keyboardType = .numberPad
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
//    }
//    
//    private func setupConstraints(){
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            // Title label constraints
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
//            titleLabel.topAnchor.constraint(equalTo: topAnchor),
//            
//            // Text field constraints
//            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
//            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
//            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
//            textField.heightAnchor.constraint(equalToConstant: 40),
//            textField.bottomAnchor.constraint(equalTo: bottomAnchor) // For dynamic height
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
//    @objc private func textFieldDidEndEditing(){
//        if textField.text?.isEmpty == true {
//            animateTitle(visible: false)
//        }
//    }
//    
//    // MARK: - UITextViewDelegate
//    func textViewDidChange(_ textView: UITextView) {
//        let fixedWidth = textView.frame.width
//        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        delegate?.customTextNumberField(self, didUpdateText: textView.text, tags: tags)
//    }
//    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        animateTitle(visible: true)
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if !textView.text.isEmpty {
//            delegate?.customTextNumberField(self, didUpdateText: textView.text, tags: tags)
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
//    // MARK: - Configuration
//    func configure(title: String, placeholder: String) {
//        titleLabel.text = title
//        textField.placeholder = placeholder
//    }
//}
