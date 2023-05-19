//
//  UserPlans.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-19.
//

import Foundation

struct UserPlans {
    let id: String
    let userId: String
    let type: String
    let name: String
    let description: String
    let planFor: String
    let exercises: [Exercise]
}

struct Exercise {
    let id: Int
    let reps: Int
    let sets: Int
}
