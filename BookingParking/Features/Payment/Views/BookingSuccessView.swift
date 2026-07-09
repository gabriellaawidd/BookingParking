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
    

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.15))
                        .frame(width: 140, height: 140)
                    Circle()
                        .fill(Color.green)
                        .frame(width: 90, height: 90)
                    Image(systemName: "checkmark")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.white)
                }
                .padding(.vertical, 20)

                PaymentSummaryCard(
                    mallName: booking.mall.name,
                    slotInfo: booking.slot,
                    total: booking.total,
                    style: .plain
                )

                Divider()
                    .overlay(
                        Rectangle()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                            .foregroundStyle(Color(.systemGray4))
                    )

                VStack(alignment: .leading, spacing: 16) {
                    BookingDetailRow(title: "Date and Time", value: "\(booking.date) · \(booking.timeRange)")
                    BookingDetailRow(title: "Parking Slot", value: booking.slot)
                    BookingDetailRow(title: "Vehicle", value: booking.vehicle.licensePlate)
                    BookingDetailRow(title: "Payment Method", value: booking.paymentMethod ?? "QRIS")
                    BookingDetailRow(title: "Transaction Number", value: booking.transactionNumber)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle("Booking Success")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    goToHomeWithUpcomingSession()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
    }
    
    private func goToHomeWithUpcomingSession() {
           homeViewModel.updateSessionState(.upcoming(booking))
           path.removeLast(path.count)
       }
}

#Preview {
    NavigationStack {
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
}
