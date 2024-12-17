//
//  Custom check box Field.swift
//  SAN SALES
//
//  Created by Anbu j on 16/12/24.
//

import UIKit

class CustomCheckboxView: UIView {
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        return label
    }()
    
    private let checkBoxStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
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
        addSubview(checkBoxStackView)
    }
    
    private func setupConstraints(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        checkBoxStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title label constraints
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            
            // Checkbox stack view constraints
            checkBoxStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkBoxStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            checkBoxStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            checkBoxStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor) // Dynamic height
        ])
    }
    
    // MARK: - Configuration
    func configure(title: String, checkBoxTitles: [String]) {
        titleLabel.text = title
        
        // Clear existing checkboxes
        checkBoxStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add new checkboxes
        for title in checkBoxTitles {
            let checkBox = createCheckBox(title: title)
            checkBoxStackView.addArrangedSubview(checkBox)
        }
    }
    
    private func createCheckBox(title: String) -> UIView {
        let checkBoxView = UIView()
        let button = UIButton(type: .system)
        button.setTitle("☐", for: .normal)
        button.setTitle("☑", for: .selected)
        button.addTarget(self, action: #selector(toggleCheckbox(_:)), for: .touchUpInside)
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 14)
        
        let stack = UIStackView(arrangedSubviews: [button, label])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        
        checkBoxView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: checkBoxView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: checkBoxView.trailingAnchor),
            stack.topAnchor.constraint(equalTo: checkBoxView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: checkBoxView.bottomAnchor)
        ])
        
        return checkBoxView
    }
    
    @objc private func toggleCheckbox(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}
