//
//  MallLocation.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 07/07/26.
//

import Foundation
import CoreLocation

struct MallLocation: Identifiable, Equatable, Hashable {
    let id: UUID = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    var distanceInMeters: Double?

    var formattedDistance: String {
        guard let distanceInMeters else { return "-" }
        if distanceInMeters < 1000 {
            return "\(Int(distanceInMeters)) m"
        } else {
            return String(format: "%.1f km", distanceInMeters / 1000)
                .replacingOccurrences(of: ".", with: ",")
        }
    }

    static func == (lhs: MallLocation, rhs: MallLocation) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

extension CLLocationCoordinate2D: @retroactive Equatable, @retroactive Hashable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
