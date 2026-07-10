//
//  AppEnvironment.swift
//  BookingParking
//
//  Created by Patricia Putri Gautama on 10/07/26.
//

import Foundation

enum AppEnvironment {
    // kalo backend ready ganti jadi false --> ini masi pake mockup
    nonisolated static let useMockBackend = true

    nonisolated static var parkingService: ParkingServicing {
        useMockBackend ? MockParkingService() : ParkingService()
    }
}
