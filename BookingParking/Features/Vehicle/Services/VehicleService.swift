import Foundation

enum VehicleError: LocalizedError {
    case network
    case notFound
    case invalidData
    case unauthorized
    case unknown(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .network:
            return "Tidak ada koneksi internet. Periksa jaringan kamu dan coba lagi."
        case .notFound:
            return "Kendaraan tidak ditemukan."
        case .invalidData:
            return "Data kendaraan tidak valid."
        case .unauthorized:
            return "Sesi kamu berakhir. Silakan login kembali."
        case .unknown:
            return "Terjadi kesalahan. Coba lagi beberapa saat."
        }
    }
}

protocol VehicleServicing {
    func fetchVehicles() async throws -> [Vehicle]
    func addVehicle(_ vehicle: Vehicle) async throws
    func deleteVehicle(id: UUID) async throws
}

struct VehicleService: VehicleServicing {
    func fetchVehicles() async throws -> [Vehicle] {
            return [
                Vehicle(name: "Toyota Avanza", licensePlate: "B 1234 ABC"),
                Vehicle(name: "Honda Beat", licensePlate: "B 5678 XYZ")
            ]
        }

    func addVehicle(_ vehicle: Vehicle) async throws {
        //kirim ke backend, mapping error yang sama seperti di atas
    }

    func deleteVehicle(id: UUID) async throws {
        //kirim ke backend, mapping error yang sama seperti di atas
    }

    /// Ubah error teknis (URLError) jadi VehicleError yang lebih bermakna untuk UI.
    private func mapURLError(_ error: URLError) -> VehicleError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost, .timedOut:
            return .network
        case .userAuthenticationRequired:
            return .unauthorized
        default:
            return .unknown(underlying: error)
        }
    }
}
