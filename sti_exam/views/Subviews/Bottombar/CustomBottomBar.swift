//
//  CustomBottomBar.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-03.
//

import SwiftUI

struct CustomBottomBar: View {
    @EnvironmentObject var homeViewAdapter: HomeViewAdapter
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    let viewModel: ViewModel
    
    init(tabSelection: Binding<Int>, viewModel: ViewModel) {
        self._tabSelection = tabSelection
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack() {
            ForEach(0..<viewModel.tabBarItems.count, id: \.self) { index in
                Button(action: {
                    tabSelection = index + 1
                }, label: {
                    VStack() {
                        PrimaryBtnStyle(
                            title: viewModel.tabBarItems[index].title,
                            icon: viewModel.tabBarItems[index].image,
                            fontSize: 12)
                        if index + 1 == tabSelection {
                            Capsule()
                                .frame(height: 6)
                                .foregroundColor(CustomColors.cyan)
                                .matchedGeometryEffect(
                                    id: LocalizedStrings.selectedTabId,
                                    in: animationNamespace)
                                .offset(y: 3)
                        } else {
                            Capsule()
                                .frame(height: 8)
                                .foregroundColor(.clear)
                                .offset(y: 3)
                        }
                    }
                    .padding(.vertical, GridPoints.x2)
                    .padding(.horizontal, GridPoints.x1)
                })
            }
        }
        .background(.black)
    }
    
    struct ViewModel {
        let listTitle: String
        let addTitle: String
        let searchTitle: String
        let mapTitle: String
        let listIcon: String
        let addIcon: String
        let searchIcon: String
        let mapIcon: String
        let tabBarItems: [(image: String, title: String)]
    }
}
