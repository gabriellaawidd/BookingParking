//
//  BookingBottomBar.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import SwiftUI

struct BookingBottomBar: View {
    let hasBooked: Bool
    let totalLabel: String
    let timeRangeLabel: String
    let durationLabel: String
    let isFormValid: Bool
    let isSubmitting: Bool
    let onPayNow: () -> Void
    
    @State private var showLateFeeInfo = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 8) {
                    Text(totalLabel)
                        .font(.title3.bold())
                    
                    Button {
                        showLateFeeInfo.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                    .popover(isPresented: $showLateFeeInfo) {
                        LateFeeInfoContent()
                            .presentationCompactAdaptation(.popover)
                    }
                }
                
                if hasBooked {
                    Text("\(durationLabel) \u{2022} \(timeRangeLabel)")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            
            Spacer()
            
            Button(action: onPayNow) {
                HStack(spacing: 8) {
                    if isSubmitting {
                        ProgressView().tint(.white)
                    }
                    Text(isFormValid ? "Pay Now" : "Book")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(isFormValid ? Color.blue : Color.gray.opacity(0.4))
                .cornerRadius(24)
            }
            .disabled(!isFormValid || isSubmitting)
        }
        .padding(.horizontal, 30)
        .padding(.top, 26)
        .padding(.bottom, 26)
        .background(
            Color(.systemBackground)
                .shadow(color: .black.opacity(0.05), radius: 8, y: -2)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

private struct LateFeeInfoContent: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            Text("Late Exit Fee")
                .font(.subheadline.bold())
                .foregroundStyle(Color.red)
            Text("Rp10,000/hour after parking expires.")
                .font(.caption)
                .foregroundColor(.primary)
        }
        .padding(14)
        .frame(maxWidth: 240, alignment: .leading)
    }
}

#Preview {
    VStack {
        Spacer()
        BookingBottomBar(
            hasBooked: true,
            totalLabel: "Rp 10.000",
            timeRangeLabel: "10.00 - 12.00",
            durationLabel: "2 hours",
            isFormValid: false,
            isSubmitting: false,
            onPayNow: {}
        )
    }
}
