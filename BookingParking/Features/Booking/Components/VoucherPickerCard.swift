//
//  VoucherPickerCard.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import SwiftUI

struct VoucherPickerCard: View {
    let voucherCode: String?
    let discountLabel: String?

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 2) {
                if voucherCode != nil {
                    Text("Voucher")
                        .font(.headline.bold())
                        .foregroundColor(.black)
                } else {
                    Text("Choose Voucher")
                        .font(.headline.bold())
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 12)
        .frame(height: 72)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray)
            )
    }
}

/// Self-contained "Voucher" row: owns the NavigationLink to ChooseVoucherView.
struct VoucherPickerRow: View {
    let voucherCode: String?
    let discountLabel: String?

    var body: some View {
        NavigationLink {
            ChooseVoucherView()
        } label: {
            VoucherPickerCard(voucherCode: voucherCode, discountLabel: discountLabel)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        VoucherPickerCard(voucherCode: nil, discountLabel: nil)
        VoucherPickerCard(voucherCode: "HEMAT10", discountLabel: "10% off")
    }
    .padding()
}
