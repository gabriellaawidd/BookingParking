//
//  ActiveSessionCard.swift
//  C4_JasJus
//
//  Created by Gabriella Angelina Widjaja on 07/07/26.
//

import SwiftUI

struct ActiveSessionCard: View {
    let session: BookingSession
    let remainingTime: String
    let onOpenSlot: () -> Void
    let onCallStaff: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Text(session.mallName)
                .font(.title3.bold())

            Text("\(session.floor) · \(session.zone) · Slot \(session.slot)")
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
                    Label("Open Slot", systemImage: "lock.fill")
                        .font(.subheadline.bold())
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
        session: BookingSession(
            mallName: "AEON Mall BSD City",
            floor: "B2",
            zone: "Red Zone",
            slot: "A1",
            bookingDateTime: .now,
            sessionEndDate: .now.addingTimeInterval(5449),
            staffNumber: "+622112345678"
        ),
        remainingTime: "01:30:49",
        onOpenSlot: {},
        onCallStaff: {}
    )
}
