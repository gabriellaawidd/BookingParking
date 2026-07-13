//
//  BookingSuccessView.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//  Restyled to match the dark bottom-sheet mock, using existing app types.
//



import SwiftUI

struct BookingSuccessView: View {
    let booking: Booking
    var homeViewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // MARK: - Background layer (matches dark abstract background in the mock)
            backgroundLayer

            VStack(spacing: 0) {
                Spacer()

                // MARK: - Bottom sheet-styled card
                VStack(spacing: 0) {
                    // Close button (top-right, inside the sheet)
                    HStack {
                        Spacer()
                        Button {
                            goToHomeWithUpcomingSession()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.primary)
                                .frame(width: 42, height: 42)
                                .background(.ultraThinMaterial, in: Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                                )
                                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)

                    // Detail rows
                    VStack(alignment: .leading, spacing: 24) {
                        BookingDetailRow(title: "Location", value: booking.mall.name)

                        // Date & Time digabung: Time tampil di bawah Date, warna secondary
                        HStack(alignment: .top) {
                            Text("Date & Time")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(booking.date)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.primary)
                                Text(booking.timeRange)
                                    .font(.system(size: 14))
                                    .foregroundStyle(.secondary)
                            }
                        }

                        BookingDetailRow(title: "Vehicle", value: booking.vehicle.licensePlate)
                        BookingDetailRow(title: "Parking Slot", value: booking.slot)

                        Divider()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Total Paid")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                            Text("Rp \(Int(booking.total))")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(.primary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)

                    // Success state
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .stroke(Color.green, lineWidth: 2)
                                .frame(width: 48, height: 48)
                            Image(systemName: "checkmark")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(.green)
                        }
                        Text("Booking Success")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
                .frame(width: 386)
                .frame(minHeight: 459)
                .background(
                    Color(.systemBackground)
                        .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
                )
                .shadow(color: .black.opacity(0.08), radius: 40, x: 0, y: -10)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }

    // MARK: - Background

    private var backgroundLayer: some View {
        ZStack {
            // Ganti dengan Image("nama_asset") kalau sudah ada gambar bg-nya
            LinearGradient(
                colors: [Color(red: 0.10, green: 0.11, blue: 0.12),
                         Color(red: 0.18, green: 0.19, blue: 0.20),
                         Color(red: 0.05, green: 0.06, blue: 0.06)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Color.black.opacity(0.2)
        }
        .ignoresSafeArea()
    }

    // MARK: - Actions

    private func goToHomeWithUpcomingSession() {
        print("🟠 kembali ke Home, backendId:", booking.backendId as Any)
        homeViewModel.updateSessionState(.upcoming(booking), backendBookingId: booking.backendId)
        dismiss()
    }
}

// MARK: - Rounded top-corner helper

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview

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
        homeViewModel: HomeViewModel()
    )
}

// MARK: - Cara memanggil dari view lain (mis. dari halaman Payment)
//
// struct PaymentView: View {
//     @State private var showBookingSuccess = false
//     @State private var completedBooking: Booking?
//     var homeViewModel: HomeViewModel
//
//     var body: some View {
//         Button("Bayar") {
//             // ...proses pembayaran, lalu:
//             completedBooking = booking
//             showBookingSuccess = true
//         }
//         .sheet(isPresented: $showBookingSuccess) {
//             if let completedBooking {
//                 BookingSuccessView(booking: completedBooking, homeViewModel: homeViewModel)
//                     .presentationDetents([.height(459)])
//                     .presentationDragIndicator(.hidden)
//                     .presentationCornerRadius(40)
//             }
//         }
//     }
// }
