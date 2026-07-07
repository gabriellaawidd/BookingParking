// MARK: - MallService.swift
import Foundation

protocol MallServiceProtocol {
    func fetchNearbyMalls() async throws -> [Mall]
    func searchMalls(query: String) async throws -> [Mall]
}

// Implementasi SEKARANG — pakai data dummy
final class MockMallService: MallServiceProtocol {
    func fetchNearbyMalls() async throws -> [Mall] {
        try await Task.sleep(nanoseconds: 300_000_000) // simulasi delay network
        return Mall.recentList
    }

    func searchMalls(query: String) async throws -> [Mall] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return Mall.recentList.filter {
            $0.name.localizedCaseInsensitiveContains(query)
        }
    }
}

// Implementasi NANTI — tinggal aktifkan ini kalau API sudah siap
final class APIMallService: MallServiceProtocol {
    func fetchNearbyMalls() async throws -> [Mall] {
        // contoh nanti:
        // let url = URL(string: "https://api.mauparkir.com/malls/nearby")!
        // let (data, _) = try await URLSession.shared.data(from: url)
        // return try JSONDecoder().decode([Mall].self, from: data)
        fatalError("Belum diimplementasi")
    }

    func searchMalls(query: String) async throws -> [Mall] {
        fatalError("Belum diimplementasi")
    }
}
