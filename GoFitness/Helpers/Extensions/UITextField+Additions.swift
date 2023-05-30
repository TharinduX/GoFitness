//
//  UITextField+Additions.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-15.
//

import UIKit
import SnapKit

extension UITextField {
    func addBottomBorder(color: UIColor, height: CGFloat) {
        let borderView = UIView()
        borderView.backgroundColor = color
        addSubview(borderView)
        
        borderView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(height)
        }
        
        // Set the placeholder color to light gray
        let placeholderColor = UIColor.lightGray
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        
    }
    
}

extension UITextView {
    func addBottomBorder(color: UIColor, height: CGFloat) {
        let borderView = UIView()
        borderView.backgroundColor = color
        addSubview(borderView)
        
        borderView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(height)
        }
        
    }
    
}
    
extension UIScrollView {
    func addPullToRefresh(target: Any, action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.refreshControl = refreshControl
        } else {
            self.addSubview(refreshControl)
        }
    }
}
