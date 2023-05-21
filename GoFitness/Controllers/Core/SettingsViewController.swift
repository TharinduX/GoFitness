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
        label.font = UIFont(name: "OpenSans-Regular", size: 17)
        label.textColor = .white
        return label
    }()
    
    let heightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Regular", size: 17)
        label.textColor = .white
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Regular", size: 17)
        label.textColor = .white
        return label
    }()
    
    let ageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Regular", size: 17)
        label.textColor = .white
        return label
    }()
    
    let fitnessGoalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Regular", size: 17)
        label.textColor = .white
        return label
    }()
    
    let bmiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Regular", size: 17)
        label.textColor = .white
        return label
    }()
    
    let bmiConsiderationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Regular", size: 17)
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(logoutButton)
        view.addSubview(nameLabel)
        view.addSubview(heightLabel)
        view.addSubview(weightLabel)
        view.addSubview(ageLabel)
        view.addSubview(fitnessGoalLabel)
        view.addSubview(bmiLabel)
        view.addSubview(bmiConsiderationLabel)
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        heightLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(heightLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(weightLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        fitnessGoalLabel.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        bmiLabel.snp.makeConstraints { make in
            make.top.equalTo(fitnessGoalLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        bmiConsiderationLabel.snp.makeConstraints { make in
            make.top.equalTo(bmiLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(bmiConsiderationLabel.snp.bottom).offset(10)
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
                    self?.nameLabel.text = "Name: \(name)"
                    self?.heightLabel.text = "Height: \(height) cm"
                    self?.weightLabel.text = "Weight: \(weight) kg"
                    self?.ageLabel.text = "Age: \(age)"
                    self?.fitnessGoalLabel.text = "Fitness Goal: \(fitnessGoal)"
                    self?.bmiLabel.text = "BMI: \(bmi)"
                    self?.bmiConsiderationLabel.text = "BMI Consideration: \(bmiConsideration)"
                }
            } else {
                print("User details not found or user not logged in")
            }
        }
    }

}
