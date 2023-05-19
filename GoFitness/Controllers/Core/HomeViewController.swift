//
//  HomeViewController.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-10.
//

import UIKit
import SnapKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IntegralCF-Bold", size: 30)
        label.textColor = .white
        return label
    }()
    
    let greetingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-SemiBold", size: 17)
        label.textColor = UIColor(named: "primary")
        return label
    }()
    
    let goalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IntegralCF-Bold", size: 20)
        label.textColor = UIColor(named: "background")
        return label
    }()
    
    let bmiConsiderationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IntegralCF-Bold", size: 20)
        label.textColor = UIColor(named: "background")
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "homecard")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.cornerCurve = .continuous
        return imageView
    }()
    
    let exerciseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IntegralCF-Bold", size: 22)
        label.text = "Suggested Exercises"
        label.textColor = .white
        return label
    }()
    
    let exerciseSubLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-SemiBold", size: 15)
        label.text = "Let's get started to improve your fitness!"
        label.textColor = UIColor(named: "primary")
        return label
    }()
    
    private let collectionView: UICollectionView = {
          let layout = UICollectionViewFlowLayout()
          layout.scrollDirection = .horizontal
          let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
          // Configure other properties of the collection view
          return collectionView
      }()
    
    private var exercises: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        view.addSubview(titleLabel)
        view.addSubview(greetingLabel)
        view.addSubview(goalLabel)
        view.addSubview(imageView)
        view.addSubview(exerciseLabel)
        view.addSubview(exerciseSubLabel)
        
        view.bringSubviewToFront(goalLabel)
        collectionView.register(ExerciseCollectionViewCell.self, forCellWithReuseIdentifier: "ExerciseCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        greetingLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(15)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        goalLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).inset(48)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        exerciseLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        exerciseSubLabel.snp.makeConstraints { make in
            make.top.equalTo(exerciseLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        // Set up constraints for the collection view
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(exerciseSubLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(250)
        }
        
        
        // Fetch user's exercise plan from Firebase
        FirebaseManager.shared.getUserPlan { [weak self] planDetails, error in
            if let error = error {
                // Handle the error
                print("Error retrieving user details: \(error.localizedDescription)")
            } else if let planDetails = planDetails,
                      let planName = planDetails["name"] as? String,
                      let exercises = planDetails["exercises"] as? [[String: Any]] {
                // Store the exercises in the view controller
                self?.exercises = exercises
                
                // Update UI or perform further processing
                print("Plan Name: \(planName)")
                print("Exercises: \(exercises)")
                
                // Reload the collection view to display the exercises
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } else {
                // Handle the case where no matching plan is found
                print("No matching plan found.")
            }
        }
        
        
        // Fetch user details from Firebase
        FirebaseManager.shared.getUserDetails { [weak self] userDetails, error in
            if let error = error {
                // Handle the error
                print("Error retrieving user details: \(error.localizedDescription)")
            } else if let userDetails = userDetails,
                      let name = userDetails["name"] as? String,
                      let goal = userDetails["fitnessGoal"] as? String {
                // Update UI with user details
                self?.titleLabel.text = "Hello, \(name)"
                self?.goalLabel.text = "Goal: \(goal)"
            } else {
                // User details not found or user not logged in
                print("User details not found or user not logged in")
            }
        }
        
        updateGreeting()
    }
    
    private func updateGreeting() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let currentHour = Int(dateFormatter.string(from: Date())) ?? 0
        var greeting: String
        
        if currentHour >= 0 && currentHour < 12 {
            greeting = "Good morning!"
        } else if currentHour >= 12 && currentHour < 17 {
            greeting = "Good afternoon!"
        } else {
            greeting = "Good evening!"
        }
        
        greetingLabel.text = greeting
    }
    
    // Collection view data source methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of exercise cards you want to display
        return exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCollectionViewCell
        
        // Configure the exercise card cell
        let exercise = exercises[indexPath.item]
        if let exerciseTitle = exercise["name"] as? String,
           let exerciseImageURL = exercise["image"] as? String {
            cell.titleLabel.text = exerciseTitle
            // Load exercise image asynchronously from the imageURL and set it in the cell's image view
            // Example code:
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: URL(string: exerciseImageURL)!) {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    // Collection view delegate flow layout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return the desired size for each exercise card
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Return the desired inset for the section
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Return the desired minimum line spacing for the section
        return 10
    }

}


