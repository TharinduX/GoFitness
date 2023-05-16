//
//  RegisterViewController.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-16.
//

import UIKit
import SnapKit

class RegisterViewController: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to GoFitness"
        label.font = UIFont(name: "IntegralCF-Regular", size: 20)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
        
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.font = UIFont(name: "IntegralCF-Bold", size: 60)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        view.addSubview(imageView)
        view.addSubview(subtitleLabel)
        view.addSubview(titleLabel)
        
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(235)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(250)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    

}
