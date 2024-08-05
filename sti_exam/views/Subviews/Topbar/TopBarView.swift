//
//  TopBar.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-26.
//

import SwiftUI

struct TopBarView: View {
    @EnvironmentObject var homeViewAdapter: HomeViewAdapter
    
    var body: some View {
        if let viewModel = homeViewAdapter.topBarViewModel {
            content(viewModel: viewModel)
            
        } else {
            ProgressView()
                .onAppear(perform: {
                    homeViewAdapter.generateTopBarViewModel()
                })
        }
    }
    
    @ViewBuilder func content(viewModel: ViewModel) -> some View {
        HStack(alignment: .center) {
            Image(viewModel.image)
                .resizable()
                .frame(width: 80, height: 80)
                .scaledToFit()
                .cornerRadius(50)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.gray, lineWidth: 2)
                )
            Spacer()
            Text(viewModel.welcomeTitle)
                .font(.title).bold()
                .foregroundStyle(.black)
            Spacer()
            Button(action: {
                viewModel.logoutAction()
            }, label: {
                RoundedBtn(icon: viewModel.icon)
            }).background(.black).cornerRadius(50)
            
        }
        .padding(.vertical, GridPoints.half)
        .padding(.horizontal, GridPoints.x2)
        Spacer()
    }
    struct ViewModel {
        let image: String
        let welcomeTitle: String
        let icon: String
        let logoutAction: () -> Void
    }

}

#Preview {
    TopBarView()
        .environmentObject(HomeViewAdapter(authDbViewAdapter: AuthDbViewAdapter()))
}
