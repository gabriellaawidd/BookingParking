//
//  MallCard.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 07/07/26.
//

import SwiftUI
internal import _LocationEssentials

struct MallCard: View {
    let mall: MallLocation
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(Color(.label).opacity(0.85)).frame(width: 44, height: 44)
                Image(systemName: "mappin")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(.systemBackground))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(mall.name).font(.headline)
                Text("\(mall.formattedDistance) · \(mall.address)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
        }
        .padding(20)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    VStack(spacing: 12) {
        MallCard(mall: MallLocation(
            name: "AEON Mall BSD City",
            address: "Jalan BSD Raya Utama, Tangerang",
            coordinate: .init(latitude: -6.3025, longitude: 106.6524),
            distanceInMeters: 850
        ))
        MallCard(mall: MallLocation(
            name: "The Breeze",
            address: "Jalan BSD Grand Boulevard",
            coordinate: .init(latitude: -6.3013, longitude: 106.6488),
            distanceInMeters: 4200
        ))
        MallCard(mall: MallLocation(
            name: "QBIG BSD City",
            address: "Jalan BSD Raya Utama, Tangerang",
            coordinate: .init(latitude: -6.2975, longitude: 106.6605),
            distanceInMeters: nil
        ))
    }
    .padding()
}
