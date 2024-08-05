//
//  LocationDetailsView.swift
//  trainingApp
//
//  Created by Andreas Antonsson on 2023-11-18.
//

import SwiftUI
import MapKit

struct LocationDetailsView: View {
    @Binding var mapSelection: MKMapItem?
    @Binding var show: Bool
    @Binding var getDirections: Bool
    @State private var lookAroundScene: MKLookAroundScene?
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(mapSelection?.placemark.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(mapSelection?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                        .padding(.trailing)
                }
                Button(action: {
                    show.toggle()
                    mapSelection = nil
                }, label: {
                    RoundedBtn(title: "", icon: "xmark").background(.black).cornerRadius(50)
                })
            }.padding()
            
            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding()
            } else {
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
            }
            
            HStack(spacing: 24) {
                Button(action: {
                    if let mapSelection {
                        mapSelection.openInMaps()
                    }
                },label: {
                    PrimaryBtnStyle(title: "Open in Maps", icon: "map").background(.black)
                        .cornerRadius(GridPoints.x3)
                })
                
                Button(action: {
                    getDirections = true
                    show = false
                }, label: {
                    PrimaryBtnStyle(title: "Get diretions", icon: "arrow.turn.down.left")
                        .background(.black)
                        .cornerRadius(GridPoints.x3)
                })
            }.padding()
            
            
            
            
        }.onAppear {
            print("Debug: did call on appear")
            fetchLookAroundPreview()
        }.onChange(of: mapSelection) { oldValue, newValue in
            print("Debug: did call on change")
            fetchLookAroundPreview()
        }
    }
}

// Function to get the lookaround view
extension LocationDetailsView {
    func fetchLookAroundPreview() {
        if let mapSelection {
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookAroundScene = try? await request.scene
            }
        }
    }
}

#Preview {
    LocationDetailsView(mapSelection: .constant(nil), show: .constant(false), getDirections: .constant(false))
}
