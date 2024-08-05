//
//  SearchView.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-03-14.
//

import SwiftUI


struct SearchView: View {
    @EnvironmentObject var homeViewAdapter: HomeViewAdapter
    @State var selected: Bool = false
    @State private var title = ""
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content(viewModel: viewModel)
    }
    
    @ViewBuilder func content(viewModel: ViewModel) -> some View {
        ZStack {
            backgroundImageView(imageName: viewModel.imageName)
            VStack(spacing: CGFloat(GridPoints.x3)) {
                searchFeildView(viewModel: viewModel)
                resultListView(viewModel: viewModel)
            }
        }
    }
    
    
    @ViewBuilder private func backgroundImageView(imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.bottom)
            .overlay(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color.cyan.opacity(0.05),
                            Color.black.opacity(1)]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.bottom)
            )
    }
    
    @ViewBuilder private func resultListView(viewModel: ViewModel) -> some View {
        
        List(homeViewAdapter.apiResponse) { exerciseInfo in
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text(viewModel.nameTitle)
                        .bold()
                        .foregroundColor(CustomColors.cyan)
                    
                    Text(exerciseInfo.name)
                        .foregroundColor(.white)
                }
                HStack {
                    Text(viewModel.typeTitle)
                        .bold()
                        .foregroundColor(CustomColors.cyan)
                    
                    Text("\(exerciseInfo.type)")
                        .foregroundColor(.white)
                }
                HStack {
                    Text(viewModel.muscleTitle)
                        .bold()
                        .foregroundColor(CustomColors.cyan)
                    
                    Text("\(exerciseInfo.muscle)")
                        .foregroundColor(.white)
                    
                }
                HStack {
                    Text(viewModel.equipmentTitle)
                        .bold()
                        .foregroundColor(CustomColors.cyan)
                    
                    Text("\(exerciseInfo.equipment)")
                        .foregroundColor(.white)
                }
                HStack {
                    Text(viewModel.difficultyTitle)
                        .bold()
                        .foregroundColor(CustomColors.cyan)
                    
                    Text("\(exerciseInfo.difficulty)")
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading) {
                    Text(viewModel.instructionsTitle)
                        .bold()
                        .foregroundColor(CustomColors.cyan)
                    
                    Text("\(exerciseInfo.instructions)")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.black)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
        }.cornerRadius(GridPoints.x2)
            .listStyle(PlainListStyle())
            .padding(.horizontal, GridPoints.x2)
            .shadow(color: CustomColors.cyan.opacity(0.1), radius: 15, x: 0, y: 5)
        
    }
    
    
    @ViewBuilder func searchFeildView(viewModel: ViewModel) -> some View {
        
        HStack {
            CustomTextField(textInput: $title, title: viewModel.title)
            
            Button(action: {
                withAnimation(.bouncy(duration: 0.5)) {
                    selected.toggle()
                    homeViewAdapter.searchExercisesAPI(muscle: title)
                }
            }, label: {
                RoundedBtn(title: "", icon: viewModel.icon)
                    .scaleEffect(selected ? 1.1 : 1.0)
            })
        }
        .padding(.horizontal, GridPoints.x2)
        .padding(.top, GridPoints.x4)
        
    }
    
    struct ViewModel {
        let nameTitle: String
        let typeTitle: String
        let muscleTitle: String
        let equipmentTitle: String
        let difficultyTitle: String
        let instructionsTitle: String
        let title: String
        let imageName: String
        let icon: String
        let apiAction: (String) -> Void
    }
}
