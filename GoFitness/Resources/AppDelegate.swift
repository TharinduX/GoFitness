//
//  AppDelegate.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-10.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        if AuthManager.shared.isSignedIn {
            if let userId = Auth.auth().currentUser?.uid {
                let userDetailsRef = Firestore.firestore().collection("userDetails")
                userDetailsRef.whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
                    if let error = error {
                        // Error occurred, print the localized description
                        print("Firestore Error: \(error.localizedDescription)")
                    } else {
                        if let snapshot = snapshot, !snapshot.isEmpty {
                            // User details exist in Firestore, show the TabBarViewController
                            window.rootViewController = TabBarViewController()
                        } else {
                            // User details don't exist in Firestore, show the UserDetailsViewController
                            window.rootViewController = UserDetailsViewController()
                        }
                    }
                }
            } else {
                // User ID is not available, show the UserDetailsViewController
                window.rootViewController = AuthViewController()
            }
        }
        
        else {
            let navVC = UINavigationController(rootViewController: AuthViewController())
            navVC.navigationBar.prefersLargeTitles = true
            navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
            window.rootViewController = navVC
        }
        
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

