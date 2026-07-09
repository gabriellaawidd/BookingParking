//
//  PaymentSummaryCard.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import SwiftUI

struct PaymentSummaryCard: View {
    enum Style {
        case grouped 
        case filled
    }

    let mallName: String
    let slotInfo: String
    let total: Int
    var totalLabel: String = "Total"
    var style: Style = .filled

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
        .padding()
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var backgroundColor: Color {
        switch style {
        case .grouped:
            return Color(.systemGroupedBackground)
        case .filled:
            return Color(.systemBackground)
        }
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
            totalLabel: "Total Payment",
            style: .grouped
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
