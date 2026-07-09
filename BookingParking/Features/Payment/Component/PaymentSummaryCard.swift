//
//  PaymentSummaryCard.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import SwiftUI

struct PaymentSummaryCard: View {
    let mallName: String
    let slotInfo: String
    let total: Int
    var totalLabel: String = "Total"
    var style: CardStyle = .filled

    enum CardStyle {
        case filled
        case plain
    }

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
        .padding(style == .filled ? 16 : 0)
        .background(style == .filled ? Color(.systemGray6) : Color.clear)
        .clipShape(style == .filled ? AnyShape(RoundedRectangle(cornerRadius: 16, style: .continuous)) : AnyShape(Rectangle())
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        PaymentSummaryCard(
            mallName: "AEON Mall BSD City",
            slotInfo: "B2 · Red Zone · Slot A2",
            total: 10000,
            style: .filled
        )
        PaymentSummaryCard(
            mallName: "AEON Mall BSD City",
            slotInfo: "B2 · Red Zone · Slot A2",
            total: 10000,
            totalLabel: "Total Payment",
            style: .plain
        )
    }
    .padding()
}
