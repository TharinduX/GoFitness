//
//  UserDetailsViewController.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-17.
//

import UIKit
import SnapKit
import Firebase

class UserDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "userdetails")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "User Details"
        label.font = UIFont(name: "IntegralCF-Bold", size: 30)
        label.textColor = .white
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Give us some more details about you!"
        label.font = UIFont(name: "IntegralCF-Bold", size: 15)
        label.textColor = UIColor(named: "primary")
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        return textField
    }()
    
    let nameErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: "OpenSans-Regular", size: 13)
        return label
    }()

    
    let heightTextField: NonEditableTextField = {
        let textField = NonEditableTextField()
        textField.placeholder = "Height (cm)"
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        return textField
    }()
    
    let heightErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: "OpenSans-Regular", size: 13)
        return label
    }()

    let heightPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    let heights = Array(100...250)
    
    let weightTextField: NonEditableTextField = {
        let textField = NonEditableTextField()
        textField.placeholder = "Weight (kg)"
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        return textField
    }()
    
    let weightErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: "OpenSans-Regular", size: 13)
        return label
    }()
    
    let weightPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    let weights = Array(30...200)
    
    let ageTextField: NonEditableTextField = {
        let textField = NonEditableTextField()
        textField.placeholder = "Age"
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        return textField
    }()
    
    let ageErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: "OpenSans-Regular", size: 13)
        return label
    }()
    
    let agePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    let ages = Array(10...99)
    
    let fitnessGoalTextField: NonEditableTextField = {
        let textField = NonEditableTextField()
        textField.placeholder = "Fitness Goal"
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        return textField
    }()
    
    let fitnessGoalErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(name: "OpenSans-Regular", size: 13)
        return label
    }()
    
    let fitnessGoalPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    let fitnessGoals = ["Lose weight", "Build muscle"]
    
    let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Complete Profile", for: .normal)
        button.titleLabel?.font = UIFont(name: "OpenSans-SemiBold", size: 17)
        button.setTitleColor(UIColor(named: "background"), for: .normal)
        button.backgroundColor = UIColor(named: "primary")
        button.layer.cornerRadius = 15
        button.layer.cornerCurve = .continuous
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(nameTextField)
        view.addSubview(heightTextField)
        view.addSubview(weightTextField)
        view.addSubview(fitnessGoalTextField)
        view.addSubview(ageTextField)
        view.addSubview(completeButton)
        
        view.addSubview(nameErrorLabel)
        view.addSubview(heightErrorLabel)
        view.addSubview(weightErrorLabel)
        view.addSubview(ageErrorLabel)
        view.addSubview(fitnessGoalErrorLabel)
        
        
        heightTextField.inputAccessoryView = createToolbar(for: heightTextField)
        weightTextField.inputAccessoryView = createToolbar(for: weightTextField)
        fitnessGoalTextField.inputAccessoryView = createToolbar(for: fitnessGoalTextField)
        ageTextField.inputAccessoryView = createToolbar(for: ageTextField)
        
        
        fitnessGoalTextField.inputView = fitnessGoalPickerView
        heightTextField.inputView = heightPickerView
        weightTextField.inputView = weightPickerView
        ageTextField.inputView = agePickerView
        
        fitnessGoalPickerView.delegate = self
        fitnessGoalPickerView.dataSource = self
        heightPickerView.delegate = self
        heightPickerView.dataSource = self
        weightPickerView.delegate = self
        weightPickerView.dataSource = self
        agePickerView.delegate = self
        agePickerView.dataSource = self
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(80)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
            make.height.equalTo(50)
        }
        
        nameErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(4)
            make.leading.equalTo(nameTextField)
            make.trailing.equalTo(nameTextField)
        }
        
        heightTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(nameTextField)
        }
        
        heightErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(heightTextField.snp.bottom).offset(4)
            make.leading.equalTo(heightTextField)
            make.trailing.equalTo(heightTextField)
        }
        
        weightTextField.snp.makeConstraints { make in
            make.top.equalTo(heightTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(nameTextField)
        }
        
        weightErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(weightTextField.snp.bottom).offset(4)
            make.leading.equalTo(weightTextField)
            make.trailing.equalTo(weightTextField)
        }
        
        fitnessGoalTextField.snp.makeConstraints { make in
            make.top.equalTo(weightTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(nameTextField)
        }
        
        fitnessGoalErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(fitnessGoalTextField.snp.bottom).offset(4)
            make.leading.equalTo(fitnessGoalTextField)
            make.trailing.equalTo(fitnessGoalTextField)
        }
        
        ageTextField.snp.makeConstraints { make in
            make.top.equalTo(fitnessGoalTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(nameTextField)
        }
        
        ageErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(ageTextField.snp.bottom).offset(4)
            make.leading.equalTo(ageTextField)
            make.trailing.equalTo(ageTextField)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(ageTextField.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(ageTextField)
            make.height.equalTo(55)
        }
        
        
        // Set up tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
    
    func createToolbar(for textField: UITextField) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        textField.inputAccessoryView = toolbar
        
        return toolbar
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == heightPickerView {
            return heights.count
        } else if pickerView == weightPickerView {
            return weights.count
        } else if pickerView == fitnessGoalPickerView {
            return fitnessGoals.count
        } else if pickerView == agePickerView {
            return ages.count
        }
        else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == heightPickerView {
            return "\(heights[row]) cm"
        } else if pickerView == weightPickerView {
            return "\(weights[row]) kg"
        } else if pickerView == fitnessGoalPickerView {
            return fitnessGoals[row]
        } else if pickerView == agePickerView {
            return "\(ages[row])"
        } else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == heightPickerView {
            let selectedHeight = heights[row]
            heightTextField.text = "\(selectedHeight)"
        } else if pickerView == weightPickerView {
            let selectedWeight = weights[row]
            weightTextField.text = "\(selectedWeight)"
        } else if pickerView == fitnessGoalPickerView {
            fitnessGoalTextField.text = fitnessGoals[row]
        } else if pickerView == agePickerView {
            let selectedAge = ages[row]
            ageTextField.text = "\(selectedAge)"
        }
    }
    
    class NonEditableTextField: UITextField {
        override func caretRect(for position: UITextPosition) -> CGRect {
            // Return an empty rectangle to hide the cursor
            return CGRect.zero
        }

        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            // Disable all text interaction actions (e.g., copy, paste, select, etc.)
            return false
        }
    }
    
    // Inside the action method for the "Complete Profile" button
    @objc func completeButtonTapped() {

        // Clear previous error messages
        clearErrorLabels()

        // Validate the user details
        guard let name = nameTextField.text, !name.isEmpty else {
            showErrorMessage("Please enter your name.", for: nameErrorLabel)
            return
        }

        guard let heightText = heightTextField.text, !heightText.isEmpty, let height = Double(heightText) else {
            showErrorMessage("Please select a height.", for: heightErrorLabel)
            return
        }

        guard let weightText = weightTextField.text, !weightText.isEmpty, let weight = Double(weightText) else {
            showErrorMessage("Please select a weight.", for: weightErrorLabel)
            return
        }

        guard let ageText = ageTextField.text, !ageText.isEmpty, let age = Int(ageText) else {
            showErrorMessage("Please select a age.", for: ageErrorLabel)
            return
        }

        guard let fitnessGoal = fitnessGoalTextField.text, !fitnessGoal.isEmpty else {
            showErrorMessage("Please select a fitness goal.", for: fitnessGoalErrorLabel)
            return
        }

        let bmi = calculateBMI(height: height, weight: weight)
        
        // Create UserDetails object
        let userDetails = UserDetails(
            userId: Auth.auth().currentUser?.uid ?? "",		
            name: name,
            height: height,
            weight: weight,
            age: age,
            fitnessGoal: fitnessGoal,
            bmi: bmi.bmi,
            bmiConsideration: bmi.consideration
        )
        
        ActivityIndicator.shared.show(in: view)
        // Save user details to Firebase
        FirebaseManager.shared.saveUserDetails(userDetails) { [weak self] error in
            
            ActivityIndicator.shared.hide()
            
            if let error = error {
                // Handle the error
                print("Error saving user details: \(error.localizedDescription)")
            } else {
                // User details saved successfully
                print("User details saved successfully")

                let homeVC = TabBarViewController()
                let navController = UINavigationController(rootViewController: homeVC)
                navController.modalPresentationStyle = .fullScreen
                self?.present(navController, animated: true, completion: nil)
            }
            
            // Update UI on the main queue
            DispatchQueue.main.async {
                self?.updateUIAfterSavingUserDetails(error: error)
            }
        }
    }

    private func clearErrorLabels() {
        nameErrorLabel.text = ""
        heightErrorLabel.text = ""
        weightErrorLabel.text = ""
        ageErrorLabel.text = ""
        fitnessGoalErrorLabel.text = ""
    }

    private func showErrorMessage(_ message: String, for errorLabel: UILabel) {
        errorLabel.text = message
    }

    private func updateUIAfterSavingUserDetails(error: Error?) {
        if let error = error {
            // Show error message or handle the error in some way
            print("Error occurred while saving user details: \(error.localizedDescription)")
        } else {
            // User details saved successfully
            print("User details saved successfully")
            
            // Perform any additional UI updates or navigate to the next screen
        }
    }
    
    private func calculateBMI(height: Double, weight: Double) -> (bmi: Double, consideration: String) {
        let heightInMeters = height / 100 // Convert height to meters
        let bmi = weight / (heightInMeters * heightInMeters)
        
        // Format the BMI value to two decimal points
        let formattedBMI = String(format: "%.2f", bmi)
        
        // Determine the BMI consideration based on the BMI value
        let consideration: String
        if bmi < 18.5 {
            consideration = "Underweight"
        } else if bmi < 25.0 {
            consideration = "Normal weight"
        } else if bmi < 30.0 {
            consideration = "Overweight"
        } else {
            consideration = "Obese"
        }
        
        // Convert the formatted BMI value back to a Double
        if let roundedBMI = Double(formattedBMI) {
            return (roundedBMI, consideration)
        } else {
            return (0.0, "Unknown") // Return default values if the conversion fails
        }
    }

    
}
