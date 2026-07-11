//
//  ActiveSessionCard.swift
//  C4_JasJus
//
//  Created by Gabriella Angelina Widjaja on 07/07/26.
//

import SwiftUI

struct ActiveSessionCard: View {
    let session: Booking
    let isOpeningSlot: Bool
    let remainingTime: String
    let onOpenSlot: () -> Void
    let onCallStaff: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Text(session.mall.name)
                .font(.title3.bold())
            
            Text("Slot \(session.slot)")
                .font(.subheadline)
                .foregroundColor(.primary.opacity(0.8))
            
            Text(remainingTime)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(Color.blue)
            
            Text("Until Your Booked Session Ends")
                .font(.caption)
                .italic()
                .foregroundColor(.gray)
            
            HStack(spacing: 8) {
                Button(action: onCallStaff) {
                    Label("Call Staff", systemImage: "phone.fill")
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                        .frame(width: 160)
                        .padding(.vertical, 14)
                        .background(Color(.systemGray5))
                        .cornerRadius(24)
                }
                
                Button(action: onOpenSlot) {
                    HStack {
                        if isOpeningSlot {
                            ProgressView().tint(.white)
                        }
                        Label("Open Slot", systemImage: "lock.fill")
                            .font(.subheadline.bold())
                    }
                    .foregroundColor(.white)
                    .frame(width: 160)
                    .padding(.vertical, 14)
                    .background(Color.blue)
                    .cornerRadius(24)
                }
            }
            .padding(.top, 8)
        }
        .sessionCardStyle()
    }
}

#Preview {
    ActiveSessionCard(
        session: Booking(
            mall: .sample,
            date: "9 Jul 2026",
            timeRange: "14.00-16.00",
            startDateTime: .now,
            endDateTime: .now.addingTimeInterval(5449),
            slot: "B2 · Red Zone · Slot A1",
            vehicle: Vehicle(name: "Toyota Avanza", licensePlate: "B 1234 ABC"),
            voucher: nil,
            paymentMethod: nil,
            pricePerHour: 5000,
            duration: "2 hours",
            total: 10000
        ), isOpeningSlot: true,
        remainingTime: "01:30:49",
        onOpenSlot: {},
        onCallStaff: {}
    )
}
