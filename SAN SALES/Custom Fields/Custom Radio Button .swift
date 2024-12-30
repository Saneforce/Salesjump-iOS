//
//  Custom Radio Button .swift
//  SAN SALES
//
//  Created by Anbu j on 17/12/24.
//

import Foundation
import UIKit

class CustomRadioButtonView: UIView {
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        return label
    }()
    
    private let radioButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Properties
    private var radioButtons: [UIButton] = []
    
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
        addSubview(radioButtonStackView)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        radioButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title label constraints
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            
            // Radio button stack view constraints
            radioButtonStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            radioButtonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            radioButtonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            radioButtonStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor) // Dynamic height
        ])
    }
    
    // MARK: - Configuration
    func configure(title: String, radioButtonTitles: [String]) {
        titleLabel.text = title
        
        print(radioButtonTitles)
        
        // Clear existing radio buttons
        radioButtonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        radioButtons.removeAll()
        
        // Add new radio buttons
        for title in radioButtonTitles {
            let radioButton = createRadioButton(title: title)
            radioButtonStackView.addArrangedSubview(radioButton)
        }
    }
    
    private func createRadioButton(title: String) -> UIView {
        let containerView = UIView()
        
        // Button
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "radio-button"), for: .normal)
        button.setImage(UIImage(named: "radio"), for: .selected)
        button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        radioButtons.append(button)
        NSLayoutConstraint.activate([
        
            button.heightAnchor.constraint(equalToConstant: 25),
            button.widthAnchor.constraint(equalToConstant: 25)
        ] )
        
        // Label
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 14)
        
        // Horizontal Stack
        let stack = UIStackView(arrangedSubviews: [button, label])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        
        containerView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stack.topAnchor.constraint(equalTo: containerView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    // MARK: - Actions
    @objc private func radioButtonTapped(_ sender: UIButton) {
        // Deselect all buttons
        for button in radioButtons {
            button.isSelected = false
        }
        
        // Select the tapped button
        sender.isSelected = true
    }
}

