//
//  SignUpViewController.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-16.
//

import UIKit
import SnapKit
import Firebase

class SignUpViewController: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "signup-bg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to GoFitness"
        label.font = UIFont(name: "IntegralCF-Regular", size: 20)
        label.textColor = UIColor(named: "primary")
        label.textAlignment = .left
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.font = UIFont(name: "IntegralCF-Bold", size: 60)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    // Error label
    let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: "OpenSans-Regular", size: 13)
        label.textAlignment = .left
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.isSecureTextEntry = true
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        return textField
    }()
    
    let rePasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Retype Password"
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.isSecureTextEntry = true
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont(name: "OpenSans-SemiBold", size: 17)
        button.setTitleColor(UIColor(named: "background"), for: .normal)
        button.backgroundColor = UIColor(named: "primary")
        button.layer.cornerRadius = 15
        button.layer.cornerCurve = .continuous
        return button
    }()
    
    let googleSignUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up with Google", for: .normal)
        let googleImage = UIImage(named: "google")?.withRenderingMode(.alwaysOriginal)
        button.setImage(googleImage, for: .normal)
        button.titleLabel?.font = UIFont(name: "OpenSans-SemiBold", size: 17)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.cornerCurve = .continuous
        
        return button
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private var keyboardHeight: CGFloat = 0
    private var isKeyboardShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        view.addSubview(imageView)
        view.addSubview(subtitleLabel)
        view.addSubview(titleLabel)
        view.addSubview(errorLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(rePasswordTextField)
        view.addSubview(signUpButton)
        view.addSubview(googleSignUpButton)
        
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(80)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
            make.height.equalTo(50)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.bottom.equalTo(emailTextField.snp.top).offset(-5)
            make.leading.equalTo(emailTextField)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(emailTextField)
            make.height.equalTo(50)
        }
        
        rePasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(emailTextField)
            make.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(rePasswordTextField.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(rePasswordTextField)
            make.height.equalTo(55)
        }
        
        googleSignUpButton.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(signUpButton)
            make.height.equalTo(55)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
        if isKeyboardShown {
            isKeyboardShown = false
            UIView.animate(withDuration: 0.25) {
                self.view.frame.origin.y += self.keyboardHeight / 2
            }
        }
    }
    
    @objc private func signUpButtonTapped() {
     
        var errorMessage: String
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let rePassword = rePasswordTextField.text else {
            // Handle invalid input
            return
        }
        
        // Check if the password and rePassword match
        guard password == rePassword else {
  
            // Handle password mismatch
            errorMessage = "Password and Re-entered Password do not match."
            self.errorLabel.text = errorMessage
            return
        }

        // Call the sign-up method
        AuthManager.shared.signUp(withEmail: email, password: password) { [weak self] error in
            if let maybeError = error {
                let nsError = maybeError as NSError
                if let errorCode = AuthErrorCode.Code.init(rawValue: nsError.code) {
                    var errorMessage: String
                    
                    // Handle specific error cases and provide custom error messages
                    switch errorCode {
                    case .invalidEmail:
                        errorMessage = "Invalid email address. Please enter a valid email."
                    case .emailAlreadyInUse:
                        errorMessage = "Email already in use."
                    case .weakPassword:
                        errorMessage = "Weak password. Please choose a stronger password."
                        // Handle other error cases as needed
                    default:
                        errorMessage = "An error occurred. Please try again later."
                    }
                    // Display the custom error message
                    self?.errorLabel.text = errorMessage
                }
                
            } else {
                // Reset error label if sign-up is successful
                self?.errorLabel.text = nil
                
                // Sign up successful
                let homeVC = UserDetailsViewController()
                let navController = UINavigationController(rootViewController: homeVC)
                navController.modalPresentationStyle = .fullScreen
                self?.present(navController, animated: true, completion: nil)
            }
        }
    }
    
    //Handling the keyboard - otherwise the text field not visible
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let keyboardHeight = keyboardSize.height
        if !isKeyboardShown {
            isKeyboardShown = true
            self.keyboardHeight = keyboardHeight
            UIView.animate(withDuration: 0.25) {
                self.view.frame.origin.y -= self.keyboardHeight / 2
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if isKeyboardShown {
            isKeyboardShown = false
            UIView.animate(withDuration: 0.25) {
                self.view.frame.origin.y += self.keyboardHeight / 2
            }
        }
    }
}
