//
//  SingleScheduleViewController.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-21.
//

import UIKit
import SnapKit

class SingleScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var plan: [String: Any]?
    
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
        
        view.addSubview(newButton)
        newButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-10)
            make.height.width.equalTo(30)
        }
        newButton.addTarget(self, action: #selector(newButtonTapped), for: .touchUpInside)
    }
    
    @objc private func newButtonTapped() {
        let exerciseAddViewController = ExerciseAddViewController()
        navigationController?.pushViewController(exerciseAddViewController, animated: true)
    }
    
    private func configureLabels() {
        titleLabel.text = plan?["name"] as? String
        subtitleLabel.text = plan?["description"] as? String
        
    }
    
    private func setupTableView() {
        exercisesTableView.dataSource = self
        exercisesTableView.delegate = self
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
        
        return cell
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        exercisesTableView.reloadData()
    }
}
