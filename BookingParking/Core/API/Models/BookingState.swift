//
//  BookingState.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import Foundation

enum BookingState: String, Codable {
    case booked
    case active
    case done
    case cancelled
}

extension BookingState {
    func toSessionState(session: Booking) -> HomeSessionState {
        switch self {
        case .booked:
            return .upcoming(session)
        case .active:
            return .active(session)
        case .done, .cancelled:
            return .empty
        }
    }
}
