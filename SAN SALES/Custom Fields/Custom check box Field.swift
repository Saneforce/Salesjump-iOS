//
//  Custom check box Field.swift
//  SAN SALES
//
//  Created by Anbu j on 16/12/24.
//

import UIKit

protocol CustomCheckboxViewDelegate: AnyObject {
    func checkboxViewDidSelect(_ title: String, isSelected: Bool, tag: Int, tags: [Int],Selectaheckbox:[String:Bool])
}

//class CustomCheckboxView: UIView {
//    
//    // MARK: - Properties
//    private var checkBoxStates: [String: Bool] = [:] // Tracks checkbox states
//    weak var delegate: CustomCheckboxViewDelegate? // Delegate reference
//    var tags: [Int] = []
//    // MARK: - UI Components
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Title"
//        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//        label.textColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
//        return label
//    }()
//    
//    private let checkBoxStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.spacing = 8
//        return stackView
//    }()
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
//        addSubview(titleLabel)
//        addSubview(checkBoxStackView)
//    }
//    
//    private func setupConstraints() {
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        checkBoxStackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            // Title label constraints
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
//            titleLabel.topAnchor.constraint(equalTo: topAnchor),
//            
//            // Checkbox stack view constraints
//            checkBoxStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            checkBoxStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            checkBoxStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//            checkBoxStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor) // Dynamic height
//        ])
//    }
//    
//    // MARK: - Configuration
//    func configure(title: String, checkBoxTitles: [String]) {
//        titleLabel.text = title
//        
//        // Clear existing checkboxes and reset states
//        checkBoxStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
//        checkBoxStates.removeAll()
//        
//        // Add new checkboxes
//        for title in checkBoxTitles {
//            let checkBox = createCheckBox(title: title)
//            checkBoxStackView.addArrangedSubview(checkBox)
//            checkBoxStates[title] = false // Default state is unselected
//        }
//    }
//    
//    private func createCheckBox(title: String) -> UIView {
//        let checkBoxView = UIView()
//        checkBoxView.isUserInteractionEnabled = true
//        
//        let checkBoxLabel = UILabel()
//        checkBoxLabel.text = "☐"
//        checkBoxLabel.font = UIFont.systemFont(ofSize: 18)
//        checkBoxLabel.tag = title.hash // Use hash of title for identification
//        
//        let titleLabel = UILabel()
//        titleLabel.text = title
//        titleLabel.font = UIFont.systemFont(ofSize: 14)
//        
//        let stack = UIStackView(arrangedSubviews: [checkBoxLabel, titleLabel])
//        stack.axis = .horizontal
//        stack.spacing = 8
//        stack.alignment = .center
//        
//        checkBoxView.addSubview(stack)
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            stack.leadingAnchor.constraint(equalTo: checkBoxView.leadingAnchor),
//            stack.trailingAnchor.constraint(equalTo: checkBoxView.trailingAnchor),
//            stack.topAnchor.constraint(equalTo: checkBoxView.topAnchor),
//            stack.bottomAnchor.constraint(equalTo: checkBoxView.bottomAnchor)
//        ])
//        
//        // Add tap gesture to handle checkbox toggle
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCheckbox(_:)))
//        checkBoxView.addGestureRecognizer(tapGesture)
//        
//        return checkBoxView
//    }
//    
//    @objc private func toggleCheckbox(_ sender: UITapGestureRecognizer) {
//        guard let checkBoxView = sender.view,
//              let stack = checkBoxView.subviews.first as? UIStackView,
//              let checkBoxLabel = stack.arrangedSubviews.first as? UILabel,
//              let titleLabel = stack.arrangedSubviews.last as? UILabel,
//              let title = titleLabel.text else { return }
//        
//        // Toggle checkbox state
//        let isSelected = !(checkBoxStates[title] ?? false)
//        checkBoxStates[title] = isSelected
//        
//        // Update UI
//        checkBoxLabel.text = isSelected ? "☑" : "☐"
//        
//        // Notify the delegate
//       // delegate?.checkboxViewDidSelect(title, isSelected: isSelected, tag: self.tag)
//        delegate?.checkboxViewDidSelect(title, isSelected: isSelected, tag: self.tag, tags: tags, Selectaheckbox: checkBoxStates)
//    }
//}






class CustomCheckboxView: UIView {
    
    // MARK: - Properties
    private var checkBoxStates: [String: Bool] = [:] // Tracks checkbox states
    weak var delegate: CustomCheckboxViewDelegate? // Delegate reference
    var tags: [Int] = []
    
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
    
    private func setupConstraints() {
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
        
        // Clear existing checkboxes and reset states
        checkBoxStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        checkBoxStates.removeAll()
        
        // Add new checkboxes
        for title in checkBoxTitles {
            let checkBox = createCheckBox(title: title)
            checkBoxStackView.addArrangedSubview(checkBox)
            checkBoxStates[title] = false // Default state is unselected
        }
    }
    
    private func createCheckBox(title: String) -> UIView {
        let checkBoxView = UIView()
        checkBoxView.isUserInteractionEnabled = true

        let checkBoxImageView = UIImageView()
        checkBoxImageView.image = UIImage(named: "uncheckbox") // Default unselected state
        checkBoxImageView.contentMode = .scaleAspectFit
        checkBoxImageView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14)

        let stack = UIStackView(arrangedSubviews: [checkBoxImageView, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center

        checkBoxView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Constraints for the stack view
            stack.leadingAnchor.constraint(equalTo: checkBoxView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: checkBoxView.trailingAnchor),
            stack.topAnchor.constraint(equalTo: checkBoxView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: checkBoxView.bottomAnchor),
            
            // Constraints for the checkbox image view
            checkBoxImageView.widthAnchor.constraint(equalToConstant: 24), // Set width
            checkBoxImageView.heightAnchor.constraint(equalToConstant: 24) // Set height
        ])

        // Add tap gesture to handle checkbox toggle
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCheckbox(_:)))
        checkBoxView.addGestureRecognizer(tapGesture)

        return checkBoxView
    }

    
    @objc private func toggleCheckbox(_ sender: UITapGestureRecognizer) {
        guard let checkBoxView = sender.view,
              let stack = checkBoxView.subviews.first as? UIStackView,
              let checkBoxImageView = stack.arrangedSubviews.first as? UIImageView,
              let titleLabel = stack.arrangedSubviews.last as? UILabel,
              let title = titleLabel.text else { return }

        // Toggle checkbox state
        let isSelected = !(checkBoxStates[title] ?? false)
        checkBoxStates[title] = isSelected

        // Update UI
        checkBoxImageView.image = UIImage(named: isSelected ? "checkbox" : "uncheckbox")

        // Notify the delegate
        delegate?.checkboxViewDidSelect(title, isSelected: isSelected, tag: self.tag, tags: tags, Selectaheckbox: checkBoxStates)
    }
}
