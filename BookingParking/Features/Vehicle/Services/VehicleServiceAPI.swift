// MARK: - VehicleService.swift
import Foundation

protocol VehicleServiceProtocol {
    func fetchVehicles() async throws -> [Vehicle]
    func addVehicle(_ vehicle: Vehicle) async throws -> Vehicle
}

final class MockVehicleService: VehicleServiceProtocol {
    func fetchVehicles() async throws -> [Vehicle] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return Vehicle.registered
    }

    func addVehicle(_ vehicle: Vehicle) async throws -> Vehicle {
        try await Task.sleep(nanoseconds: 300_000_000)
        return vehicle
    }
}

final class APIVehicleService: VehicleServiceProtocol {
    func fetchVehicles() async throws -> [Vehicle] {
        let url = URL(string: "https://api.mauparkir.com/vehicles")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Vehicle].self, from: data)
    }

    func addVehicle(_ vehicle: Vehicle) async throws -> Vehicle {
        var request = URLRequest(url: URL(string: "https://api.mauparkir.com/vehicles")!)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(vehicle)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(Vehicle.self, from: data)
    }
}
