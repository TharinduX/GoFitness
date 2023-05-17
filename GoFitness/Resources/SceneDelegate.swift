//
//  SceneDelegate.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-10.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
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
                window.rootViewController = UserDetailsViewController()
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
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

