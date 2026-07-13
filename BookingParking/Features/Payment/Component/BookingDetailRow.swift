//
//  BookingDetailRow.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import SwiftUI

struct BookingDetailRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    VStack(spacing: 10) {
        BookingDetailRow(title: "Date and Time", value: "25 April 2025 · 10AM - 12PM")
        BookingDetailRow(title: "Parking Slot", value: "B2 · Red Zone · Slot A2")
    }
    .padding()
}
