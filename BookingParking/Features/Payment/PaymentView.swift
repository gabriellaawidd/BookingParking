//
//  PaymentView.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

//
//  PaymentView.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import SwiftUI

struct PaymentView: View {
    @State var viewModel: PaymentViewModel
    @Binding var path: NavigationPath
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
                VStack(spacing: 16) {
                    PaymentSummaryCard(
                        mallName: viewModel.booking.mall.name,
                        slotInfo: viewModel.booking.slot,
                        total: viewModel.booking.total,
                    )

                    QRISPaymentCard(
                        mallName: viewModel.booking.mall.name,
                        qrImage: viewModel.qrImage,
                        timeRemainingLabel: viewModel.timeRemainingLabel
                    )
                }
                .padding()


            Button {
                Task {
                    await viewModel.refreshStatus()
                }
            } label: {
                HStack {
                    if viewModel.isCheckingStatus {
                        ProgressView()
                            .tint(.white)
                    }
                    Text("Refresh Status")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.accentColor)
                .clipShape(Capsule())
            }
            .disabled(viewModel.isCheckingStatus)
            .padding(.horizontal)
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.isCheckingStatus) { oldValue, newValue in
            if oldValue == false && newValue == true {
                path.append(viewModel.booking)
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    NavigationStack {
        PaymentView(
            viewModel: PaymentViewModel(
                booking: Booking(
                    mall: .sample,
                    date: "9 Jul 2026",
                    timeRange: "14.00 - 16.00",
                    slot: "B2 · Red Zone · Slot A2",
                    vehicle: Vehicle(name: "Toyota Avanza", licensePlate: "B 1234 ABC"),
                    voucher: nil,
                    paymentMethod: nil,
                    pricePerHour: 5000,
                    duration: "2 hours",
                    total: 10000
                )
            ), path: .constant(NavigationPath())
        )
    }
}
