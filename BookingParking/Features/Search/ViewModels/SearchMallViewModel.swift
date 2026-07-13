//
//  SearchMallViewModel.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 07/07/26.
//

import Foundation
import CoreLocation

@Observable
class SearchMallViewModel {
    var query: String = ""
    var isLoading: Bool = false
    var errorMessage: String?

    @ObservationIgnored
    private var nearbyMalls: [MallLocation] = []

    private let service: MallLocationServicing

    init(service: MallLocationServicing = MallLocationService()) {
        self.service = service
    }

    var results: [MallLocation] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return nearbyMalls }
        return nearbyMalls.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.address.localizedCaseInsensitiveContains(query)
        }
    }

    var sectionTitle: String {
        query.trimmingCharacters(in: .whitespaces).isEmpty ? "Nearby" : "Search Result"
    }

    @MainActor
    func loadNearbyMalls(userLocation: CLLocationCoordinate2D?) async {
        isLoading = true
        errorMessage = nil
        do {
            nearbyMalls = try await service.fetchNearbyMalls(near: userLocation)
        } catch {
            errorMessage = "Couldn't load mall data. Try again."
        }
        isLoading = false
    }
}
