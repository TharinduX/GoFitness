//
//  ExerciseTableViewCell.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-21.
//

import UIKit
import SnapKit

class ExerciseTableViewCell: UITableViewCell {
    
    var exercise: [String: Any]?
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
    
    let exerciseNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IntegralCF-Bold", size: 20)
        label.textColor = UIColor(named: "primary")
        label.textAlignment = .left
        return label
    }()
    
    
    let exerciseDescriptionLabel: UILabel = {
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
        boxView.addSubview(exerciseNameLabel)
        boxView.addSubview(exerciseDescriptionLabel)
        
        boxView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            make.height.equalTo(100)
        }
        
        exerciseNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        exerciseDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(exerciseNameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        

    }
    
    @objc private func cellTapped() {
        if let exercise = exercise,
           let navigationController = navigationController {
            let detailViewController = ExerciseDetailViewController()
            detailViewController.exercise = exercise
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    
    func configure(with exercise: [String: Any], navigationController: UINavigationController?) {
        self.exercise = exercise
        self.navigationController = navigationController

        if let name = exercise["name"] as? String,
           let description = exercise["description"] as? String {
            exerciseNameLabel.text = name

            let maxDescriptionLength = 100
            if description.count > maxDescriptionLength {
                let truncatedDescription = String(description.prefix(maxDescriptionLength)) + "..."
                exerciseDescriptionLabel.text = truncatedDescription
            } else {
                exerciseDescriptionLabel.text = description
            }
        }
    }

  }


