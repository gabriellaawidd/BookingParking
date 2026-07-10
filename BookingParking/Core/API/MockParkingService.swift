//
//  MockParkingService.swift
//  BookingParking
//
//  Created by Patricia Putri Gautama on 10/07/26.
//

import Foundation

struct MockParkingService: ParkingServicing {

    private func simulateDelay() async {
        try? await Task.sleep(nanoseconds: 500_000_000)
    }

    func createUser(name: String) async throws -> UserDTO {
        await simulateDelay()
        return UserDTO(id: 1, name: name, vehicle: [])
    }

    func fetchUser(id: Int) async throws -> UserDTO {
        await simulateDelay()
        return UserDTO(id: id, name: "Mock User", vehicle: [])
    }

    func registerVehicle(ownerId: Int, plate: String) async throws -> VehicleDTO {
        await simulateDelay()
        return VehicleDTO(id: Int.random(in: 100...999), ownerId: ownerId, plate: plate)
    }

    func fetchVehicle(id: Int) async throws -> VehicleDTO {
        await simulateDelay()
        return VehicleDTO(id: id, ownerId: 1, plate: "B 1234 ABC")
    }

    func createBooking(userId: Int, vehicleId: Int, durationMinutes: Int) async throws -> BookingDTO {
        await simulateDelay()
        let now = Int(Date().timeIntervalSince1970)
        return BookingDTO(
            id: Int.random(in: 1000...9999),
            userId: userId,
            vehicleId: vehicleId,
            flapId: "flap/01",
            state: .booked,
            startTime: now,
            endTime: now + (durationMinutes * 60),
            plannedDuration: durationMinutes * 60,
            arrivedAt: nil,
            leftAt: nil,
            actualDuration: nil
        )
    }

    func openFlap(bookingId: Int) async throws {
        await simulateDelay()
    }

    func cancelBooking(bookingId: Int) async throws -> BookingDTO {
        await simulateDelay()
        let now = Int(Date().timeIntervalSince1970)
        return BookingDTO(
            id: bookingId, userId: 1, vehicleId: 1, flapId: "flap/01",
            state: .cancelled, startTime: now, endTime: now,
            plannedDuration: nil, arrivedAt: nil, leftAt: nil, actualDuration: nil
        )
    }

    func fetchStallStatus() async throws -> StallStatusDTO {
        await simulateDelay()
        return StallStatusDTO(
            id: "flap/01", flapState: "down", presence: "free",
            bookedBy: nil, status: .free, overstay: false
        )
    }

    func fetchBooking(id: Int) async throws -> BookingDTO {
        await simulateDelay()
        let now = Int(Date().timeIntervalSince1970)
        return BookingDTO(
            id: id, userId: 1, vehicleId: 1, flapId: "flap/01",
            state: .active, startTime: now - 600, endTime: now + 6600,
            plannedDuration: 7200, arrivedAt: now - 300, leftAt: nil, actualDuration: nil
        )
    }
}
