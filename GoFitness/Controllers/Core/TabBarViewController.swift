//
//  TabBarViewController.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-10.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = HomeViewController()
        let vc2 = ExerciseViewController()
        let vc3 = CustomViewController()
        let vc4 = SettingsViewController()
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        vc4.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        let nav4 = UINavigationController(rootViewController: vc4)
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Exercises", image: UIImage(systemName: "figure.run"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Custom", image: UIImage(systemName: "doc.badge.plus"), tag: 1)
        nav4.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        nav4.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1,nav2,nav3,nav4], animated: false)
        
        let tabColor = UIColor(named: "nav")
        tabBar.layer.backgroundColor = tabColor?.cgColor
        
        let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .gray
                tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        
        tabBar.standardAppearance = tabBarAppearance
        
    }


}
