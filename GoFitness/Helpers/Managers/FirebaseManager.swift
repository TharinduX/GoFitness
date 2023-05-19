//
//  FirebaseManager.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-18.
//

import Foundation
import Firebase

class FirebaseManager {
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func saveUserDetails(_ userDetails: UserDetails, completion: @escaping (Error?) -> Void) {
        let userDetailsRef = db.collection("userDetails").document()
        
        let data: [String: Any] = [
            "bmi": userDetails.bmi,
            "bmiConsideration": userDetails.bmiConsideration,
            "userId": userDetails.userId,
            "name": userDetails.name,
            "height": userDetails.height,
            "weight": userDetails.weight,
            "age": userDetails.age,
            "fitnessGoal": userDetails.fitnessGoal
        ]
        
        userDetailsRef.setData(data) { error in
            completion(error)
        }
    }
    
    func getUserDetails(completion: @escaping ([String: Any]?, Error?) -> Void) {
           if let uid = Auth.auth().currentUser?.uid {
               let userDetailsRef = db.collection("userDetails").whereField("userId", isEqualTo: uid)
               
               userDetailsRef.getDocuments { (querySnapshot, error) in
                   if let error = error {
                       completion(nil, error)
                       return
                   }
                   
                   if let document = querySnapshot?.documents.first {
                       // User details found
                       let data = document.data()
                       completion(data, nil)
                   } else {
                       // User details not found
                       completion(nil, nil)
                   }
               }
           } else {
               // User not logged in
               completion(nil, nil)
           }
       }
    
    func getUserPlan(completion: @escaping ([String: Any]?, Error?) -> Void) {
        let db = Firestore.firestore() // Get the Firestore instance
        let userDetailsCollection = db.collection("userDetails") // Get the userDetails collection
        
        // Query the userDetails collection to find the user with the specified UID
        let uid = Auth.auth().currentUser?.uid
        let userDetailsQuery = userDetailsCollection.whereField("userId", isEqualTo: uid as Any)

        userDetailsQuery.getDocuments { (snapshot, error) in
            if let error = error {
                // Handle the error
                completion(nil, error)
                return
            }

            guard let snapshot = snapshot else {
                // Handle the case where snapshot is nil
                completion(nil, nil)
                return
            }

            if let userDetailsDoc = snapshot.documents.first,
               let bmiConsideration = userDetailsDoc.data()["bmiConsideration"] as? String {
                let plansCollection = db.collection("plans") // Get the plans collection

                // Query the plans collection to find the plans for the BMI consideration
                let plansQuery = plansCollection.whereField("planFor", isEqualTo: bmiConsideration)

                plansQuery.getDocuments { (plansSnapshot, plansError) in
                    if let plansError = plansError {
                        // Handle the error
                        completion(nil, plansError)
                        return
                    }

                    guard let plansSnapshot = plansSnapshot else {
                        // Handle the case where plansSnapshot is nil
                        completion(nil, nil)
                        return
                    }

                    if let planDetails = plansSnapshot.documents.first?.data() {
                        // Return the plan details
                        completion(planDetails, nil)
                    } else {
                        // Handle the case where no matching plan is found
                        completion(nil, nil)
                    }
                }
                
            } else {
                // Handle the case where no matching user is found or no BMI consideration value is present
                completion(nil, nil)
            }
        }
    }
    
//    func getExercises (uid: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
//        let planRef = db.collection("exercises").document()
//    }

    
}
