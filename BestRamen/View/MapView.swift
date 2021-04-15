//
//  MapView.swift
//  BestRamen
//
//  Created by 樋川大聖 on 2021/04/12.
//  Copyright © 2021 Taisei Hikawa. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region =
            MKCoordinateRegion(
                center: .init(latitude: 35.710263046992736, longitude: 139.81067894034084),
                latitudinalMeters: 300,
                longitudinalMeters: 300
            )
    struct PinItem: Identifiable {
            let id = UUID()
            let coordinate: CLLocationCoordinate2D
        }
    var body: some View {
        Map(coordinateRegion: $region,
                    interactionModes: .zoom,
                    showsUserLocation: true,
                    annotationItems: [
                        PinItem(coordinate: .init(latitude: 35.710263046992736, longitude: 139.81067894034084)),
                        PinItem(coordinate: .init(latitude: 35.710063046992736, longitude: 139.81047894034084))
                    ],
                    annotationContent: { item in
                        MapMarker(coordinate: item.coordinate)
                    }
                ).edgesIgnoringSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
