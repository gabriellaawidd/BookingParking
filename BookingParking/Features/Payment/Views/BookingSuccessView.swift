//
//  BookingSuccessView.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import SwiftUI

struct BookingSuccessView: View {
    let booking: Booking
    @Binding var path: NavigationPath
    var homeViewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 20) {
                    BookingDetailRow(title: "Location", value: booking.mall.name)
                    BookingDetailRow(title: "Date", value: booking.date)
                    BookingDetailRow(title: "Time", value: booking.timeRange)
                    BookingDetailRow(title: "Vehicle", value: booking.vehicle.licensePlate)
                    BookingDetailRow(title: "Parking Spot", value: booking.slot)
                }
                .padding(.top, 12)

                Divider()
                    .padding(.vertical, 24)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Paid")
                        .font(.headline)
                        .foregroundStyle(.gray)
                    Text("Rp\(booking.total)")
                        .font(.largeTitle)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .stroke(Color.green, lineWidth: 1.5)
                            .frame(width: 70, height: 70)
                        Image(systemName: "checkmark")
                            .font(.system(.title).bold())
                            .foregroundStyle(Color.green)
                    }
                    Text("Booking Success")
                        .font(.subheadline)
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        goToHomeWithUpcomingSession()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.black)
                            .frame(width: 32, height: 32)
                            .background(.background)
                            .clipShape(Circle())
                    }
                }
            }
        }
    }

    private func goToHomeWithUpcomingSession() {
        homeViewModel.updateSessionState(.upcoming(booking), backendBookingId: booking.backendId)
        path.removeLast(path.count)
        dismiss()
    }
}

#Preview {
    BookingSuccessView(
        booking: Booking(
            mall: .sample,
            date: "25 April 2025",
            timeRange: "10AM - 12PM",
            startDateTime: Date(),
            endDateTime: Date().addingTimeInterval(7200),
            slot: "B2 · Red Zone · Slot A2",
            vehicle: Vehicle(name: "Toyota Avanza", licensePlate: "B 5678 CDE"),
            voucher: nil,
            paymentMethod: "QRIS",
            pricePerHour: 5000,
            duration: "2 hours",
            total: 10000
        ),
        path: .constant(NavigationPath()),
        homeViewModel: HomeViewModel()
    )
}
