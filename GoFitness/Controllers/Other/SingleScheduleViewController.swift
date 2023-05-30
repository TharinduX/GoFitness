    //
    //  SingleScheduleViewController.swift
    //  GoFitness
    //
    //  Created by Tharindu on 2023-05-21.
    //

    import UIKit
    import SnapKit
    import Firebase

    class SingleScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
        var plan: [String: Any]?
        var planID: String?
        let refreshControl = UIRefreshControl()
        
        //setup views
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "IntegralCF-Bold", size: 30)
            label.textColor = .white
            return label
        }()
        
        let subtitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "OpenSans-SemiBold", size: 15)
            label.textColor = UIColor(named: "primary")
            return label
        }()
        
        let buttonContainerView: UIView = {
            let view = UIView()
            return view
        }()
        
        let deleteButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "trash"), for: .normal)
            button.tintColor = .white
            button.backgroundColor = .systemRed
            button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            
            return button
        }()
        
        let newButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "plus"), for: .normal)
            button.tintColor = UIColor(named: "background")
            button.backgroundColor = UIColor(named: "primary")
            button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            
            return button
        }()
        
        let exercisesTableView: UITableView = {
            let tableView = UITableView()
            tableView.separatorStyle = .none
            tableView.backgroundColor = UIColor(named: "background")
            tableView.register(ExerciseTableViewCell.self, forCellReuseIdentifier: "ExerciseCell")
            return tableView
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = UIColor(named: "background")
            setupViews()
            configureLabels()
            setupTableView()
        }
        
        private func setupViews() {

            view.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(100)
                make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            }
            
            view.addSubview(subtitleLabel)
            subtitleLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            }
            
            view.addSubview(exercisesTableView)
            exercisesTableView.snp.makeConstraints { make in
                make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
                make.leading.trailing.bottom.equalToSuperview()
            }
            
            view.addSubview(buttonContainerView)
            buttonContainerView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(100)
                make.trailing.equalToSuperview().offset(-10)
            }
            
            buttonContainerView.addSubview(newButton)
            buttonContainerView.addSubview(deleteButton)

            newButton.snp.makeConstraints { make in
                make.top.leading.bottom.equalToSuperview()
                make.height.width.equalTo(30)
            }

            deleteButton.snp.makeConstraints { make in
                make.leading.equalTo(newButton.snp.trailing).offset(10)
                make.top.trailing.bottom.equalToSuperview()
                make.width.equalTo(newButton)
            }
            
            newButton.addTarget(self, action: #selector(newButtonTapped), for: .touchUpInside)
            deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)	
        }
        
        //new button tap handler
        @objc private func newButtonTapped() {
            let exerciseAddViewController = ExerciseAddViewController()
            exerciseAddViewController.plan = self.plan
            navigationController?.pushViewController(exerciseAddViewController, animated: true)
        }
        
        //delete button handler
        @objc private func deleteButtonTapped() {
            guard let planName = plan?["name"] as? String else {
                return
            }
            
            ActivityIndicator.shared.show(in: view)
            FirebaseManager.shared.deletePlan(with: planName) { [weak self] error in
                guard let self = self else {
                    return
                }
                
                if let error = error {
                    print("Error deleting plan: \(error.localizedDescription)")
                } else {
                    print("Plan deleted successfully")
                    // Refresh the home screen
                    DispatchQueue.main.async {
                        if let homeViewController = self.navigationController?.viewControllers.first as? HomeViewController {
                            homeViewController.fetchCustomPlans()
                        }
                        self.navigateToRoot()
                    }
                }
            }
        }
        
        
        //pull to refresh handling
        @objc private func refreshData() {
            
            refreshControl.endRefreshing()
            exercisesTableView.reloadData()
        }

            
        private func navigateToRoot() {
            // Navigate to the home screen
            self.navigationController?.popToRootViewController(animated: true)
            ActivityIndicator.shared.hide()
        }

        //labels text
        private func configureLabels() {
            titleLabel.text = plan?["name"] as? String
            subtitleLabel.text = plan?["description"] as? String
            
        }
        
        private func setupTableView() {
            exercisesTableView.dataSource = self
            exercisesTableView.delegate = self
            exercisesTableView.addSubview(refreshControl)
            
            // Configure the refresh control
            refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            guard let exercises = plan?["exercises"] as? [[String: Any]] else {
                return 0
            }
            return exercises.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as? ExerciseTableViewCell else {
                return UITableViewCell()
            }
            
            if let exercises = plan?["exercises"] as? [[String: Any]] {
                let exercise = exercises[indexPath.row]
                cell.configure(with: exercise, navigationController: navigationController)
            }
            
            cell.backgroundColor = UIColor(named: "background")
            return cell
        }

        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            exercisesTableView.reloadData()
        }
    }
