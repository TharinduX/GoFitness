//
//  PlanCollectionViewCell.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-20.
//

import UIKit
import SnapKit

class PlanCollectionViewCell: UICollectionViewCell {
    let boxView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "bg-secondary")
        view.layer.masksToBounds = true
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "back-img")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-SemiBold", size: 20)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(boxView)
        boxView.addSubview(titleLabel)
        boxView.addSubview(imageView)
        boxView.bringSubviewToFront(titleLabel)
        
        boxView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
