//
//  AuthViewController.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-10.
//

import UIKit
import SnapKit
import Firebase

class AuthViewController: UIViewController {
    
    // Background image view
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Subtitle label
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back!"
        label.font = UIFont(name: "IntegralCF-Regular", size: 20)
        label.textColor = UIColor(named: "primary")
        label.textAlignment = .left
        return label
    }()
    
    // Title label
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
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
    
    // Email text field
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        return textField
    }()
    
    // Password text field
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.isSecureTextEntry = true
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        return textField
    }()
    
    // Login button
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont(name: "OpenSans-SemiBold", size: 17)
        button.setTitleColor(UIColor(named: "background"), for: .normal)
        button.backgroundColor = UIColor(named: "primary")
        button.layer.cornerRadius = 15
        button.layer.cornerCurve = .continuous
        return button
    }()
    
    // Google login button
    let googleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login with Google", for: .normal)
        let googleImage = UIImage(named: "google")?.withRenderingMode(.alwaysOriginal)
        button.setImage(googleImage, for: .normal)
        button.titleLabel?.font = UIFont(name: "OpenSans-SemiBold", size: 17)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.cornerCurve = .continuous
        return button
    }()
    
    // Forgot password label
    let forgetPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password?"
        label.font = UIFont(name: "OpenSans-SemiBold", size: 13)
        label.textColor = UIColor(named: "primary")
        label.textAlignment = .center
        return label
    }()
    
    // Scroll view
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    // Keyboard variables
    private var keyboardHeight: CGFloat = 0
    private var isKeyboardShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the view
        view.backgroundColor = UIColor(named: "background")
        view.addSubview(imageView)
        view.addSubview(subtitleLabel)
        view.addSubview(titleLabel)
        view.addSubview(errorLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(googleLoginButton)
        view.addSubview(forgetPasswordLabel)
        
        
        // Configure constraints
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(235)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(250)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(50)
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
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(passwordTextField)
            make.height.equalTo(55)
        }
        
        googleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(loginButton)
            make.height.equalTo(55)
        }
        
        forgetPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(googleLoginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(loginButton)
        }
        
        // Add observers for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Set up navigation bar
        let signUpButton = UIBarButtonItem(title: "Sign Up", style: .plain, target: self, action: #selector(signUpButtonTapped))
        navigationItem.rightBarButtonItem = signUpButton
        
        // Set up tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        // Add login button action
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
    }
    
    // Dismiss the keyboard and adjust view position if the keyboard is shown
    @objc private func handleTap() {
        view.endEditing(true)
        if isKeyboardShown {
            isKeyboardShown = false
            UIView.animate(withDuration: 0.25) {
                self.view.frame.origin.y += self.keyboardHeight / 2
            }
        }
    }
    
    // Perform login with the provided email and password
    @objc private func loginButtonTapped() {
        ActivityIndicator.shared.show(in: view)
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            // Handle invalid input
            return
        }
        
        AuthManager.shared.signIn(withEmail: email, password: password) { [weak self] error in
        
            ActivityIndicator.shared.hide()
            if let maybeError = error {
                let nsError = maybeError as NSError
                if let errorCode = AuthErrorCode.Code.init(rawValue: nsError.code) {
                    var errorMessage: String
        
                    // Handle specific error cases and provide custom error messages
                    switch errorCode {
                    case .invalidEmail:
                        errorMessage = "Invalid email address. Please enter a valid email."
                    case .wrongPassword:
                        errorMessage = "Incorrect password. Please try again."
                    case .userNotFound:
                        errorMessage = "User not found. Please sign up before logging in."
                        // Handle other error cases as needed
                    default:
                        errorMessage = "An error occurred. Please try again later."
                    }
                    // Display the custom error message
                    self?.errorLabel.text = errorMessage
                }
                
            } else {
                // Reset error label if login is successful
                self?.errorLabel.text = nil
                
                // Login successful
                let homeVC = TabBarViewController()
                let navController = UINavigationController(rootViewController: homeVC)
                navController.modalPresentationStyle = .fullScreen
                self?.present(navController, animated: true, completion: nil)
            }
        }
    }
    
    // Push the sign-up view controller onto the navigation stack
    @objc private func signUpButtonTapped() {
        let SignUpVC = SignUpViewController()
        self.navigationController?.pushViewController(SignUpVC, animated: true)
    }
    
    // Adjust the view position when the keyboard is shown
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
    
    // Reset the view position when the keyboard is hidden
    @objc private func keyboardWillHide(_ notification: Notification) {
        if isKeyboardShown {
            isKeyboardShown = false
            UIView.animate(withDuration: 0.25) {
                self.view.frame.origin.y += self.keyboardHeight / 2
            }
        }
    }
    
}

