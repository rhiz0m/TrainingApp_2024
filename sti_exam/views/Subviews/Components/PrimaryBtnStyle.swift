//
//  PrimaryBtn.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-03.
//
import SwiftUI

struct PrimaryBtnStyle: View {
    
    var title: String
    var height: CGFloat = 44
    var icon: String
    var fontSize: CGFloat = 16
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.45)]), startPoint: .bottom, endPoint: .top)
            .cornerRadius(GridPoints.x6)
            .frame(height: height)
            .overlay(
                RoundedRectangle(cornerRadius: GridPoints.x3)
                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]),
                                           startPoint: .top,
                                           endPoint: .bottom),
                            lineWidth: 1)
                    .shadow(color: .white,
                            radius: 10, x: 2, y: 2)
                    .background(
                        VStack(alignment: .leading) {
                            HStack(alignment: .center) {
                                Text(title)
                                    .font(.custom("Roboto-Medium", size: fontSize))
                                    .foregroundColor(.white)
                                Image(systemName: icon)
                                    .foregroundColor(.blue)
                                    .imageScale(.medium)
                            }
                        }
                    )
            )
    }
}

struct SharedBtnStyle_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryBtnStyle(title: "title", icon: "plus.circle.fill")
    }
}
