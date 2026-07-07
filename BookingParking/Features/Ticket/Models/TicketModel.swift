// MARK: - TicketModels.swift
import Foundation

enum TicketStatus {
    case upcoming
    case completed
    case canceled

    var label: String {
        switch self {
        case .upcoming: return ""
        case .completed: return "Completed"
        case .canceled: return "Canceled"
        }
    }

    var color: (text: String, background: String) {
        switch self {
        case .upcoming: return ("", "")
        case .completed: return ("green", "greenBg")
        case .canceled: return ("red", "redBg")
        }
    }
}

struct TicketReservation: Identifiable {
    let id = UUID()
    let mallName: String
    let zone: String
    let date: String
    let timeRange: String
    let status: TicketStatus
    let daysUntilStart: Int?      // dipakai untuk Schedule ("Starts in X Days")
    let amount: Int                // total dibayar / refund
    let isRefund: Bool             // true kalau "Refunded" bukan "Total Paid"
    let imageName: String
}

extension TicketReservation {
    
    static let upcomingList: [TicketReservation] = [
        TicketReservation(
            mallName: "AEON Mall BSD City",
            zone: "B2, Red Zone",
            date: "Sunday, 5 July 2026",
            timeRange: "13.00-15.00 (2 hours)",
            status: .upcoming,
            daysUntilStart: 2,
            amount: 5000,
            isRefund: false,
            imageName: "aeon_mall"
        ),
        TicketReservation(
            mallName: "AEON Mall BSD City",
            zone: "B2, Red Zone",
            date: "Sunday, 5 July 2026",
            timeRange: "13.00-15.00 (2 hours)",
            status: .upcoming,
            daysUntilStart: 2,
            amount: 5000,
            isRefund: false,
            imageName: "aeon_mall"
        )
    ]

    static let historyList: [TicketReservation] = [
        TicketReservation(
            mallName: "AEON Mall BSD City",
            zone: "B2, Red Zone",
            date: "Sunday, 5 July 2026",
            timeRange: "13.00-15.00 (2 hours)",
            status: .completed,
            daysUntilStart: nil,
            amount: 5000,
            isRefund: false,
            imageName: "aeon_mall"
        ),
        TicketReservation(
            mallName: "AEON Mall BSD City",
            zone: "B2, Red Zone",
            date: "Sunday, 5 July 2026",
            timeRange: "13.00-15.00 (2 hours)",
            status: .canceled,
            daysUntilStart: nil,
            amount: 5000,
            isRefund: true,
            imageName: "aeon_mall"
        ),
        TicketReservation(
            mallName: "AEON Mall BSD City",
            zone: "B2, Red Zone",
            date: "Sunday, 5 July 2026",
            timeRange: "13.00-15.00 (2 hours)",
            status: .completed,
            daysUntilStart: nil,
            amount: 5000,
            isRefund: false,
            imageName: "aeon_mall"
        )
    ]
}
