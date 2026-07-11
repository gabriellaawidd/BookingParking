//
//  AppEnvironment.swift
//  BookingParking
//
//  Created by Patricia Putri Gautama on 10/07/26.
//

import Foundation

enum AppEnvironment {
    static let useMockBackend = false

    static var parkingService: ParkingServicing {
        useMockBackend ? MockParkingService() : ParkingService()
    }
}
