//
//  UsersExercise.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-23.
//

import Foundation
import FirebaseFirestoreSwift

struct UsersExcercise: Identifiable, Codable {
    var id = UUID()
    var category = "users_exercise"
    var exerciseName: String
    var date: Date
    var type: String
    var muscleGroups: [String] = []
    var trainingRecordIds: [UUID]
    var usersTrainingRecords: [UsersTrainingRecord]
    
    enum CodingKeys: String, CodingKey {
        case id
        case category
        case exerciseName
        case date
        case type
        case muscleGroups = "muscle_groups"
        case trainingRecordIds = "training_records_ids"
        case usersTrainingRecords = "users_training_records"
        
    }
}
