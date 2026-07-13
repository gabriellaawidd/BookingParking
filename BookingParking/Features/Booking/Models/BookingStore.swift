//
//  BookingStore.swift
//  BookingParking
//
//  Created by Patricia Putri Gautama on 13/07/26.
//

import Foundation

@Observable
final class BookingStore {
    var bookings: [Booking] = []

    func add(_ booking: Booking) {
        bookings.append(booking)
    }

    var scheduleBookings: [Booking] {
        bookings
            .filter { $0.endDateTime > .now }
            .sorted { lhs, rhs in
                let lhsStatus = BookingStatus.status(for: lhs)
                let rhsStatus = BookingStatus.status(for: rhs)

                // Active selalu di atas
                if lhsStatus == .active && rhsStatus != .active {
                    return true
                }
                if rhsStatus == .active && lhsStatus != .active {
                    return false
                }

                // Kalau status sama (misal sama-sama upcoming), urutkan berdasarkan waktu mulai terdekat
                return lhs.startDateTime < rhs.startDateTime
            }
    }

    var historyBookings: [Booking] {
        bookings
            .filter { $0.endDateTime <= .now }
            .sorted { $0.startDateTime > $1.startDateTime }
    }
}
