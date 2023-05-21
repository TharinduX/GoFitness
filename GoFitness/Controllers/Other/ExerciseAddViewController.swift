//
//  ExerciseAddViewController.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-21.
//

import UIKit
import SnapKit
import Firebase

class ExerciseAddViewController: UIViewController {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Custom Schedule"
        label.font = UIFont(name: "IntegralCF-Bold", size: 30)
        label.textColor = .white
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add custom schedule"
        label.font = UIFont(name: "IntegralCF-Regular", size: 20)
        label.textColor = UIColor(named: "primary")
        return label
    }()
    
    let exerciseTextField: NonEditableTextField = {
        let textField = NonEditableTextField()
        textField.placeholder = "Select an exercise"
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        return textField
    }()
    
    let exercisePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    let repsTextField: NonEditableTextField = {
        let textField = NonEditableTextField()
        textField.placeholder = "Reps count"
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        return textField
    }()
    
    let repsPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    let reps = Array(1...50)
    
    let setsTextField: NonEditableTextField = {
        let textField = NonEditableTextField()
        textField.placeholder = "Sets count"
        textField.font = UIFont(name: "OpenSans-Regular", size: 17)
        textField.textColor = .white
        textField.addBottomBorder(color: UIColor(named: "bg-secondary") ?? .darkGray, height: 1)
        return textField
    }()
    
    let setsPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    let sets = Array(1...10)
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Schedule", for: .normal)
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
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(exerciseTextField)
        view.addSubview(repsTextField)
        view.addSubview(setsTextField)
        view.addSubview(saveButton)
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        exerciseTextField.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
            make.height.equalTo(50)
        }
        
        repsTextField.snp.makeConstraints { make in
            make.top.equalTo(exerciseTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(exerciseTextField)
        }
        
        setsTextField.snp.makeConstraints { make in
            make.top.equalTo(repsTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(exerciseTextField)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(setsTextField.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(exerciseTextField)
            make.height.equalTo(55) 
        }
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
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
    

    
}
