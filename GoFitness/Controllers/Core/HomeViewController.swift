//
//  HomeViewController.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-10.
//

import UIKit
import SnapKit
import Firebase
import CoreMotion

private let stepCountKey = "StepCount"

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate  {
    
    private let pedometer = CMPedometer()
    private var lastStepCount: Int?
    private var stepCount: Int = 0 {
        didSet {
            stepCountLabel.text = "Steps: \(stepCount) steps"
            UserDefaults.standard.set(stepCount, forKey: stepCountKey)
        }
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
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
    
    let stepCountContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "primary")
        return view
    }()
    
    let stepCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IntegralCF-Bold", size: 15)
        label.text = "Steps:()"
        label.textColor = UIColor(named: "background")
        label.textAlignment = .center
        return label
    }()
    
    let exerciseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IntegralCF-Bold", size: 22)
        label.text = "Suggested Fitness Plan"
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
    
    let planLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IntegralCF-Bold", size: 22)
        label.text = "Custom Fitness plans"
        label.textColor = .white
        return label
    }()
    
    let planSubLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-SemiBold", size: 15)
        label.text = "Check out the fitness plans you created!"
        label.textColor = UIColor(named: "primary")
        return label
    }()
    
    private let planCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    
    private var exercises: [[String: Any]] = []
    private var plans: [[String: Any]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "background")
        navigationController?.navigationBar.isHidden = true
        
        
        let savedStepCount = UserDefaults.standard.integer(forKey: stepCountKey)
        stepCount = savedStepCount
        
        if CMPedometer.isStepCountingAvailable() {
            startStepCounting()
        } else {
            print("Step counting is not available.")
        }
        
        
        setupViews()
        fetchUserDetails()
        updateGreeting()
        fetchSuggestedPlan()
        fetchCustomPlans()
        
    }
    
    //setup views
    private func setupViews(){
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalTo(scrollView.safeAreaLayoutGuide).offset(20)
        }
        
        scrollView.addSubview(greetingLabel)
        greetingLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(scrollView.safeAreaLayoutGuide).offset(20)
        }
        
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(15)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(20)
        }
        
        imageView.addSubview(stepCountContainerView)
        stepCountContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        stepCountContainerView.addSubview(stepCountLabel)
        stepCountLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8).priority(.low)
            make.trailing.equalToSuperview().offset(-8).priority(.low)
        }
        
        view.bringSubviewToFront(goalLabel)
        imageView.addSubview(goalLabel)
        goalLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).inset(48)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(30)
        }
        
        scrollView.addSubview(exerciseLabel)
        exerciseLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(20)
        }
        
        scrollView.addSubview(exerciseSubLabel)
        exerciseSubLabel.snp.makeConstraints { make in
            make.top.equalTo(exerciseLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(20)
        }
        
        scrollView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(exerciseSubLabel.snp.bottom).offset(15)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide)
            make.width.equalTo(scrollView)
            make.height.equalTo(200)
        }
        collectionView.register(ExerciseCollectionViewCell.self, forCellWithReuseIdentifier: "ExerciseCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        scrollView.addSubview(planLabel)
        planLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(20)
        }
        
        scrollView.addSubview(planSubLabel)
        planSubLabel.snp.makeConstraints { make in
            make.top.equalTo(planLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide).inset(20)
        }
        
        scrollView.addSubview(planCollectionView)
        planCollectionView.snp.makeConstraints { make in
            make.top.equalTo(planSubLabel.snp.bottom).offset(15)
            make.leading.trailing.equalTo(scrollView.safeAreaLayoutGuide)
            make.width.equalTo(scrollView)
            make.height.equalTo(200)
        }
        
        planCollectionView.register(PlanCollectionViewCell.self, forCellWithReuseIdentifier: "PlanCell")
        planCollectionView.dataSource = self
        planCollectionView.delegate = self
        
        self.view.layoutIfNeeded()
        let contentHeight = planCollectionView.frame.origin.y + planCollectionView.frame.height + 20
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentHeight)
        collectionView.backgroundColor = UIColor(named: "background")
        planCollectionView.backgroundColor = UIColor(named: "background")
        
    }
    
    // Fetch suggested plan from Firebase
    private func fetchSuggestedPlan() {
        FirebaseManager.shared.getUserPlan { [weak self] planDetails, error in
            if let error = error {
                print("Error retrieving user details: \(error.localizedDescription)")
            } else if let planDetails = planDetails,
                      let exercises = planDetails["exercises"] as? [[String: Any]] {
                self?.exercises = exercises
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } else {
                print("No matching plan found.")
            }
        }
    }
    // Fetch user details from Firebase
    private func fetchUserDetails() {
        FirebaseManager.shared.getUserDetails { [weak self] userDetails, error in
            if let error = error {
                print("Error retrieving user details: \(error.localizedDescription)")
            } else if let userDetails = userDetails,
                      let name = userDetails["name"] as? String,
                      let goal = userDetails["fitnessGoal"] as? String {
                // Update UI with user details
                self?.titleLabel.text = "Hello, \(name)"
                self?.goalLabel.text = "Goal: \(goal)"
            } else {
                print("User details not found or user not logged in")
            }
        }
    }
    
    // Fetch custom plans from Firebase
    private func fetchCustomPlans() {
        FirebaseManager.shared.getCustomPlans { [weak self] plans, error in
            if let error = error {
                print("Error retrieving plans: \(error.localizedDescription)")
            } else if let plans = plans, !plans.isEmpty {
                self?.plans = plans
                DispatchQueue.main.async {
                    self?.planCollectionView.reloadData()
                }
            } else {
                print("No plans found for the user.")
            }
        }
    }
    
    private func startStepCounting() {
        pedometer.startUpdates(from: Date()) { [weak self] (data, error) in
            guard let data = data, error == nil else {
                print("Error starting step counting: \(error?.localizedDescription ?? "")")
                return
            }

            DispatchQueue.main.async {
                let steps = data.numberOfSteps.intValue
                let stepsSinceLastUpdate = steps - (self?.lastStepCount ?? steps)
                self?.lastStepCount = steps
                self?.stepCount += stepsSinceLastUpdate
            }
        }
    }
    
    
    private func saveStepCount(_ count: Int) {
        UserDefaults.standard.set(count, forKey: "StepCount")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pedometer.stopUpdates()
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let detailViewController = ExerciseDetailViewController()
            let selectedExercise = exercises[indexPath.item]
            detailViewController.exercise = selectedExercise
            navigationController?.pushViewController(detailViewController, animated: true)
        } else if collectionView == self.planCollectionView {
            let scheduleController = SingleScheduleViewController()
            let selectedSchedule = plans[indexPath.item]
            scheduleController.plan = selectedSchedule
            navigationController?.pushViewController(scheduleController, animated: true)
        }
    }
    
    // Collection view data source methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return exercises.count
        } else if collectionView == self.planCollectionView {
            return plans.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCollectionViewCell
            
            let exercise = exercises[indexPath.item]
            if let exerciseTitle = exercise["name"] as? String,
               let exerciseImageURL = exercise["image"] as? String {
                cell.titleLabel.text = exerciseTitle
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
        } else if collectionView == self.planCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanCell", for: indexPath) as! PlanCollectionViewCell
            
            let plan = plans[indexPath.item]
            if let planName = plan["name"] as? String {
                cell.titleLabel.text = planName
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
}




