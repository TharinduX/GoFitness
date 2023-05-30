//
//  CustomPlanTableViewCell.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-21.
//

import UIKit

class CustomPlanTableViewCell: UITableViewCell {
    
    var plan: [String: Any]?
    var navigationController: UINavigationController?
    
    func setNavigationController(_ navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    let boxView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "bg-secondary")
        view.layer.cornerRadius = 10
        return view
    }()
    
    let planNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IntegralCF-Bold", size: 20)
        label.textColor = UIColor(named: "primary")
        label.textAlignment = .left
        return label
    }()
    
    
    let planDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Regular", size: 12)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        self.contentView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(boxView)
        boxView.addSubview(planNameLabel)
        boxView.addSubview(planDescriptionLabel)
        
        boxView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            make.height.equalTo(100)
        }
        
        planNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        planDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(planNameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        
    }
    
    //cell tapped
    @objc private func cellTapped() {
        if let plan = plan,
           let navigationController = navigationController {
            let detailViewController = SingleScheduleViewController()
            detailViewController.plan = plan
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    //configure the custom plan table view
    func configure(with plan: [String: Any], navigationController: UINavigationController?) {
        self.plan = plan
        self.navigationController = navigationController
        
        if let name = plan["name"] as? String,
           let description = plan["description"] as? String {
            planNameLabel.text = name
            
            let maxDescriptionLength = 100
            if description.count > maxDescriptionLength {
                let truncatedDescription = String(description.prefix(maxDescriptionLength)) + "..."
                planDescriptionLabel.text = truncatedDescription
            } else {
                planDescriptionLabel.text = description
            }
        }
    }
}
