//
//  VehicleModel.swift
//  C4_JasJus
//
//  Created by Patricia Putri Gautama on 06/07/26.
//

import Foundation

struct Vehicle: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var type: String
    var licensePlate: String
}

extension Vehicle {
    static let registered: [Vehicle] = [
        Vehicle(name: "Toyota Avanza", type: "MPV", licensePlate: "B 5678 CDE"),
        Vehicle(name: "Toyota Rush", type: "SUV", licensePlate: "B 9808 BGD"),
        Vehicle(name: "Honda Brio", type: "Hatchback", licensePlate: "B 0928 DGF")
    ]
}
