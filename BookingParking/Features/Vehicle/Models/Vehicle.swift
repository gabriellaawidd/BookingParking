import Foundation

struct Vehicle: Identifiable, Equatable, Hashable {
    let id: UUID = UUID()
    var backendId: Int?
    var name: String
    var licensePlate: String

    static func == (lhs: Vehicle, rhs: Vehicle) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

extension Vehicle {
    static let registered: [Vehicle] = [
        
        Vehicle(backendId: 1, name: "Toyota Avanza", licensePlate: "B 5678 CDE"),
        Vehicle(backendId: 2, name: "Toyota Rush", licensePlate: "B 9808 BGD"),
        Vehicle(backendId: 3, name: "Honda Brio", licensePlate: "B 0928 DGF")

//        Vehicle(name: "Toyota Avanza", licensePlate: "B 5678 CDE"),
//        Vehicle(name: "Toyota Rush", licensePlate: "B 9808 BGD"),
//        Vehicle(name: "Honda Brio", licensePlate: "B 0928 DGF")
    ]
}
