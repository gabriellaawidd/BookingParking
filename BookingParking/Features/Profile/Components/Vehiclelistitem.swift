//
//  Vehiclelistitem.swift
//  BookingParking
//
//  Created by M. TAQWA ADDARI on 10/07/26.
//

import SwiftUI

struct VehicleListItem: View {
    let vehicle: Vehicle
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(vehicle.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)

                    Text(vehicle.licensePlate)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.gray.opacity(0.6))
            }
            .padding(.horizontal, 16)
            
            .frame(width: 360, height: 65)
            
           
            .background(Color.white)
            
           
            .clipShape(RoundedRectangle(cornerRadius: 14))
            
           
            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    ZStack {
        
        Color.gray.opacity(0.1).ignoresSafeArea()
        
        VehicleListItem(
            vehicle: Vehicle(name: "Toyota Avanza", licensePlate: "B 5678 CDE"),
            onTap: {}
        )
    }
}
