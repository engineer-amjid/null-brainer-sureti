//
//  LoginViewController.swift
//  nullbrainer-sureti
//
//  Created by Amjad on 20/04/2022.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var forgetButton: UIButton!
    @IBOutlet weak var backArrowButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextFields()
        self.setupEmailView()
    }
    func setupTextFields() {
        emailTextField.delegate = self
        self.emailTextField.textInput.autocapitalizationType = .none
        self.emailTextField.textInput.autocorrectionType = .no
        self.emailTextField.textInput.keyboardType = .emailAddress
        self.passwordTextField.textInput.isSecureTextEntry = true
    }
    func setupEmailView() {
        self.titleLabel.text = "Sign In or Create Account"
        self.backArrowButton.isHidden = true
        self.passwordTextField.isHidden = true
        self.emailTextField.isHidden = false
        self.emailTextField.textInput.text = ""
        self.forgetButton.isHidden = true
        self.nextButton.setTitle("Next", for: .normal)
        self.nextButton.tag = 1
    }
    func setupPasswordView() {
        self.titleLabel.text = "Sign In"
        self.backArrowButton.isHidden = false
        self.passwordTextField.isHidden = false
        self.passwordTextField.textInput.text = ""
        self.emailTextField.isHidden = true
        self.forgetButton.isHidden = false
        self.nextButton.setTitle("Sign In", for: .normal)
        self.nextButton.tag = 2
    }
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if sender.tag == 1 {
            self.checkEmail()
        } else {
            self.loginUser()
        }
    }
    @IBAction func backArrowAction(_ sender: Any) {
        self.setupEmailView()
    }
    
    private func checkEmail() {
        APIManager.shared.request(url: "https://devconsole.sureti.com:9000/Mobile/doesUserExist", method: .post, parameters: ["email": emailTextField.textInput.text ?? ""]) { (success, result: EmailModel?, statusCode, message) in
            if success {
                if statusCode == 200 {
                    if result?.requestedAction ?? false {
                        // Move to sign up screen
                        if result?.message == "User Found." {
                            self.setupPasswordView()
                        } else {
                            if let vc = SignUpViewController.instantiate() {
                                vc.email = self.emailTextField.textInput.text ?? ""
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        
                    } else {
                        self.showAlert(message: result?.message ?? "")
                    }
                } else {
                    self.showAlert(message: message ?? "")
                }
            } else {
                self.showAlert(message: message ?? "")
            }
        }
    }
    private func loginUser() {
        APIManager.shared.request(url: "https://devconsole.sureti.com:9000/Mobile/UserLogin",
                                  method: .post,
                                  parameters: ["email": emailTextField.textInput.text ?? "",
                                               "password": self.passwordTextField.textInput.text ?? "",
                                               "pushNotificationToken": "",
                                               "appVersion": UserDefaults.standard.value(forKey: "currentAppVersion") ?? ""
                                              ]) { (success, result: EmailModel?, statusCode, message) in
            if success {
                if statusCode == 200 {
                    if result?.requestedAction ?? false {
                        self.showAlert(message: "Logged In Successfully!")
                    } else {
                        self.showAlert(message: result?.message ?? "")
                    }
                    
                } else {
                    self.showAlert(message: message ?? "")
                }
            } else {
                self.showAlert(message: message ?? "")
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: CustomTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: CustomTextField) {
        
    }
    
    func textField(_ textField: CustomTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: CustomTextField) {
        if textField.textInput.text?.isEmail ?? false {
            self.nextButton.isEnabled = true
        } else {
            self.nextButton.isEnabled = false
        }
    }
}
