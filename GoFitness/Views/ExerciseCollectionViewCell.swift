//
//  ExerciseCollectionViewCell.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-20.
//

import UIKit

class ExerciseCollectionViewCell: UICollectionViewCell {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        // Configure other properties of the image view
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        // Configure other properties of the label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Configure the UI elements, add subviews, and set up layout constraints
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Add and configure UI elements
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        // Set up layout constraints for the image view
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        // Set up layout constraints for the title label
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview()
        }
        
    }

}
