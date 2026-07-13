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
    @State private var showSuccess = false
    let homeViewModel: HomeViewModel

    var body: some View {
        VStack {
            VStack(spacing: 16) {
                PaymentSummaryCard(
                    mallName: viewModel.booking.mall.name,
                    slotInfo: viewModel.booking.slot,
                    total: viewModel.booking.total
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
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showSuccess) {
            BookingSuccessView(
                booking: viewModel.booking,
                path: $path,
                homeViewModel: homeViewModel
            )
            .presentationDetents([.height(500)])
            .presentationDragIndicator(.hidden)
            .presentationBackground(.regularMaterial)
        }
        .onChange(of: viewModel.isCheckingStatus) { oldValue, newValue in
            if oldValue == true && newValue == false {
                showSuccess = true
            }
        }
    }
}

