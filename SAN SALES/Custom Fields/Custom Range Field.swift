//
//  Custom Range Field.swift
//  SAN SALES
//
//  Created by Anbu j on 26/12/24.
//

import Foundation
import UIKit


protocol CustomRangeFieldViewDelegate: AnyObject {
    func CustomRangeSelectionLabelDidSelect(tags: [Int],typ:String,selmod:String)
}
//
//class CustomRangeField: UIView {
//    weak var delegate: CustomRangeFieldViewDelegate?
//    
//    var tags: [Int] = []
//    var Typ:String = ""
//    var Mandate = 0
//    // MARK: - UI Components
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Title"
//        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
//        label.alpha = 1 // Make it visible by default
//        return label
//    }()
//    
//    
//    func updateTitleLabel(title:String) {
//        if Mandate == 1 {
//            // Create attributed text with a red asterisk
//            let title = title
//            let asterisk = " *"
//            let attributedString = NSMutableAttributedString(string: title + asterisk)
//            
//            // Set default title attributes
//            attributedString.addAttribute(.foregroundColor, value: titleLabel.textColor!, range: NSRange(location: 0, length: title.count))
//            
//            // Set red color for the asterisk
//            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: title.count, length: asterisk.count))
//            
//            titleLabel.attributedText = attributedString
//        } else {
//            // Set plain text without an asterisk
//            titleLabel.text = title
//        }
//    }
//    
//    private let mandatoryLabel: UILabel = {
//        let label = UILabel()
//        label.text = "*"
//        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//        label.textColor = .red
//        return label
//    }()
//    
//    private lazy var titleStack: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [titleLabel, mandatoryLabel])
//        stackView.axis = .horizontal
//        stackView.spacing = 0 // Adjust spacing between title and mandatory label
//        stackView.alignment = .leading
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//    
//    private let fromLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Select From Time"
//        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
//       // label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
//        label.textColor = .blue
//        return label
//    }()
//    
//    private let toTitleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "to"
//        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
//        label.textColor = .black
//        return label
//    }()
//    
//    private let toLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Select To Time"
//        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
//        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
//        return label
//    }()
//    
//    private lazy var fieldStack: UIStackView = {
//        // Wrap `fromLabel` in a leading container
//        let fromLabelContainer = UIView()
//        fromLabel.translatesAutoresizingMaskIntoConstraints = false
//        fromLabelContainer.addSubview(fromLabel)
//        NSLayoutConstraint.activate([
//            fromLabel.leadingAnchor.constraint(equalTo: fromLabelContainer.leadingAnchor, constant: 5),
//            fromLabel.trailingAnchor.constraint(lessThanOrEqualTo: fromLabelContainer.trailingAnchor, constant: -5),
//            fromLabel.centerYAnchor.constraint(equalTo: fromLabelContainer.centerYAnchor)
//        ])
//        
//        // Wrap `toTitleLabel` in a center container
//        let toTitleLabelContainer = UIView()
//        toTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        toTitleLabelContainer.addSubview(toTitleLabel)
//        NSLayoutConstraint.activate([
//            toTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: toTitleLabelContainer.leadingAnchor, constant: 5),
//            toTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: toTitleLabelContainer.trailingAnchor, constant: -5),
//            toTitleLabel.centerXAnchor.constraint(equalTo: toTitleLabelContainer.centerXAnchor),
//            toTitleLabel.centerYAnchor.constraint(equalTo: toTitleLabelContainer.centerYAnchor)
//        ])
//        
//        // Wrap `toLabel` in a trailing container
//        let toLabelContainer = UIView()
//        toLabel.translatesAutoresizingMaskIntoConstraints = false
//        toLabelContainer.addSubview(toLabel)
//        NSLayoutConstraint.activate([
//            toLabel.leadingAnchor.constraint(greaterThanOrEqualTo: toLabelContainer.leadingAnchor, constant: 5),
//            toLabel.trailingAnchor.constraint(equalTo: toLabelContainer.trailingAnchor, constant: -5),
//            toLabel.centerYAnchor.constraint(equalTo: toLabelContainer.centerYAnchor)
//        ])
//        
//        let stackView = UIStackView(arrangedSubviews: [fromLabelContainer, toTitleLabelContainer, toLabelContainer])
//        stackView.axis = .horizontal
//        stackView.spacing = 8 // Adjust spacing between containers
//        stackView.alignment = .center
//        stackView.backgroundColor = UIColor(red: 0.94, green: 0.95, blue: 0.98, alpha: 1.00)
//        stackView.layer.cornerRadius = 6
//        stackView.layer.masksToBounds = true
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//
//
//    
//    // MARK: - Initializers
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//        setupConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupView()
//        setupConstraints()
//    }
//    
//    // MARK: - Setup Methods
//    private func setupView() {
//        addSubview(titleStack)
//        addSubview(fieldStack)
//        fromLabel.isUserInteractionEnabled = true
//        toLabel.isUserInteractionEnabled = true
//        setupActions()
//        setupMandatoryLabelConstraints()
//    }
//    
//    private func setupMandatoryLabelConstraints() {
//        mandatoryLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            mandatoryLabel.widthAnchor.constraint(equalToConstant: 20), // Set the desired width
//            mandatoryLabel.heightAnchor.constraint(equalToConstant: 20) // Set the desired height
//        ])
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            // Title stack constraints
//            titleStack.leadingAnchor.constraint(equalTo: leadingAnchor),
//            titleStack.trailingAnchor.constraint(equalTo: trailingAnchor),
//            titleStack.topAnchor.constraint(equalTo: topAnchor),
//            
//            // Field stack constraints
//            fieldStack.leadingAnchor.constraint(equalTo: leadingAnchor),
//            fieldStack.trailingAnchor.constraint(equalTo: trailingAnchor),
//            fieldStack.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 8),
//            fieldStack.heightAnchor.constraint(equalToConstant: 40),
//            fieldStack.bottomAnchor.constraint(equalTo: bottomAnchor) // Ensures dynamic height adjustment
//        ])
//    }
//    
//    private func setupActions() {
//        let fromTapGesture = UITapGestureRecognizer(target: self, action: #selector(fromLabelTapped))
//        fromLabel.addGestureRecognizer(fromTapGesture)
//        
//        let toTapGesture = UITapGestureRecognizer(target: self, action: #selector(toLabelTapped))
//        toLabel.addGestureRecognizer(toTapGesture)
//    }
//    
//    @objc private func fromLabelTapped() {
//        delegate?.CustomRangeSelectionLabelDidSelect(tags: tags, typ: Typ, selmod: "FROM")
//    }
//    
//    @objc private func toLabelTapped() {
//        delegate?.CustomRangeSelectionLabelDidSelect(tags: tags, typ: Typ, selmod: "TO")
//    }
//    
//    // MARK: - Configuration
//    func configure(title: String, from: String, to: String, mandatory: Int) {
//        titleLabel.text = title
//        fromLabel.text = from
//        toLabel.text = to
//        updateTitleLabel(title: title)
//        if mandatory == 0 {
//            mandatoryLabel.text = ""
//        } else {
//            mandatoryLabel.text = "*"
//        }
//        
//        // Show or hide the title dynamically
//        titleLabel.alpha = title.isEmpty ? 0 : 1
//    }
//}






class CustomRangeField: UIView {
    weak var delegate: CustomRangeFieldViewDelegate?
    
    var tags: [Int] = []
    var Typ:String = ""
    var Mandate = 0
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        label.alpha = 1 // Make it visible by default
        return label
    }()
    
    
    func updateTitleLabel(title:String) {
        if Mandate == 1 {
            // Create attributed text with a red asterisk
            let title = title
            let asterisk = " *"
            let attributedString = NSMutableAttributedString(string: title + asterisk)
            
            // Set default title attributes
            attributedString.addAttribute(.foregroundColor, value: titleLabel.textColor!, range: NSRange(location: 0, length: title.count))
            
            // Set red color for the asterisk
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: title.count, length: asterisk.count))
            
            titleLabel.attributedText = attributedString
        } else {
            // Set plain text without an asterisk
            titleLabel.text = title
        }
    }
    
    private let mandatoryLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .red
        return label
    }()
    
    private lazy var titleStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, mandatoryLabel])
        stackView.axis = .horizontal
        stackView.spacing = 0 // Adjust spacing between title and mandatory label
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let fromLabel: UILabel = {
        let label = UILabel()
        label.text = "Select From Time"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        return label
    }()
    
    private let toTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "to"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let toLabel: UILabel = {
        let label = UILabel()
        label.text = "Select To Time"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        return label
    }()
    
    private lazy var fieldStack: UIStackView = {
        let leadingSpacer = UIView()
        let trailingSpacer = UIView()

        // Add labels and spacers to the stack view
        let stackView = UIStackView(arrangedSubviews: [ fromLabel, toTitleLabel, toLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8 // Adjust spacing between labels
        stackView.alignment = .center
        stackView.distribution = .equalSpacing // Ensures flexible spacers adjust spacing
        
        // Customize appearance
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
        addSubview(titleStack)
        addSubview(fieldStack)
        fromLabel.isUserInteractionEnabled = true
        toLabel.isUserInteractionEnabled = true
        setupActions()
        setupMandatoryLabelConstraints()
    }
    
    private func setupMandatoryLabelConstraints() {
        mandatoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mandatoryLabel.widthAnchor.constraint(equalToConstant: 20), // Set the desired width
            mandatoryLabel.heightAnchor.constraint(equalToConstant: 20) // Set the desired height
        ])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title stack constraints
            titleStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleStack.topAnchor.constraint(equalTo: topAnchor),
            
            // Field stack constraints
            fieldStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            fieldStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            fieldStack.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 8),
            fieldStack.heightAnchor.constraint(equalToConstant: 40),
            fieldStack.bottomAnchor.constraint(equalTo: bottomAnchor) // Ensures dynamic height adjustment
        ])
    }
    
    private func setupActions() {
        let fromTapGesture = UITapGestureRecognizer(target: self, action: #selector(fromLabelTapped))
        fromLabel.addGestureRecognizer(fromTapGesture)
        
        let toTapGesture = UITapGestureRecognizer(target: self, action: #selector(toLabelTapped))
        toLabel.addGestureRecognizer(toTapGesture)
    }
    
    @objc private func fromLabelTapped() {
        delegate?.CustomRangeSelectionLabelDidSelect(tags: tags, typ: Typ, selmod: "FROM")
    }
    
    @objc private func toLabelTapped() {
        delegate?.CustomRangeSelectionLabelDidSelect(tags: tags, typ: Typ, selmod: "TO")
    }
    
    // MARK: - Configuration
    func configure(title: String, from: String, to: String, mandatory: Int) {
        titleLabel.text = title
        fromLabel.text = from
        toLabel.text = to
        updateTitleLabel(title: title)
        if mandatory == 0 {
            mandatoryLabel.text = ""
        } else {
            mandatoryLabel.text = "*"
        }
        
        // Show or hide the title dynamically
        titleLabel.alpha = title.isEmpty ? 0 : 1
    }
    
    func setFromValue(from:String){
        fromLabel.text = from
    }
    
    func setToValue(to:String){
        toLabel.text = to
    }
}
