// MARK: - SearchMallViewModel.swift
import Foundation
import Combine

@MainActor
final class SearchMallViewModel: ObservableObject {
    @Published var query: String = "" {
        didSet { search() }
    }
    @Published var results: [Mall] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service: MallServiceProtocol
    private var currentTask: Task<Void, Never>?

    init(service: MallServiceProtocol = MockMallService()) {
        self.service = service
        loadNearby()
    }

    var sectionTitle: String {
        query.isEmpty ? "Nearby" : "Results"
    }

    func loadNearby() {
        currentTask?.cancel()
        currentTask = Task {
            isLoading = true
            errorMessage = nil        // ← RESET dulu di awal
            defer { isLoading = false }
            do {
                let malls = try await service.fetchNearbyMalls()
                try Task.checkCancellation()
                results = malls
            } catch is CancellationError {
                return
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    private func search() {
        currentTask?.cancel()

        guard !query.isEmpty else {
            loadNearby()
            return
        }

        currentTask = Task {
            isLoading = true
            errorMessage = nil        // ← RESET dulu di awal
            defer { isLoading = false }
            do {
                try await Task.sleep(nanoseconds: 250_000_000)
                try Task.checkCancellation()
                let malls = try await service.searchMalls(query: query)
                try Task.checkCancellation()
                results = malls
            } catch is CancellationError {
                return
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
