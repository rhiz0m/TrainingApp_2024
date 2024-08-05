//
//  ExerciseAPI.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-23.
//

import Foundation

struct ExerciseAPI: Codable, Identifiable {
    var id: UUID?
    let name: String
    let type: String
    let muscle: String
    let equipment: String
    let difficulty: String
    let instructions: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, muscle, equipment, difficulty, instructions
    }
}
