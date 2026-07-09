//
//  UpcomingSessionCard.swift
//  C4_JasJus
//
//  Created by Gabriella Angelina Widjaja on 07/07/26.
//

//
//  UpcomingSessionCard.swift
//  C4_JasJus
//
//  Created by Gabriella Angelina Widjaja on 07/07/26.
//

import SwiftUI

struct UpcomingSessionCard: View {
    let session: Booking
    let onNavigate: () -> Void
    let onCallStaff: () -> Void

    private var formattedDate: String {
        session.startDateTime.formatted(.dateTime.weekday(.wide).day().month(.wide).year())
    }

    private var formattedTimeRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        let start = formatter.string(from: session.startDateTime)
        let end = formatter.string(from: session.endDateTime)
        return "\(start)-\(end)"
    }

    private var durationText: String {
        let duration = session.endDateTime.timeIntervalSince(session.startDateTime)
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60

        if hours > 0 && minutes > 0 {
            return "(\(hours) hour\(hours > 1 ? "s" : "") \(minutes) min)"
        } else if hours > 0 {
            return "(\(hours) hour\(hours > 1 ? "s" : ""))"
        } else {
            return "(\(minutes) min)"
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(session.mall.name)
                .font(.title3.bold())

            Text("Slot - \(session.slot)")
                .font(.subheadline)
                .foregroundColor(.primary.opacity(0.8))

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(formattedDate)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                HStack(spacing: 8) {
                    Image(systemName: "clock")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(formattedTimeRange)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 4)

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

                Button(action: onNavigate) {
                    Label("Navigate", systemImage: "location.fill")
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

//#Preview {
//    UpcomingSessionCard(
//        session: BookingSession(
//            mallName: "AEON Mall BSD City",
//            floor: "B2",
//            zone: "Red Zone",
//            slot: "A1",
//            bookingDateTime: .now.addingTimeInterval(3600),
//            sessionEndDate: .now.addingTimeInterval(7200),
//            staffNumber: "+622112345678"
//        ),
//        onNavigate: {},
//        onCallStaff: {}
//    )
//    .padding()
//}

#Preview {
    UpcomingSessionCard(
        session: Booking(
            mall: .sample,
            date: "9 Jul 2026",
            timeRange: "14.00-16.00",
            startDateTime: .now.addingTimeInterval(3600),
            endDateTime: .now.addingTimeInterval(7200),
            slot: "B2 · Red Zone · Slot A1",
            vehicle: Vehicle(name: "Toyota Avanza", licensePlate: "B 1234 ABC"),
            voucher: nil,
            paymentMethod: nil,
            pricePerHour: 5000,
            duration: "2 hours",
            total: 10000
        ),
        onNavigate: {},
        onCallStaff: {}
    )
    .padding()
}
