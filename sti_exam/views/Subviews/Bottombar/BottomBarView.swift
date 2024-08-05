//
//  BottomBar.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-06.
//

import SwiftUI

struct BottomBarView: View {
    @EnvironmentObject var homeViewAdapter: HomeViewAdapter
    @State private var tabSelection = 1
    
    var body: some View {
        if let viewModel = homeViewAdapter.bottomBarViewModel {
            content(viewModel: viewModel)
        } else {
            ProgressView()
                .onAppear(perform: {
                    homeViewAdapter.generateBottomBarViewModel()
                })
        }
    }
    
    @ViewBuilder func content(viewModel: ViewModel) -> some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $tabSelection) {
                ExerciseListView(viewModel: viewModel.exerciseListViewModel)
                    .tabItem {
                    }.tag(1)
                CreateProgramView(viewModel: viewModel.createProgramViewModel, tabSelection: $tabSelection)
                    .tabItem {
                    }.tag(2)
                SearchView(viewModel: viewModel.searchViewModel)
                    .tabItem {
                    }.tag(3)
                MapView(viewModel: viewModel.mapViewModel)
                    .tabItem {
                    }.tag(4)
            }
            CustomBottomBar(tabSelection: $tabSelection, viewModel: viewModel.customBottomBarViewModel)
        }
        .environmentObject(homeViewAdapter)
    }
    struct ViewModel {
        let customBottomBarViewModel: CustomBottomBar.ViewModel
        let createProgramViewModel: CreateProgramView.ViewModel
        let searchViewModel: SearchView.ViewModel
        let exerciseListViewModel: ExerciseListView.ViewModel
        let mapViewModel: MapView.ViewModel
    }
}

#Preview {
    BottomBarView()
        .environmentObject(HomeViewAdapter(authDbViewAdapter: AuthDbViewAdapter()))
}
