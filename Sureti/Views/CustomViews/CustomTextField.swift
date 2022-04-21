//
//  CustomTextField.swift
//  nullbrainer-sureti
//
//  Created by Amjad on 20/04/2022.
//

import Foundation
import UIKit
import MaterialComponents
//import MaterialComponents.MaterialTextControls_OutlinedTextFields
protocol CustomTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: CustomTextField)
    func textFieldDidEndEditing(_ textField: CustomTextField)
    func textField(_ textField: CustomTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}
@IBDesignable
class CustomTextField: UIView{
    var delegate: CustomTextFieldDelegate?
    var textInput: MDCOutlinedTextField!
    @IBInspectable var placeholder: String = "" {
        didSet {
            textInput.placeholder = placeholder
        }
    }
    @IBInspectable var labelText: String = "Label" {
        didSet {
            textInput.label.text = labelText
        }
    }
    @IBInspectable var primaryColor: UIColor =  UIColor(named: "primaryColor") ?? .blue {
        didSet {
            self.setColors()
        }
    }
    //private let placeHolderColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
    //private let labelTextColorEditing: UIColor = .black
    //private let borderColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.36)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInputView()
        setupContoller()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupInputView(){
        //MARK: Text Input Setup
        
        if let _ = self.viewWithTag(1){return}
        
        textInput = MDCOutlinedTextField()
        textInput.tag = 1
        textInput.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textInput)
        NSLayoutConstraint.activate([
            (textInput.topAnchor.constraint(equalTo: self.topAnchor)),
            (textInput.bottomAnchor.constraint(equalTo: self.bottomAnchor)),
            (textInput.leadingAnchor.constraint(equalTo: self.leadingAnchor)),
            (textInput.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        ])
    }
    
    private func setupContoller(){
        // MARK: Text Input Controller Setup
        //textInput.textColor = .black
        textInput.placeholder = placeholder
        textInput.label.text = labelText
        self.textInput.containerRadius = 4
        textInput.delegate = self
        textInput.font = UIFont(name: "Poppins-Regular", size: 14)
        textInput.label.font = UIFont(name: "Poppins-Regular", size: 14)
        self.setColors()
    }
    private func setColors() {
        self.textInput.setNormalLabelColor(primaryColor.withAlphaComponent(0.5), for: .normal)
        self.textInput.setFloatingLabelColor(primaryColor.withAlphaComponent(0.5), for: .editing)
        self.textInput.setFloatingLabelColor(primaryColor.withAlphaComponent(0.5), for: .normal)
        self.textInput.setOutlineColor(primaryColor, for: .normal)
        self.textInput.setOutlineColor(primaryColor, for: .editing)
        self.textInput.setTextColor(primaryColor, for: .normal)
        self.textInput.setTextColor(primaryColor, for: .editing)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
}

extension CustomTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let delegate = delegate else {
            return
        }
        delegate.textFieldDidBeginEditing(self)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let delegate = delegate else {
            return
        }
        delegate.textFieldDidEndEditing(self)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let delegate = delegate else {
            return true
        }
        return delegate.textField(self, shouldChangeCharactersIn: range, replacementString: string)
    }
    
}

