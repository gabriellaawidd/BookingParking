//
//  TicketScheduleCard.swift
//  BookingParking
//
//  Created by Patricia Putri Gautama on 13/07/26.
//

// MARK: - TicketScheduleCard.swift
import SwiftUI

struct TicketScheduleCard: View {
    let booking: Booking

    private var status: BookingStatus {
        BookingStatus.status(for: booking)
    }

    private var daysUntilStart: Int {
        Calendar.current.dateComponents([.day], from: .now, to: booking.startDateTime).day ?? 0
    }

    private var formattedDate: String {
        booking.startDateTime.formatted(.dateTime.day().month(.wide).year())
    }

    private var formattedTimeRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        return "\(formatter.string(from: booking.startDateTime))-\(formatter.string(from: booking.endDateTime))"
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(Color(.label).opacity(0.85)).frame(width: 44, height: 44)
                Image(systemName: "parkingsign")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(.systemBackground))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(booking.mall.name)
                    .font(.headline)
                Text(booking.slot)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                    Text(formattedDate)
                    Image(systemName: "clock")
                        .padding(.leading, 4)
                    Text(formattedTimeRange)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            statusBadge
        }
        .padding(20)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

//    private var statusBadge: some View {
//        VStack(spacing: 2) {
//            if status == .upcoming {
//                Text("Starts in")
//                    .font(.caption2)
//                    .foregroundStyle(.secondary)
//                Text("\(daysUntilStart)")
//                    .font(.title2.bold())
//                Text("Days")
//                    .font(.caption2)
//                    .foregroundStyle(.secondary)
//            } else {
//                Text(status.label)
//                    .font(.caption2.bold())
//                    .foregroundStyle(status.color.text)
//                    .padding(.horizontal, 10)
//                    .padding(.vertical, 4)
//                    .background(Capsule().fill(status.color.background))
//            }
//        }
//    }
    @ViewBuilder
    private var statusBadge: some View {
        switch status {
        case .upcoming:
            if daysUntilStart == 0 {
                Text("Today")
                    .font(.caption2.bold())
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.orange.opacity(0.15)))
            } else {
                VStack(spacing: 2) {
                    Text("Starts in").font(.caption2).foregroundStyle(.secondary)
                    Text("\(daysUntilStart)").font(.title2.bold())
                    Text("Days").font(.caption2).foregroundStyle(.secondary)
                }
            }
        case .active:
            Text("Active")
                .font(.caption2.bold())
                .foregroundStyle(.green)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Capsule().fill(Color.green.opacity(0.15)))
        case .completed:
            EmptyView()   // tidak akan terjadi di ScheduleCard
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        TicketScheduleCard(booking: Booking(
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
        ))

        TicketScheduleCard(booking: Booking(
            mall: .sample,
            date: "9 Jul 2026",
            timeRange: "10.00-12.00",
            startDateTime: .now.addingTimeInterval(-1800),
            endDateTime: .now.addingTimeInterval(1800),
            slot: "B2 · Red Zone · Slot A2",
            vehicle: Vehicle(name: "Toyota Rush", licensePlate: "B 5678 CDE"),
            voucher: nil,
            paymentMethod: nil,
            pricePerHour: 5000,
            duration: "2 hours",
            total: 10000
        ))
    }
    .padding()
}
