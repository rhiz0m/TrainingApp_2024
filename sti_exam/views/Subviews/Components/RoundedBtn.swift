//
//  RoundedBtn.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-23.
//

import SwiftUI

struct RoundedBtn: View {
    
    var title: String?
    var height: CGFloat = 44
    var width: CGFloat = 44
    var icon: String
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.black, Color.purple.opacity(0.45)]), startPoint: .bottom, endPoint: .top)
            .cornerRadius(GridPoints.x6)
            .frame(width: width, height: height)
            .overlay(
                RoundedRectangle(cornerRadius: GridPoints.x3)
                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.black]),
                        startPoint: .top,
                        endPoint: .bottom),
                        lineWidth: 1)
                    .background(
                        HStack(alignment: .center) {
                            Image(systemName: icon)
                                .foregroundColor(CustomColors.magenta)
                                .imageScale(.medium)
                        }
                    )
                )
    }
}

struct RoundedBtn_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryBtnStyle(title: "title", icon: "plus.circle.fill")
    }
}
