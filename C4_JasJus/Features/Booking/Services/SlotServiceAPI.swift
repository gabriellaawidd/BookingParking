// MARK: - Features/Booking/Services/SlotServiceAPI.swift
import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case server(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL tidak valid"
        case .invalidResponse: return "Response server tidak valid"
        case .decodingFailed: return "Gagal parsing data dari server"
        case .server(let msg): return msg
        }
    }
}

struct SlotServiceAPI {
    static let baseURL = "https://api.jasjus.app/v1" // ganti sesuai backend beneran

    /// Ambil denah + status slot untuk mall & rentang waktu tertentu
    static func fetchFloorMap(
        mallId: String,
        date: String,
        startTime: String,
        endTime: String
    ) async throws -> FloorMap {
        guard var comps = URLComponents(string: "\(baseURL)/malls/\(mallId)/floor-map") else {
            throw APIError.invalidURL
        }
        comps.queryItems = [
            URLQueryItem(name: "date", value: date),
            URLQueryItem(name: "start_time", value: startTime),
            URLQueryItem(name: "end_time", value: endTime)
        ]
        guard let url = comps.url else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        // request.setValue("Bearer \(TokenManager.shared.token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw APIError.server("Gagal ambil denah parkir")
        }

        do {
            return try JSONDecoder().decode(FloorMap.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }

    /// Reserve slot pilihan (buat lock sementara sebelum "Pay Now")
    static func holdSlot(
        mallId: String,
        slotId: String,
        date: String,
        startTime: String,
        endTime: String
    ) async throws {
        guard let url = URL(string: "\(baseURL)/malls/\(mallId)/slots/\(slotId)/hold") else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode([
            "date": date, "start_time": startTime, "end_time": endTime
        ])

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw APIError.server("Slot sudah diambil orang lain")
        }
    }
}
