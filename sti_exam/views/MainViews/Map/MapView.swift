//
//  Maps.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-23.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var homeViewAdapter: HomeViewAdapter
    @State var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State var searchText = ""
    @State var results = [MKMapItem]()
    @State var mapSelection: MKMapItem?
    @State var showDetails = false
    @State var getDirections = false
    @State var routeDisplaying = false
    @State var route: MKRoute?
    @State var routeDestination: MKMapItem?
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
            content(viewModel: viewModel)
    }
    
    @ViewBuilder func content(viewModel: ViewModel) -> some View {
        Map(position: $cameraPosition, selection: $mapSelection) {
            Marker(viewModel.markerTitle,
                   systemImage: viewModel.icon,
                   coordinate: .userLocation)
            .tint(.cyan)
            
            ForEach(results, id: \.self) { item in
                
                if routeDisplaying {
                    if item == routeDestination {
                        let placemark = item.placemark
                        Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                    }
                } else {
                    let placemark = item.placemark
                    Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                }
                
            }
            
            if let route {
                MapPolyline(route.polyline).stroke(CustomColors.cyan, lineWidth: 6)
            }
        }
        .overlay(alignment: .top) {
            TextField(viewModel.textFeildLabel, text: $searchText)
                .font(.subheadline).padding(12)
                .background(.white)
                .padding()
                .shadow(radius: 12)
        }
        
        .onSubmit(of: .text) {
            Task { await search() }
        }
        .onChange(of: mapSelection, { oldValue, newValue in
            showDetails = newValue != nil
        })
        .onChange(of: getDirections, { oldValue, newValue in
            if newValue {
                fetchRoute()
            }
        })
        .sheet(isPresented: $showDetails, content: {
            LocationDetailsView(mapSelection: $mapSelection,
                                show: $showDetails,
                                getDirections: $getDirections)
            .presentationDetents([.height(400)])
            .presentationBackgroundInteraction(.enabled(upThrough: .height(400)))
            .presentationCornerRadius(12)
        })
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
    }
    struct ViewModel {
        let markerTitle: String
        let icon: String
        let textFeildLabel: String
    }
}
