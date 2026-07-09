//
//  StallStatusDTO.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import Foundation

enum StallStatus: String, Codable {
    case free, booked, occupied
}

struct StallStatusDTO: Decodable {
    let id: String
    let flapState: String
    let presence: String
    let bookedBy: Int?
    let status: StallStatus
    let overstay: Bool
}
