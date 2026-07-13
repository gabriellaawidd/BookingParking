//
//  TicketHistoryCard.swift
//  BookingParking
//
//  Created by Patricia Putri Gautama on 13/07/26.
//
//
//// MARK: - TicketHistoryCard.swift
//import SwiftUI
//
//struct TicketHistoryCard: View {
//    let booking: Booking
//
//    private var formattedDate: String {
//        booking.startDateTime.formatted(.dateTime.day().month(.wide).year())
//    }
//
//    private var formattedTimeRange: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH.mm"
//        return "\(formatter.string(from: booking.startDateTime))-\(formatter.string(from: booking.endDateTime))"
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            HStack(spacing: 14) {
//                ZStack {
//                    Circle().fill(Color(.label).opacity(0.85)).frame(width: 44, height: 44)
//                    Image(systemName: "parkingsign")
//                        .font(.system(size: 18, weight: .semibold))
//                        .foregroundStyle(Color(.systemBackground))
//                }
//
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(booking.mall.name)
//                        .font(.headline)
//                    Text(booking.slot)
//                        .font(.subheadline)
//                        .foregroundStyle(.secondary)
//                        .lineLimit(1)
//
//                    HStack(spacing: 4) {
//                        Image(systemName: "calendar")
//                        Text(formattedDate)
//                        Image(systemName: "clock")
//                            .padding(.leading, 4)
//                        Text(formattedTimeRange)
//                    }
//                    .font(.caption)
//                    .foregroundStyle(.secondary)
//                }
//
//                Spacer(minLength: 0)
//
//                Text("Completed")
//                    .font(.caption2.bold())
//                    .foregroundStyle(.green)
//                    .padding(.horizontal, 10)
//                    .padding(.vertical, 4)
//                    .background(Capsule().fill(Color.green.opacity(0.15)))
//            }
//
//            Divider()
//
//            HStack {
//                Text("Total Paid")
//                    .font(.subheadline)
//                Spacer()
//                Text("− Rp\(booking.total.formattedThousands())")
//                    .font(.subheadline.bold())
//            }
//        }
//        .padding(20)
//        .background(Color(.systemGray6))
//        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
//    }
//}
//
//#Preview {
//    TicketHistoryCard(booking: Booking(
//        mall: .sample,
//        date: "5 Jul 2026",
//        timeRange: "10.00-12.00",
//        startDateTime: .now.addingTimeInterval(-86400 * 2),
//        endDateTime: .now.addingTimeInterval(-86400 * 2 + 7200),
//        slot: "B2 · Red Zone · Slot A1",
//        vehicle: Vehicle(name: "Toyota Avanza", licensePlate: "B 1234 ABC"),
//        voucher: nil,
//        paymentMethod: nil,
//        pricePerHour: 5000,
//        duration: "2 hours",
//        total: 10000
//    ))
//    .padding()
//}


// MARK: - TicketHistoryCard.swift
//import SwiftUI
//
//struct TicketHistoryCard: View {
//    let booking: Booking
//
//    private var formattedDate: String {
//        booking.startDateTime.formatted(.dateTime.day().month(.wide).year())
//    }
//
//    private var formattedTimeRange: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH.mm"
//        return "\(formatter.string(from: booking.startDateTime)) - \(formatter.string(from: booking.endDateTime))"
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            HStack(alignment: .top, spacing: 14) {
//                ZStack {
//                    Circle().fill(Color(.label).opacity(0.85)).frame(width: 44, height: 44)
//                    Image(systemName: "parkingsign")
//                        .font(.system(size: 18, weight: .semibold))
//                        .foregroundStyle(Color(.systemBackground))
//                }
//
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(booking.mall.name)
//                        .font(.headline)
//                        .lineLimit(2)                      // ← boleh wrap 2 baris
//                        .fixedSize(horizontal: false, vertical: true)
//
//                    Text(booking.slot)
//                        .font(.subheadline)
//                        .foregroundStyle(.secondary)
//                        .lineLimit(1)
//
//                    VStack(alignment: .leading, spacing: 2) {   // ← calendar & clock ditumpuk VERTICAL, bukan HStack sejajar
//                        HStack(spacing: 4) {
//                            Image(systemName: "calendar")
//                            Text(formattedDate)
//                        }
//                        HStack(spacing: 4) {
//                            Image(systemName: "clock")
//                            Text(formattedTimeRange)
//                                .lineLimit(1)
//                                .fixedSize(horizontal: true, vertical: false)   // ← cegah jam kepotong
//                        }
//                    }
//                    .font(.caption)
//                    .foregroundStyle(.secondary)
//                }
//
//                Spacer(minLength: 8)
//
//                Text("Completed")
//                    .font(.caption2.bold())
//                    .foregroundStyle(.green)
//                    .padding(.horizontal, 10)
//                    .padding(.vertical, 4)
//                    .background(Capsule().fill(Color.green.opacity(0.15)))
//                    .fixedSize()   // ← badge tidak ikut menyusut/terpotong
//            }
//
//            Divider()
//
//            HStack {
//                Text("Total Paid")
//                    .font(.subheadline)
//                Spacer()
//                Text("− Rp\(booking.total.formattedThousands())")
//                    .font(.subheadline.bold())
//            }
//        }
//        .padding(16)
//        .background(Color(.systemGray6))
//        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
//    }
//}
//
//#Preview {
//    TicketHistoryCard(booking: Booking(
//        mall: MallLocation(
//            name: "One Union Square Building",
//            address: "Jl. Union Square",
//            coordinate: .init(latitude: -6.3, longitude: 106.6)
//        ),
//        date: "13 Jul 2026",
//        timeRange: "11.00-12.00",
//        startDateTime: .now.addingTimeInterval(-3600),
//        endDateTime: .now.addingTimeInterval(-1800),
//        slot: "C1",
//        vehicle: Vehicle(name: "Toyota Avanza", licensePlate: "B 1234 ABC"),
//        voucher: nil,
//        paymentMethod: nil,
//        pricePerHour: 5000,
//        duration: "1 hour",
//        total: 5000
//    ))
//    .padding()
//}

// MARK: - TicketHistoryCard.swift
import SwiftUI
import CoreLocation

struct TicketHistoryCard: View {
    let booking: Booking

    private var formattedDate: String {
        booking.startDateTime.formatted(.dateTime.day().month(.wide).year())
    }

    private var formattedTimeRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        return "\(formatter.string(from: booking.startDateTime)) - \(formatter.string(from: booking.endDateTime))"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    Circle().fill(Color(.label).opacity(0.85)).frame(width: 44, height: 44)
                    Image(systemName: "parkingsign")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color(.systemBackground))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(booking.mall.name)
                        .font(.headline)
                        .lineLimit(2)                      // ← boleh wrap 2 baris
                        .fixedSize(horizontal: false, vertical: true)

                    Text(booking.slot)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)

                    VStack(alignment: .leading, spacing: 2) {   // ← calendar & clock ditumpuk VERTICAL, bukan HStack sejajar
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                            Text(formattedDate)
                        }
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                            Text(formattedTimeRange)
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)   // ← cegah jam kepotong
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }

                Spacer(minLength: 8)

                Text("Completed")
                    .font(.caption2.bold())
                    .foregroundStyle(.green)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.green.opacity(0.15)))
                    .fixedSize()   // ← badge tidak ikut menyusut/terpotong
            }

            Divider()

            HStack {
                Text("Total Paid")
                    .font(.subheadline)
                Spacer()
                Text("− Rp\(booking.total.formattedThousands())")
                    .font(.subheadline.bold())
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    TicketHistoryCard(booking: Booking(
        mall: MallLocation(
            name: "One Union Square Building",
            address: "Jl. Union Square",
            coordinate: .init(latitude: -6.3, longitude: 106.6)
        ),
        date: "13 Jul 2026",
        timeRange: "11.00-12.00",
        startDateTime: .now.addingTimeInterval(-3600),
        endDateTime: .now.addingTimeInterval(-1800),
        slot: "C1",
        vehicle: Vehicle(name: "Toyota Avanza", licensePlate: "B 1234 ABC"),
        voucher: nil,
        paymentMethod: nil,
        pricePerHour: 5000,
        duration: "1 hour",
        total: 5000
    ))
    .padding()
}
