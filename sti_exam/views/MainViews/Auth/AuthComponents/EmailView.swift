//
//  EmailView.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-22.
//

import SwiftUI

struct EmailView: View {
    @ObservedObject var authDbViewAdapter: AuthDbViewAdapter
    @Binding var userNameInput: String
    var customLabel: String
    var textSize: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .center) {
                Rectangle()
                    .frame(width: GridPoints.custom(14),height: GridPoints.x4)
                    .rotationEffect(.degrees(-GridPoints.x1))
                    .modifier(TextFeildStyling(customBgColor: Color.white, customBgStroke: .black))
                Text(customLabel)
                    .font(Font.custom("PermanentMarker-Regular", size: textSize))
                    .rotationEffect(.degrees(-GridPoints.x1))
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .padding(.bottom, GridPoints.half)
            }
            .padding(.bottom, -GridPoints.x2)
            .rotationEffect(.degrees(-GridPoints.x1))
            
            TextField("", text: $userNameInput)
                .modifier(TextFeildStyling(customBgColor: .white, customBgStroke: .black))
                .onChange(of: userNameInput) { newValue in
                    userNameInput = newValue.lowercased()
                }
            
        }
    }
}

struct UserNameView_Previews: PreviewProvider {
    @State static var userNameInput: String = ""
    @State static var passwordInput: String = ""
    
    static var previews: some View {
        EmailView(authDbViewAdapter: AuthDbViewAdapter(),
                  userNameInput: $userNameInput, customLabel: "User Name", textSize: 14)
        .previewLayout(.sizeThatFits)
    }
}
