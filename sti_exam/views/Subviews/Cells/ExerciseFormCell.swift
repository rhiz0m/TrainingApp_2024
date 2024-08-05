//
//  ExerciseFormView.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-23.
//

import SwiftUI

struct ExerciseFormCell: View {
    let viewModel: ViewModel
    
    @Binding var name: String
    @Binding var date: String
    @Binding var type: String
    @Binding var muscleGroups: String
    
    var selectedProgram: UsersExcercise?
    
    var body: some View {
        
        TextField(viewModel.name, text: $name)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.vertical, GridPoints.x1)
            .padding(.horizontal, GridPoints.x4)
            .onAppear {
                print("ExerciseFormView - exerciseName: \(name)")
            }
        
        TextField(viewModel.type, text: $type)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.vertical, GridPoints.x1)
            .padding(.horizontal, GridPoints.x4)
        
        TextField("\(viewModel.muscleGroups) \(muscleGroups)",
                  text: $muscleGroups)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(.vertical, GridPoints.x1)
        .padding(.horizontal, GridPoints.x4).onAppear {
        }
    }
    struct ViewModel {
        let name: String
        let type: String
        let muscleGroups: String
    }
}

struct ProgramFormView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ExerciseFormCell.ViewModel(
            name: "",
            type: "",
            muscleGroups: "")
        
        return ExerciseFormCell(
            viewModel: viewModel,
            name: Binding.constant("Name:"),
            date: Binding.constant("Date:"),
            type: Binding.constant("Type:"),
            muscleGroups: Binding.constant("MuscleGroups:"))
    }
}
