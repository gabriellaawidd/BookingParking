//
//  UserSession.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import Foundation

@Observable
class UserSession {
    private(set) var userId: Int?

    private let userIdKey = "com.bookingparking.userId"

    init() {
        userId = UserDefaults.standard.object(forKey: userIdKey) as? Int
    }

    @MainActor
    func ensureUser(name: String) async throws {
        guard userId == nil else { return }

        let service = ParkingService()
        let user = try await service.createUser(name: name)

        userId = user.id
        UserDefaults.standard.set(user.id, forKey: userIdKey)
    }
}
