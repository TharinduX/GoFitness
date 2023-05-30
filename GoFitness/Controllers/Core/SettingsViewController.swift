//
//  SettingsViewController.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-10.
//

import UIKit
import SnapKit
import Firebase

class SettingsViewController: UIViewController {
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont(name: "IntegralCF-Bold", size: 30)
        label.textColor = .white
        return label
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.titleLabel?.font = UIFont(name: "OpenSans-SemiBold", size: 17)
        button.setTitleColor(UIColor(named: "background"), for: .normal)
        button.backgroundColor = UIColor(named: "primary")
        button.layer.cornerRadius = 15
        button.layer.cornerCurve = .continuous
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont(name: "OpenSans-Regular", size: 17)
        label.textColor = UIColor(named: "primary")
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "Height"
        label.font = UIFont(name: "OpenSans-Regular", size: 17)
        label.textColor = UIColor(named: "primary")
        return label
    }()
    
    let heightTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "Weight"
        label.font = UIFont(name: "OpenSans-Regular", size: 17)
        label.textColor = UIColor(named: "primary")
        return label
    }()
    
    let weightTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Age"
        label.font = UIFont(name: "OpenSans-Regular", size: 17)
        label.textColor = UIColor(named: "primary")
        return label
    }()
    
    let ageTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let fitnessGoalLabel: UILabel = {
        let label = UILabel()
        label.text = "Fitness Goal"
        label.font = UIFont(name: "OpenSans-Regular", size: 17)
        label.textColor = UIColor(named: "primary")
        return label
    }()
    
    let fitnessGoalTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let bmiLabel: UILabel = {
        let label = UILabel()
        label.text = "BMI"
        label.font = UIFont(name: "OpenSans-Regular", size: 17)
        label.textColor = UIColor(named: "primary")
        return label
    }()
    
    let bmiTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let bmiConsiderationLabel: UILabel = {
        let label = UILabel()
        label.text = "BMI Consideration"
        label.font = UIFont(name: "OpenSans-Regular", size: 17)
        label.textColor = UIColor(named: "primary")
        return label
    }()
    
    let bmiConsiderationTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        view.addSubview(titleLabel)
        view.backgroundColor = UIColor(named: "background")
        scrollView.addSubview(logoutButton)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(heightLabel)
        scrollView.addSubview(heightTextField)
        scrollView.addSubview(weightLabel)
        scrollView.addSubview(weightTextField)
        scrollView.addSubview(ageLabel)
        scrollView.addSubview(ageTextField)
        scrollView.addSubview(fitnessGoalLabel)
        scrollView.addSubview(fitnessGoalTextField)
        scrollView.addSubview(bmiLabel)
        scrollView.addSubview(bmiTextField)
        scrollView.addSubview(bmiConsiderationLabel)
        scrollView.addSubview(bmiConsiderationTextField)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(50)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(30)
        }
        
        heightLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(50)
        }
        
        heightTextField.snp.makeConstraints { make in
            make.top.equalTo(heightLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(30)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(heightTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(50)
        }
        
        weightTextField.snp.makeConstraints { make in
            make.top.equalTo(weightLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(30)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(weightTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(50)
        }
        
        ageTextField.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(30)
        }
        
        fitnessGoalLabel.snp.makeConstraints { make in
            make.top.equalTo(ageTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(50)
        }
        
        fitnessGoalTextField.snp.makeConstraints { make in
            make.top.equalTo(fitnessGoalLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(30)
        }
        
        bmiLabel.snp.makeConstraints { make in
            make.top.equalTo(fitnessGoalTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(50)
        }
        
        bmiTextField.snp.makeConstraints { make in
            make.top.equalTo(bmiLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(30)
        }
        
        bmiConsiderationLabel.snp.makeConstraints { make in
            make.top.equalTo(bmiTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(50)
        }
        
        bmiConsiderationTextField.snp.makeConstraints { make in
            make.top.equalTo(bmiConsiderationLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(30)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(bmiConsiderationTextField.snp.bottom).offset(30)
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
        }
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        fetchUserDetails()
    }
    
    @objc private func logoutButtonTapped() {
        ActivityIndicator.shared.show(in: view)
        do {
            try Auth.auth().signOut()
            ActivityIndicator.shared.hide()
            navigateToLoginScreen()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    private func navigateToLoginScreen() {
        // Example: If you have a LoginViewController, you can navigate to it using a navigation controller
        let loginVC = AuthViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    private func fetchUserDetails() {
        FirebaseManager.shared.getUserDetails { [weak self] userDetails, error in
            if let error = error {
                
                print("Error retrieving user details: \(error.localizedDescription)")
            } else if let userDetails = userDetails,
                      let name = userDetails["name"] as? String,
                      let height = userDetails["height"] as? Double,
                      let weight = userDetails["weight"] as? Double,
                      let age = userDetails["age"] as? Int,
                      let fitnessGoal = userDetails["fitnessGoal"] as? String,
                      let bmi = userDetails["bmi"] as? Double,
                      let bmiConsideration = userDetails["bmiConsideration"] as? String {
                DispatchQueue.main.async {
                    // Update UI with user details
                    self?.nameTextField.text = name
                    self?.heightTextField.text = String(height)
                    self?.weightTextField.text = String(weight)
                    self?.ageTextField.text = String(age)
                    self?.fitnessGoalTextField.text = fitnessGoal
                    self?.bmiTextField.text = String(bmi)
                    self?.bmiConsiderationTextField.text = bmiConsideration
                }
            } else {
                print("User details not found or user not logged in")
            }
        }
    }

}
