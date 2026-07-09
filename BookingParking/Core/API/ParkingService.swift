//
//  ParkingService.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import Foundation

protocol ParkingServicing {
    func createUser(name: String) async throws -> UserDTO
    func fetchUser(id: Int) async throws -> UserDTO
    func registerVehicle(ownerId: Int, plate: String) async throws -> VehicleDTO
    func fetchVehicle(id: Int) async throws -> VehicleDTO
    func createBooking(userId: Int, vehicleId: Int, durationMinutes: Int) async throws -> BookingDTO
    func openFlap(bookingId: Int) async throws
    func cancelBooking(bookingId: Int) async throws -> BookingDTO
    func fetchStallStatus() async throws -> StallStatusDTO
    func fetchBooking(id: Int) async throws -> BookingDTO
}

struct ParkingService: ParkingServicing {
    private let client = APIClient()

    func createUser(name: String) async throws -> UserDTO {
        let response: UserResponse = try await client.post("users", body: CreateUserRequest(name: name))
        return response.user
    }

    func fetchUser(id: Int) async throws -> UserDTO {
        let response: UserResponse = try await client.get(_path: "users/\(id)")
        return response.user
    }

    func registerVehicle(ownerId: Int, plate: String) async throws -> VehicleDTO {
        let response: VehicleResponse = try await client.post(
            "vehicles",
            body: CreateVehicleRequest(ownerId: ownerId, plate: plate)
        )
        return response.vehicle
    }

    func fetchVehicle(id: Int) async throws -> VehicleDTO {
        let response: VehicleResponse = try await client.get(_path: "vehicles/\(id)")
        return response.vehicle
    }

    func createBooking(userId: Int, vehicleId: Int, durationMinutes: Int) async throws -> BookingDTO {
        let response: BookingResponse = try await client.post(
            "book",
            body: CreateBookingRequest(userId: userId, vehicleId: vehicleId, durationMinutes: durationMinutes)
        )
        return response.booking
    }

    func openFlap(bookingId: Int) async throws {
        let _: OpenFlapResponse = try await client.post("open", body: BookingIDRequest(bookingId: bookingId))
    }

    func cancelBooking(bookingId: Int) async throws -> BookingDTO {
        let response: CancelBookingResponse = try await client.post("cancel", body: BookingIDRequest(bookingId: bookingId))
        return response.booking
    }

    func fetchStallStatus() async throws -> StallStatusDTO {
        try await client.get(_path: "status")
    }

    func fetchBooking(id: Int) async throws -> BookingDTO {
        let response: BookingResponse = try await client.get(_path: "booking/\(id)")
        return response.booking
    }
}
