//
//  VehicleDTO.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import Foundation

struct VehicleDTO: Codable, Identifiable {
    let id: Int
    let ownerId: Int
    let plate: String
}

struct CreateVehicleRequest: Encodable {
    let ownerId: Int
    let plate: String
}

struct VehicleResponse: Decodable {
    let ok: Bool
    let vehicle: VehicleDTO 
}
