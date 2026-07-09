import SwiftUI

enum SlotStatus: String, Codable {
    case available
    case occupied
    case priority

    var color: Color {
        switch self {
        case .available: return Color(red: 0.36, green: 0.78, blue: 0.51)
        case .occupied:  return Color(.systemGray4)
        case .priority:  return Color(red: 0.35, green: 0.6, blue: 0.98)
        }
    }
}

struct ParkingSlot: Identifiable, Codable, Equatable {
    let id: String
    let zone: String
    var status: SlotStatus
    var isHandicap: Bool = false
}

struct SlotColumn: Identifiable {
    let id = UUID()
    let codes: [String]
}

struct SlotSection: Identifiable {
    let id = UUID()
    let columns: [SlotColumn]
}

struct FloorMap: Codable {
    let mallId: String
    let floorId: String
    let backgroundImageURL: String?
    let slots: [ParkingSlot]
}
