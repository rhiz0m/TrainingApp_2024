//
//  MapView+Extensions.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-05-08.
//

import Foundation
import MapKit
import SwiftUI

extension MapView {
    func search() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = .userRegion
        
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
    }
    
    func fetchRoute() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: .init(coordinate: .userLocation))
        request.destination = mapSelection
        
        Task {
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
            routeDestination = mapSelection
            
            withAnimation(.snappy) {
                routeDisplaying = true
                showDetails = false
                if let rect = route?.polyline.boundingMapRect, routeDisplaying {
                    cameraPosition = .rect(rect)
                }
            }
        }
    }
}

extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        // 59.335318345496184, 18.063203910569936
        return .init(latitude: 59.335318345496184, longitude: 18.063203910569936)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
    }
}
