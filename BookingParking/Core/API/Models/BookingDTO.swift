//
//  BookingDTO.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import Foundation

struct BookingDTO: Codable, Identifiable {
    let id: Int
    let userId: Int?
    let vehicleId: Int?
    let flapId: String?
    let state: BookingState
    let startTime: Int
    let endTime: Int
    let plannedDuration: Int?
    let arrivedAt: Int?
    let leftAt: Int?
    let actualDuration: Int?
}

struct CreateBookingRequest: Encodable {
    let userId: Int
    let vehicleId: Int
    let durationMinutes: Int
}

struct BookingResponse: Decodable {
    let ok: Bool
    let booking: BookingDTO
}

struct BookingIDRequest: Encodable {
    let bookingId: Int
}

struct OpenFlapResponse: Decodable {
    let ok: Bool
    let message: String
}

struct CancelBookingResponse: Decodable {
    let ok: Bool
    let message: String
    let booking: BookingDTO
}
