//
//  TitledTextField.swift
//  Smartlink Cameras
//
//  Created by Anna on 8/1/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import UIKit

class TitledTextField: UITextField {
    
    private let scale: CGFloat = 0.88
    private let placeholderHeight: CGFloat = 22
    private let defaultHeight: CGFloat = 72
    
    private var placeholderLabel = UILabel()
    private var separatorView = UIView()
    private var placeholderIsSmall: Bool = false
    private var heightConstraint = NSLayoutConstraint()
    
    /// Insets for text in textField
    open var padding: UIEdgeInsets = UIEdgeInsets(top: 36, left: 0, bottom: 0, right: 0)
    
    /// Delegate for controllers
    open weak var customDelegate: UITextFieldDelegate?
    
    /// Setting text for placeholder label
    open var placeholderText: String? {
        get {
            return self.placeholderLabel.text
        }
        set {
            self.placeholderLabel.text = newValue
            if self.placeholderLabel.bounds.size.width == 0 {
                self.placeholderLabel.sizeToFit()
                self.placeholderLabel.frame = CGRect(x: 0,
                    y: self.placeholderLabel.frame.origin.y,
                    width: self.placeholderLabel.frame.width,
                    height: self.placeholderHeight)
            }
        }
    }
    
    override var placeholder: String? {
        didSet {
            movePlaceholderUp(animated: false)
        }
    }
    
    //=========================================================
    // MARK: - Initialization
    //=========================================================
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    convenience init(placeholder: String) {
        self.init(frame: CGRect.zero)
        placeholderText = placeholder
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        updatePlaceholders()
    }
    
    private func setup() {
        mainSetup()
        prepareSeparator()
        prepareCustomPlaceholder()
        delegate = self
    }
    
    private func mainSetup() {
        borderStyle = .none
        contentVerticalAlignment = .top
        tintColor = #colorLiteral(red: 0.3058823529, green: 0.3058823529, blue: 0.3058823529, alpha: 1)
        heightConstraint = heightAnchor.constraint(greaterThanOrEqualToConstant: defaultHeight)
        heightConstraint.priority = UILayoutPriority.init(900)

        NSLayoutConstraint.activate([heightConstraint])
    }
    
    private func prepareSeparator() {
        addSubview(separatorView)
        separatorView.backgroundColor = #colorLiteral(red: 0.3058823529, green: 0.3058823529, blue: 0.3058823529, alpha: 1)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([separatorView.leftAnchor.constraint(equalTo: leftAnchor),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor),
            separatorView.topAnchor.constraint(equalTo: topAnchor, constant: 63),
            separatorView.heightAnchor.constraint(equalToConstant: 1)])
    }
    
    private func prepareCustomPlaceholder() {
        addSubview(placeholderLabel)
        var newRect = textRect(forBounds: self.bounds)
        newRect.origin.y = padding.top
        newRect.size.height = placeholderHeight
        placeholderLabel.frame = newRect
        placeholderLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        placeholderLabel.textColor = #colorLiteral(red: 0.3058823529, green: 0.3058823529, blue: 0.3058823529, alpha: 1)
    }
    
    /// Setting text to textField.
    ///
    /// - Parameters:
    ///   - text: Simple text
    ///   - animated: If true, custom placeholder will be moved up with animation
    open func setText(_ newText: String?, animated: Bool = false) {
        text = newText
        _ = textField(self, shouldChangeCharactersIn: NSRange.init(location: 0, length: 0), replacementString: "")
        if newText?.isEmpty ?? true {
            movePlaceholderDown(animated: animated)
        } else {
            movePlaceholderUp(animated: animated)
        }
    }
}

//=========================================================
// MARK: - UITextFieldDelegate
//=========================================================
extension TitledTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return customDelegate?.textFieldShouldReturn?(textField) ?? true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return customDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        movePlaceholderUp(animated: true)
        customDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        layoutIfNeeded()
        customDelegate?.textFieldDidEndEditing?(textField)
        if text?.isEmpty ?? true {
            movePlaceholderDown(animated: true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let result = customDelegate?.textField?(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
        if !result {
            sendActions(for: .allEditingEvents)
        }
        
        return result
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}

extension TitledTextField {
    func movePlaceholderUp(animated: Bool) {
        guard !placeholderIsSmall else {
            return
        }
        
        placeholderIsSmall = true
        UIView.animate(withDuration: 0.4) {
            let newWidth = self.frame.width * self.scale
            self.placeholderLabel.transform = self.placeholderLabel.transform.scaledBy( x: self.scale, y: self.scale)
            self.placeholderLabel.frame = CGRect(x: 0, y: 6, width: newWidth, height: self.placeholderHeight)
            self.placeholderLabel.textColor = #colorLiteral(red: 0.5528972149, green: 0.5529660583, blue: 0.5528737307, alpha: 1)
        }
    }
    
    func movePlaceholderDown(animated: Bool) {
        guard placeholderIsSmall, placeholder?.isEmpty ?? true else {
            return
        }
        
        placeholderIsSmall = false
        UIView.animate(withDuration: 0.4) {
            self.placeholderLabel.transform = self.placeholderLabel.transform.scaledBy( x: 1 / self.scale,
                                                                                        y: 1 / self.scale)
            var newRect = self.textRect(forBounds: self.bounds)
            newRect.origin.y = self.padding.top
            newRect.size.height = self.placeholderHeight
            self.placeholderLabel.frame = newRect
            self.placeholderLabel.textColor = #colorLiteral(red: 0.3058823529, green: 0.3058823529, blue: 0.3058823529, alpha: 1)
        }
    }
}

//=========================================================
// MARK: - Editional setup
//=========================================================
extension TitledTextField {
    
    @discardableResult override func resignFirstResponder() -> Bool {
        let res = super.resignFirstResponder()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        return res
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let origin = super.textRect(forBounds: bounds)
        padding.left = self.leftView == nil ? 0 : 8
        return origin.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return super.placeholderRect(forBounds: bounds)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let origin = super.editingRect(forBounds: bounds)
        return origin.inset(by: padding)
    }
}

extension TitledTextField {
    
    func updatePlaceholders() {
        if placeholderIsSmall {
            let newWidth = bounds.size.width * scale
            placeholderLabel.frame = CGRect(x: 0, y: 6, width: newWidth, height: placeholderHeight)
        } else {
            var newRect = textRect(forBounds: bounds)
            newRect.origin.y = padding.top
            newRect.size.height = placeholderHeight
            placeholderLabel.frame = newRect
        }
    }
}

