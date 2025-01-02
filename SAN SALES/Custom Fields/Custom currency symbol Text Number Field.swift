//
//  Custom currency symbol Text Number Field.swift
//  SAN SALES
//
//  Created by Anbu j on 02/01/25.
//

import UIKit

protocol CustomCurrencyTextNumberFieldDelegate: AnyObject {
    func customCurrencyTextNumberField(_ customTextField: CustomCurrencyTextNumberField, didUpdateText text: String, tags: [Int],currencysymbol:String)
}

class CustomCurrencyTextNumberField: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    weak var delegate: CustomCurrencyTextNumberFieldDelegate?
    var tags: [Int] = []
    var isMandatory: Bool = false
    var textCountLimit: Int = 100
    var currencysymbol = ""
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        return label
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "$"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.backgroundColor = .gray
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        return label
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = .black
        tf.keyboardType = .numberPad
        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 40))
        tf.leftViewMode = .always
        return tf
    }()
    
    private lazy var fieldStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currencyLabel, textField])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.98, alpha: 1.00)
        stackView.layer.cornerRadius = 6
        stackView.layer.masksToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        addSubview(fieldStack)
        textField.delegate = self
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        fieldStack.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title Label Constraints
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            
            // Field Stack Constraints
            fieldStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            fieldStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            fieldStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            fieldStack.heightAnchor.constraint(equalToConstant: 40),
            fieldStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Currency Label Constraints
            currencyLabel.widthAnchor.constraint(equalToConstant: 40),
            currencyLabel.heightAnchor.constraint(equalToConstant: 40),
            
            // Text Field Constraints
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    
    // MARK: - TextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateTitle(visible: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            delegate?.customCurrencyTextNumberField(self, didUpdateText: text, tags: tags, currencysymbol: currencysymbol)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            delegate?.customCurrencyTextNumberField(self, didUpdateText: text, tags: tags, currencysymbol: currencysymbol)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if updatedText.count > textCountLimit {
            return false
        }
        delegate?.customCurrencyTextNumberField(self, didUpdateText: updatedText, tags: tags, currencysymbol: currencysymbol)
        return true
    }
    
    // MARK: - Animation
    private func animateTitle(visible: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.titleLabel.alpha = visible ? 1 : 0.5
        }
    }
    
    // MARK: - Configuration
    func configure(title: String, placeholder: String, textCountLimit: Int,currencysymbol:String) {
        titleLabel.text = title
        currencyLabel.text = currencysymbol
        textField.placeholder = placeholder
        self.textCountLimit = textCountLimit
        updateTitleLabel(setTitle: title)
    }
    
    func updateTitleLabel(setTitle: String) {
        if isMandatory {
            let title = setTitle
            let asterisk = " *"
            let attributedString = NSMutableAttributedString(string: title + asterisk)
            
            attributedString.addAttribute(.foregroundColor, value: titleLabel.textColor!, range: NSRange(location: 0, length: title.count))
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: title.count, length: asterisk.count))
            
            titleLabel.attributedText = attributedString
        } else {
            titleLabel.text = setTitle
        }
    }
}

