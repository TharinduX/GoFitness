//
//  ExerciseAddViewController.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-21.
//

import UIKit
import SnapKit
import Firebase

class ExerciseAddViewController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    var plan: [String: Any]?

    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Exercises"
        label.font = UIFont(name: "IntegralCF-Bold", size: 30)
        label.textColor = .white
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add exercises to plan"
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
    
    var exercisePickerData: [Exercise] = [] 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchExercises()
        view.backgroundColor = UIColor(named: "background")
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(exerciseTextField)
        view.addSubview(repsTextField)
        view.addSubview(setsTextField)
        view.addSubview(saveButton)
        
        exerciseTextField.inputAccessoryView = createToolbar(for: exerciseTextField)
        exerciseTextField.inputView = exercisePickerView
        exercisePickerView.delegate = self
        exercisePickerView.dataSource = self
        
        repsTextField.inputAccessoryView = createToolbar(for: repsTextField)
        repsTextField.inputView = repsPickerView
        repsPickerView.delegate = self
        repsPickerView.dataSource = self
        
        setsTextField.inputAccessoryView = createToolbar(for: setsTextField)
        setsTextField.inputView = setsPickerView
        setsPickerView.delegate = self
        setsPickerView.dataSource = self
        
        
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
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
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
    
    func fetchExercises() {
        FirebaseManager.shared.fetchExercisesFromFirestore { [weak self] (exercises, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching exercises: \(error.localizedDescription)")
                return
            }
            
            if let exercises = exercises {
                self.exercisePickerData = exercises.map { $0.1 }
                self.exercisePickerView.reloadAllComponents()
            }
        }
    }

    
    @objc func saveButtonTapped() {
        
        
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
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == exercisePickerView {
            return exercisePickerData.count
        } else if pickerView == repsPickerView {
            return reps.count
        }else if pickerView == setsPickerView {
            return sets.count
        } else {
            return 0
        }
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == exercisePickerView {
            return exercisePickerData[row].name
        } else if pickerView == repsPickerView {
            return "\(reps[row])"
        } else if pickerView == setsPickerView {
            return "\(sets[row])"
        }else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == exercisePickerView {
            let selectedExercise = exercisePickerData[row]
            exerciseTextField.text = selectedExercise.name
        } else if pickerView == repsPickerView {
            let selectedRep = reps[row]
            repsTextField.text = "\(selectedRep)"
        }else if pickerView == setsPickerView {
            let selectedSet = sets[row]
            setsTextField.text = "\(selectedSet)"
        }
    }
    

    
}
