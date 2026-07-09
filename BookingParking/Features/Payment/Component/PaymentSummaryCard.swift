//
//  PaymentSummaryCard.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import SwiftUI

struct PaymentSummaryCard: View {
    enum Style {
        case tinted
        case plain
    }

    let mallName: String
    let slotInfo: String
    let total: Int
    var totalLabel: String = "Total"
    var style: Style = .tinted

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(mallName)
                    .font(.headline)
                Text(slotInfo)
                    .font(.subheadline)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(totalLabel)
                    .font(.subheadline)
                Text("Rp\(total)")
                    .font(.headline)
                    .foregroundStyle(Color.accentColor)
            }
        }
        .padding(style == .tinted ? 16 : 0)
        .background(style == .tinted ? Color(.systemGray6) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: style == .tinted ? 16 : 0, style: .continuous))
    }
}

#Preview {
    VStack(spacing: 20) {
        PaymentSummaryCard(
            mallName: "AEON Mall BSD City",
            slotInfo: "B2 · Red Zone · Slot A2",
            total: 10000
        )

        PaymentSummaryCard(
            mallName: "AEON Mall BSD City",
            slotInfo: "B2 · Red Zone · Slot A2",
            total: 10000,
            style: .plain
        )
    }
    .padding()
}
