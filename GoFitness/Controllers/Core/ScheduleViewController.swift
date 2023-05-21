//
//  ScheduleViewController.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-20.
//

import UIKit
import SnapKit
import Firebase

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var plans: [[String: Any]] = []
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "All Schedules"
        label.font = UIFont(name: "IntegralCF-Bold", size: 30)
        label.textColor = .white
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "All avaialable schedules"
        label.font = UIFont(name: "IntegralCF-Regular", size: 20)
        label.textColor = UIColor(named: "primary")
        return label
    }()
    
    let planTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "background")
        tableView.separatorStyle = .none
        tableView.register(CustomPlanTableViewCell.self, forCellReuseIdentifier: "CustomPlansCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(planTableView)
        setupTableView()
        fetchCustomPlans()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        planTableView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    
    private func setupTableView() {
        planTableView.dataSource = self
        planTableView.delegate = self
    }
    
    private func fetchCustomPlans() {
        FirebaseManager.shared.getCustomPlans { [weak self] plans, error in
            if let error = error {
                print("Error retrieving plans: \(error.localizedDescription)")
            } else if let plans = plans, !plans.isEmpty {
                self?.plans = plans
                DispatchQueue.main.async {
                    self?.planTableView.reloadData()
                }
            } else {
                print("No plans found for the user.")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomPlansCell", for: indexPath) as? CustomPlanTableViewCell else {
            return UITableViewCell()
        }

        let plan = plans[indexPath.row]
        cell.configure(with: plan, navigationController: navigationController)
        
        cell.backgroundColor = UIColor(named: "background")
        return cell
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        planTableView.reloadData()
    }

}
