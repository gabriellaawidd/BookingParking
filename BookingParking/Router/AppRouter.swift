// MARK: - AppRouter.swift
import SwiftUI
import Combine

enum AppRoute: Hashable {
    case bookingDetails(Mall)
    case chooseParkingSlot(Mall)
//    case bookingDetails(Booking)
    case chooseVehicle
    case addVehicle
    case ticket
    case profile

    // MARK: - Manual Equatable
    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        switch (lhs, rhs) {
        case (.bookingDetails(let l), .bookingDetails(let r)):
            return l.id == r.id
        case (.chooseParkingSlot(let l), .chooseParkingSlot(let r)):
            return l.id == r.id
//        case (.bookingDetails(let l), .bookingDetails(let r)):
//            return l.id == r.id
        case (.chooseVehicle, .chooseVehicle):
            return true
        case (.addVehicle, .addVehicle):
            return true
        case (.ticket, .ticket):
            return true
        case (.profile, .profile):
            return true
        default:
            return false
        }
    }

    // MARK: - Manual Hashable
    func hash(into hasher: inout Hasher) {
        switch self {
        case .bookingDetails(let mall):
            hasher.combine("mallDetail")
            hasher.combine(mall.id)
//        case .bookingDetails(let booking):
//            hasher.combine("bookingDetails")
//            hasher.combine(booking.id)
        case .chooseVehicle:
            hasher.combine("chooseVehicle")
        case .chooseParkingSlot(let mall):
            hasher.combine("chooseParkingSlot")
            hasher.combine(mall.id)
        case .addVehicle:
            hasher.combine("addVehicle")
        case .ticket:
            hasher.combine("ticket")
        case .profile:
            hasher.combine("profile")
        }
    }
}

@MainActor
final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var selectedTab: String = "Home"

    @Published var vehicles: [Vehicle] = Vehicle.registered
    @Published var selectedVehicle: Vehicle?
    @Published var currentBooking: Booking?
    
    // Tambahin ke AppRouter
    @Published var draftDate: Date?
    @Published var draftStartTime: Date?
    @Published var draftEndTime: Date?
    @Published var draftSlotID: String?

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        if !path.isEmpty { path.removeLast() }
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
