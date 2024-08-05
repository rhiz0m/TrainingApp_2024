//
//  CreateProgramView.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-03-14.
//

import SwiftUI

struct CreateProgramView: View {

    @EnvironmentObject var homeViewAdapter: HomeViewAdapter
    @State var usersExercise: UsersExcercise?
    @State var usersTrainingRecord: UsersTrainingRecord?
    @State var exerciseName = ""
    @State var date = ""
    @State var type = ""
    @State var muscleGroups = ""
    @State var weight = ""
    @State var reps = 0
    @State var sets = 0
    @Environment(\.presentationMode) var presentationMode
    @Binding var tabSelection: Int
    
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel, tabSelection: Binding<Int>) {
        self.viewModel = viewModel
        self._tabSelection = tabSelection
    }
    
    var body: some View {
        content(viewModel: viewModel)
    }
    
    @ViewBuilder func content(viewModel: ViewModel) -> some View {
        VStack {
            ExerciseFormCell(
                viewModel: viewModel.exerciceFormCell,
                name: $exerciseName,
                date: $date,
                type: $type,
                muscleGroups: $muscleGroups)
            
            TrainingRecordFormCell(
                viewModel: viewModel.trainingRecordFormCell,
                weight: $weight,
                reps: $reps,
                sets: $sets)
            
            HStack {
                Button(viewModel.saveTitle, action: {
                    
                    if !exerciseName.isEmpty {
                        
                        let weightValue = Double(weight) ?? 0.0
                        
                        let usersTrainingRecord = UsersTrainingRecord(weight: weight, reps: reps, sets: sets, totalReps: reps * sets, totalWeight: reps * sets * Int(weightValue))
                        
                        let trainingRecordsId = usersTrainingRecord.id
                        
                        let newExercise = UsersExcercise(
                            id: UUID(),
                            category: viewModel.categoryTitle,
                            exerciseName: exerciseName,
                            date: Date(),
                            type: type,
                            muscleGroups: [muscleGroups],
                            trainingRecordIds: [trainingRecordsId],
                            usersTrainingRecords: [usersTrainingRecord]
                        )
                        viewModel.saveExerciseAction(newExercise)
                        presentationMode.wrappedValue.dismiss()
                        tabSelection = 1
                        
                    }
                
                })
            }
            .padding(.vertical, GridPoints.x1)
            .padding(.horizontal, GridPoints.x4)
        }
        .onAppear {
            homeViewAdapter.authDbViewAdapter.clearFeilds()
        }
    }
    
    struct ViewModel {
        let saveTitle: String
        let categoryTitle: String
        let exerciceFormCell: ExerciseFormCell.ViewModel
        let trainingRecordFormCell: TrainingRecordFormCell.ViewModel
        let saveExerciseAction: (UsersExcercise) -> Void
    }
}

