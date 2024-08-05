//
//  UserData.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-23.
//

import Foundation
import FirebaseFirestoreSwift

struct UserData: Codable {
    @DocumentID var id: String?
    var usersExercises: [UsersExcercise]
}
