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
}
