//
//  UpdateProgramView.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-03-14.
//

import SwiftUI

struct UpdateProgramView: View {
    @EnvironmentObject var homeViewAdapter: HomeViewAdapter
    @Environment(\.dismiss) private var dismiss
    @State private var exerciseName: String = ""
    @State private var date: String = ""
    @State private var type: String = ""
    @State private var weight: String = ""
    @State private var reps: Int = 0
    @State private var sets: Int = 0
    @State private var muscleGroups: String = ""
    var selectedExerciseID: UUID?
    
    var body: some View {
        
        if let viewModel = homeViewAdapter.updateProgramViewModel {
            content(viewModel: viewModel)
       
        } else {
            ProgressView()
                .onAppear(perform: {
                    homeViewAdapter.generateUpdateProgramViewModel()
                })
        }
    }
        
        @ViewBuilder func content(viewModel: ViewModel) -> some View {
            VStack {
                Text(viewModel.updateExercisesTitle)
                    .font(.title)
                    .bold()
                
                ExerciseFormCell(viewModel: viewModel.exerciceFormCell,
                                 name: $exerciseName,
                                 date: $date,
                                 type: $type,
                                 muscleGroups: $muscleGroups)
                
                TrainingRecordFormCell(viewModel: viewModel.trainingRecordFormCell,
                                       weight: $weight,
                                       reps: $reps,
                                       sets: $sets
                )
                            HStack {
                                Button(viewModel.updateTitle, action: {
                                    
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
                                        viewModel.updateExerciseAction(newExercise)
                                    }
                                })
                            }
                .onAppear {
                    print("UpdateProgramView appeared")
                    print("Selected Exercise ID: \(String(describing: homeViewAdapter.authDbViewAdapter.selectedExerciseID))")
                    
                    if let currentUserData = homeViewAdapter.authDbViewAdapter.currentUserData,
                       let selectedExerciseID = homeViewAdapter.authDbViewAdapter.selectedExerciseID,
                       let selectedExercise = currentUserData.usersExercises.first(where: { $0.id == selectedExerciseID }) {
                        
                        homeViewAdapter.authDbViewAdapter.selectedExercise = selectedExercise
                        
                        if let selectedExercise = homeViewAdapter.authDbViewAdapter.selectedExercise {
                            print("Selected Exercise: \(selectedExercise)")
                            
                            homeViewAdapter.authDbViewAdapter.exerciseName = selectedExercise.exerciseName
                            homeViewAdapter.authDbViewAdapter.date = selectedExercise.date.formatted()
                            homeViewAdapter.authDbViewAdapter.type = selectedExercise.type
                            homeViewAdapter.authDbViewAdapter.muscleGroups = selectedExercise.muscleGroups.joined(separator: ", ")
                            
                            if let firstTrainingRecord = selectedExercise.usersTrainingRecords.first {
                                homeViewAdapter.authDbViewAdapter.weight = firstTrainingRecord.weight
                                homeViewAdapter.authDbViewAdapter.sets = firstTrainingRecord.sets
                                homeViewAdapter.authDbViewAdapter.reps = firstTrainingRecord.reps
                            }
                        } else {
                            print("Selected Exercise is nil!")
                        }
                    }
                }
            }
        }
    struct ViewModel {
        let updateExercisesTitle: String
        let updateTitle: String
        let categoryTitle: String
        let exerciceFormCell: ExerciseFormCell.ViewModel
        let trainingRecordFormCell: TrainingRecordFormCell.ViewModel
        let updateExerciseAction: (UsersExcercise) -> Void
    }
}
