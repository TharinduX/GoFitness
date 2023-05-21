//
//  UserPlans.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-19.
//

import Foundation

struct Plans {
    let userId: String
    let type: String?
    let name: String
    let description: String
    let planFor: String?
    let exercises: [Exercise]
}

struct Exercise {
    let name: String
    let video: String
    let image: String
    let description: String
    let bodyParts: Array<String>
    let sets: Int
    let reps: Int
}
