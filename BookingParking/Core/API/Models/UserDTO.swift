//
//  UserDTO.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import Foundation

struct UserDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let vehicles: [VehicleDTO]
}

struct CreateUserRequest: Encodable {
    let name: String
}

struct UserResponse: Decodable {
    let ok: Bool
    let user: UserDTO
}
