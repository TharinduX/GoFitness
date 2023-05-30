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
    
    //save user details
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
    
    //get logged in user details
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
    
    //get logged in user plans for bmi consideration
    func getUserPlan(completion: @escaping ([String: Any]?, Error?) -> Void) {
        let db = Firestore.firestore()
        let userDetailsCollection = db.collection("userDetails") 
        
        let uid = Auth.auth().currentUser?.uid
        let userDetailsQuery = userDetailsCollection.whereField("userId", isEqualTo: uid as Any)
        
        userDetailsQuery.getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let snapshot = snapshot else {
                completion(nil, nil)
                return
            }
            
            if let userDetailsDoc = snapshot.documents.first,
               let bmiConsideration = userDetailsDoc.data()["bmiConsideration"] as? String {
                let plansCollection = db.collection("plans")
                
                // Query the plans collection to find the plans for the BMI consideration
                let plansQuery = plansCollection.whereField("planFor", isEqualTo: bmiConsideration)
                
                plansQuery.getDocuments { (plansSnapshot, plansError) in
                    if let plansError = plansError {
                        completion(nil, plansError)
                        return
                    }
                    
                    guard let plansSnapshot = plansSnapshot else {
                        completion(nil, nil)
                        return
                    }
                    
                    if let planDetails = plansSnapshot.documents.first?.data() {
                        completion(planDetails, nil)
                    } else {
                        completion(nil, nil)
                    }
                }
                
            } else {
                completion(nil, nil)
            }
        }
    }
    
    //save cutom plans for firebase
    func savePlanToFirestore(userId: String, selectedExercise: Exercise, selectedSets: Int, selectedReps: Int, scheduleName: String, description: String) {
        
        print(selectedExercise.name)
        let db = Firestore.firestore()
        db.collection("exercises").whereField("name", isEqualTo: selectedExercise.name).getDocuments { [weak self] (snapshot, error) in
            guard self != nil else { return }
            
            if let error = error {
                print("Error fetching exercise: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                if let document = snapshot.documents.first {
                    let exerciseData = document.data()
                    if let video = exerciseData["video"] as? String,
                       let image = exerciseData["image"] as? String,
                       let exerciseDescription = exerciseData["description"] as? String,
                       let bodyParts = exerciseData["bodyParts"] as? [String] {
                        
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
                    print("Exercise document does not exist")
                }
            }
        }
    }
    
    //get logged in user custom plans
    func getCustomPlans(completion: @escaping ([[String: Any]]?, Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            let error = NSError(domain: "CustomPlansErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Current user not available"])
            completion(nil, error)
            return
        }
        
        let userUID = currentUser.uid
        let plansRef = Firestore.firestore().collection("plans")
        
        plansRef.whereField("userId", isEqualTo: userUID).whereField("type", isEqualTo: "").getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            var plans: [[String: Any]] = []
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let planData = document.data()
                    plans.append(planData)
                }
            }
            
            completion(plans, nil)
        }
    }
    
    //get exersices from the exercises collection
    func fetchExercisesFromFirestore(completion: @escaping ([(String, Exercise)]?, Error?) -> Void) {
        db.collection("exercises").getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let snapshot = snapshot {
                var exercises = [(String, Exercise)]()
                for document in snapshot.documents {
                    if let exerciseData = document.data() as? [String: Any],
                       let name = exerciseData["name"] as? String {
                        let exercise = Exercise(name: name, video: "", image: "", description: "", bodyParts: [], sets: 0, reps: 0)
                        exercises.append((document.documentID, exercise))
                    }
                }
                
                completion(exercises, nil)
            }
        }
    }

    
    //delete custom plan
    func deletePlan(with planName: String, completion: @escaping (Error?) -> Void) {
        let plansCollection = db.collection("plans")
        
        plansCollection.whereField("name", isEqualTo: planName).getDocuments { (snapshot, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(nil)
                return
            }
            
            // Delete the found plans
            for document in documents {
                plansCollection.document(document.documentID).delete { error in
                    if let error = error {
                        completion(error)
                    }
                }
            }
            
            completion(nil)
        }
    }
    
    //get one exercise from the firestore
    func getExerciseDataFromFirestore(documentID: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        let exerciseRef = db.collection("exercises").document(documentID)
        exerciseRef.getDocument { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let snapshot = snapshot, let exerciseData = snapshot.data() {
                completion(exerciseData, nil)
            } else {
                completion(nil, nil)
            }
        }
    }

    func updatePlan(planName: String, exercise: Exercise) {
        let db = Firestore.firestore()
        
        db.collection("plans").whereField("name", isEqualTo: planName).getDocuments { [weak self] (snapshot, error) in
            guard self != nil else { return }
            
            if let error = error {
                print("Error fetching plan: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                // Assuming there's only one document with the given plan name
                if let document = snapshot.documents.first {
                    let documentID = document.documentID
                    
                    db.collection("plans").document(documentID).getDocument { (documentSnapshot, error) in
                        if let error = error {
                            print("Error fetching plan document: \(error.localizedDescription)")
                            return
                        }
                        
                        if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                            var updatedExercises: [Exercise] = []
                            
                            if let planData = documentSnapshot.data(),
                               let existingExercises = planData["exercises"] as? [[String: Any]] {
                                for existingExercise in existingExercises {
                                    if let existingName = existingExercise["name"] as? String {
                                        if existingName == exercise.name {
                                            // Exercise already exists in the plan, no need to add it again
                                            print("Exercise already exists in the plan.")
                                            return
                                        }
                                    }
                                    
                                    if let name = existingExercise["name"] as? String,
                                       let video = existingExercise["video"] as? String,
                                       let image = existingExercise["image"] as? String,
                                       let description = existingExercise["description"] as? String,
                                       let bodyParts = existingExercise["bodyParts"] as? [String],
                                       let sets = existingExercise["sets"] as? Int,
                                       let reps = existingExercise["reps"] as? Int {
                                        let existingExercise = Exercise(name: name, video: video, image: image, description: description, bodyParts: bodyParts, sets: sets, reps: reps)
                                        updatedExercises.append(existingExercise)
                                    }
                                }
                            }
                            
                            // Append the new exercise to the updatedExercises array
                            updatedExercises.append(exercise)
                            
                            // Update the exercises field in the plan document
                            let updatedData: [String: Any] = [
                                "exercises": updatedExercises.map { exercise in
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
                            
                            db.collection("plans").document(documentID).updateData(updatedData) { error in
                                if let error = error {
                                    print("Error updating plan: \(error.localizedDescription)")
                                } else {
                                    print("Plan updated successfully")
                                }
                            }
                        } else {
                            print("Plan document does not exist")
                        }
                    }
                } else {
                    print("Plan document does not exist")
                }
            }
        }
    }

}
    



