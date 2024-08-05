//
//  UsersTrainingRecord.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-23.
//

import Foundation
import FirebaseFirestoreSwift

struct UsersTrainingRecord: Identifiable, Codable {
    var id = UUID()
    var category = "users_exercises"
    var weight: String
    var reps: Int
    var sets: Int
    var totalReps: Int
    var totalWeight: Int
    
    enum CodingKeys: String, CodingKey {
        case weight
        case reps
        case sets
        case totalReps = "total_reps"
        case totalWeight = "total_weight"
        
    }
}
