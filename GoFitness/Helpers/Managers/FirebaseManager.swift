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
    
    func savePlanToFirestore(userId: String, selectedExercise: Exercise, selectedSets: Int, selectedReps: Int, scheduleName: String, description: String) {
        
        let db = Firestore.firestore()
        db.collection("exercises").whereField("name", isEqualTo: selectedExercise.name).getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                // Handle the case where an error occurred while fetching the exercise data
                print("Error fetching exercise: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                if let document = snapshot.documents.first {
                    // Extract the exercise data from the fetched document
                    let exerciseData = document.data()
                    if let video = exerciseData["video"] as? String,
                       let image = exerciseData["image"] as? String,
                       let exerciseDescription = exerciseData["description"] as? String,
                       let bodyParts = exerciseData["bodyParts"] as? [String] {
                        
                        // Create the Exercise object with the fetched exercise data
                        let exercise = Exercise(name: selectedExercise.name, video: video, image: image, description: exerciseDescription, bodyParts: bodyParts, sets: selectedSets, reps: selectedReps)
                        
                        // Create the Plans object
                        let plan = Plans(userId: userId, type: "", name: scheduleName, description: description, planFor: "", exercises: [exercise])
                        
                        // Convert the plan to a dictionary
                        let planData: [String: Any] = [
                            "userId": plan.userId,
                            "type": "",
                            "name": plan.name,
                            "description": plan.description,
                            "exercises": plan.exercises.map { exercise in
                                return [
                                    "name": exercise.name,
                                    "video": exercise.video,
                                    "image": exercise.image,
                                    "description": exercise.description,
                                    "bodyParts": exercise.bodyParts,
                                    "sets": exercise.sets,
                                    "reps": exercise.reps
                                ]
                            }
                        ]
                        
                        // Save the plan data to Firebase Firestore
                        db.collection("plans").addDocument(data: planData) { error in
                            if let error = error {
                                // Handle the case where the data couldn't be saved
                                print("Error saving plan: \(error.localizedDescription)")
                            } else {
                                print("Plan saved successfully")
                            }
                        }
                    }
                } else {
                    // Handle the case where the exercise document does not exist
                    print("Exercise document does not exist")
                }
            }
        }
    }
}


