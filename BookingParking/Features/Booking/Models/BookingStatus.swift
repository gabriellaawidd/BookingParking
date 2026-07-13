//
//  BookingStatus.swift
//  BookingParking
//
//  Created by Patricia Putri Gautama on 13/07/26.
//

import SwiftUI

enum BookingStatus {
    case upcoming
    case active
    case completed

    static func status(for booking: Booking) -> BookingStatus {
        let now = Date.now
        if now < booking.startDateTime {
            return .upcoming
        } else if now < booking.endDateTime {
            return .active
        } else {
            return .completed
        }
    }

    var label: String {
        switch self {
        case .upcoming: return "Upcoming"
        case .active: return "Active"
        case .completed: return "Completed"
        }
    }

    var color: (text: Color, background: Color) {
        switch self {
        case .upcoming: return (.orange, Color.orange.opacity(0.15))
        case .active: return (.green, Color.green.opacity(0.15))
        case .completed: return (.gray, Color.gray.opacity(0.15))
        }
    }
}
