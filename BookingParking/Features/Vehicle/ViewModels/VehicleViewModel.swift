import Foundation
import os

@Observable
class VehicleViewModel {
    var vehicles: [Vehicle] = []
    var selectedVehicle: Vehicle?
    var isLoading: Bool = false
    var errorMessage: String?

    private let service: VehicleServicing
    private let logger = Logger(subsystem: "com.bookingparking.app", category: "VehicleViewModel")

    init(service: VehicleServicing = VehicleService()) {
        self.service = service
    }

    @MainActor
    func loadVehicles() async {
        isLoading = true
        errorMessage = nil
        do {
            vehicles = try await service.fetchVehicles()
        } catch {
            handle(error, context: "loadVehicles")
        }
        isLoading = false
    }

    @MainActor
    func addVehicle(name: String, licensePlate: String) async {
        let newVehicle = Vehicle(name: name, licensePlate: licensePlate)
        do {
            try await service.addVehicle(newVehicle)
            vehicles.append(newVehicle)
        } catch {
            handle(error, context: "addVehicle")
        }
    }

    @MainActor
    func deleteVehicle(_ vehicle: Vehicle) async {
        do {
            try await service.deleteVehicle(id: vehicle.id)
            vehicles.removeAll { $0.id == vehicle.id }
            if selectedVehicle == vehicle {
                selectedVehicle = nil
            }
        } catch {
            handle(error, context: "deleteVehicle")
        }
    }

    private func handle(_ error: Error, context: String) {
        let vehicleError = (error as? VehicleError) ?? .unknown(underlying: error)
        errorMessage = vehicleError.errorDescription
        logger.error("[\(context)] \(String(describing: vehicleError))")
    }
}
