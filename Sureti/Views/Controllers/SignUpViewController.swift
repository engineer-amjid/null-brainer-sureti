//
//  SignUpViewController.swift
//  nullbrainer-sureti
//
//  Created by Amjad on 20/04/2022.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var confirmPasswordTextField: CustomTextField!
    @IBOutlet weak var nextButton: UIButton!
    var email: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextFields()
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    func setupTextFields() {
        self.firstNameTextField.textInput.autocapitalizationType = .words
        self.lastNameTextField.textInput.autocapitalizationType = .words
        self.emailTextField.textInput.isEnabled = false
        self.emailTextField.textInput.text = email ?? ""
        self.passwordTextField.textInput.isSecureTextEntry = true
        self.confirmPasswordTextField.textInput.isSecureTextEntry = true
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if self.firstNameTextField.textInput.text?.isEmpty ?? false ||
            self.lastNameTextField.textInput.text?.isEmpty ?? false ||
            self.passwordTextField.textInput.text?.isEmpty ?? false ||
            self.confirmPasswordTextField.textInput.text?.isEmpty ?? false {
            self.showAlert(message: "All fields are required.")
        } else  if self.passwordTextField.textInput.text != self.confirmPasswordTextField.textInput.text {
            self.showAlert(message: "Password mismatch")
        } else {
            self.registerUser()
        }
    }
    private func registerUser() {
        APIManager.shared.request(url: "https://devconsole.sureti.com:9000/Mobile/RegisterUser",
                                  method: .post,
                                  parameters: ["email": emailTextField.textInput.text ?? "",
                                               "password": self.passwordTextField.textInput.text ?? "",
                                               "firstName": self.firstNameTextField.textInput.text ?? "",
                                               "lastName": self.lastNameTextField.textInput.text ?? "",
                                               "userCellNo": "1234556",
                                               "mailingAddress": "street 2",
                                               
                                              ]) { (success, result: EmailModel?, statusCode, message) in
            if success {
                if statusCode == 200 {
                    self.showAlert(message: result?.message ?? "")
                } else {
                    self.showAlert(message: message ?? "")
                }
            } else {
                self.showAlert(message: message ?? "")
            }
        }
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
