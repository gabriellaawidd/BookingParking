//
//  Untitled.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 07/07/26.
//

import Foundation
import CoreLocation
import MapKit

protocol MallLocationServicing {
    func fetchNearbyMalls(near userLocation: CLLocationCoordinate2D?) async throws -> [MallLocation]
}

struct MallLocationService: MallLocationServicing {
    func fetchNearbyMalls(near userLocation: CLLocationCoordinate2D?) async throws -> [MallLocation] {
        let center = userLocation ?? CLLocationCoordinate2D(latitude: -6.3013, longitude: 106.6488)

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "mall"
        request.region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: 20_000,
            longitudinalMeters: 20_000
        )

        let response = try await MKLocalSearch(request: request).start()
        let userCLLocation = userLocation.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }

        let malls = response.mapItems.map { item in
            MallLocation(
                name: item.name ?? "Unknown Mall",
                address: item.address?.fullAddress ?? "",
                coordinate: item.location.coordinate,
                distanceInMeters: userCLLocation?.distance(from: item.location)
            )
        }

        return malls.sorted { ($0.distanceInMeters ?? .infinity) < ($1.distanceInMeters ?? .infinity) }
    }
}
