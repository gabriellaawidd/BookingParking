//
//  VehicleSelectionRow.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import SwiftUI

struct VehicleSelectionRow: View {
    let vehicle: Vehicle
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                Image(systemName: "car.side.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(.primary)
                    .frame(width: 32, height: 32)

                VStack(alignment: .leading, spacing: 4) {
                    Text(vehicle.name)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(vehicle.licensePlate)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                }

                Spacer()

                Image(systemName: isSelected ? "smallcircle.filled.circle" : "circle")
                    .foregroundStyle(isSelected ? Color.accentColor : Color(.systemGray3))
                    .font(.system(size: 20))
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 4) {
        VehicleSelectionRow(
            vehicle: Vehicle(name: "Toyota Avanza", licensePlate: "B 5678 CDE"),
            isSelected: true,
            onSelect: {}
        )
        VehicleSelectionRow(
            vehicle: Vehicle(name: "Veloz", licensePlate: "B 1234 THB"),
            isSelected: false,
            onSelect: {}
        )
    }
    .padding()
}
