//
//  TrainingRecordFormView.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-23.
//

import SwiftUI

struct TrainingRecordFormCell: View {
    let viewModel: ViewModel
    
    @Binding var weight: String
    @Binding var reps: Int
    @Binding var sets: Int
    
    var body: some View {
        
        TextField("\(viewModel.weight) \(weight)",
                  text: $weight)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(.vertical, GridPoints.x1)
        .padding(.horizontal, GridPoints.x4)
        
        HStack() {
            Stepper("\(viewModel.repsTitle) \(reps)", value: $reps)
            Stepper("\(viewModel.setsTitle) \(sets)", value: $sets)
        }.padding(.vertical, GridPoints.x1)
            .padding(.horizontal, GridPoints.x4)
        
    }
    struct ViewModel {
        let weight: String
        let setsTitle: String
        let repsTitle: String
        let reps: Int
        let sets: Int
    }
}

struct TrainingRecordFormView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TrainingRecordFormCell.ViewModel(
            weight: "Weight", 
            setsTitle: "Sets:", 
            repsTitle: "Reps:",
            reps: 10,
            sets: 5
        )
        
        return TrainingRecordFormCell(
            viewModel: viewModel,
            weight: Binding.constant("100"),
            reps: Binding.constant(5),
            sets: Binding.constant(6)
        )
    }
}
