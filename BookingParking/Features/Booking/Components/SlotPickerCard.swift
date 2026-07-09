//
//  SlotPickerCard.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import SwiftUI

struct SlotPickerCard: View {
    let slotCode: String?
    let timeRangeLabel: String
    let dayRangeLabel: String

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 2) {
                if let slotCode = slotCode {
                    Text("Parking Slot: \(slotCode)")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.bottom, 2)

                    HStack {
                        Text(dayRangeLabel)
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(.systemGray5))
                            .cornerRadius(4)

                        Text(timeRangeLabel)
                            .font(.subheadline)
                            .foregroundStyle(.black)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(.systemGray5))
                            .cornerRadius(4)
                    }

                } else {
                    Text("Choose slot")
                        .font(.headline.bold())
                        .foregroundColor(.primary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 12)
        .frame(height: 72)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray)
            )
    }
}

struct ParkingSlotPickerRow: View {
    let viewModel: BookingFormViewModel

    @State private var parkingLotViewModel: ParkingLotViewModel?

    var body: some View {
        NavigationLink {
            ChooseParkingSlotView(
                bookingViewModel: viewModel,
                viewModel: currentParkingLotViewModel
            )
        } label: {
            SlotPickerCard(
                slotCode: viewModel.selectedSlot,
                timeRangeLabel: viewModel.timeRangeLabel,
                dayRangeLabel: viewModel.dayRangeLabel
            )
        }
    }

    private var currentParkingLotViewModel: ParkingLotViewModel {
        if let existing = parkingLotViewModel {
            return existing
        }
        let newViewModel = ParkingLotViewModel(mall: viewModel.mall)
        parkingLotViewModel = newViewModel
        return newViewModel
    }
}

#Preview {
    VStack(spacing: 12) {
        SlotPickerCard(slotCode: nil, timeRangeLabel: "", dayRangeLabel: "")
        SlotPickerCard(slotCode: "A-12", timeRangeLabel: "10.00 - 12.00", dayRangeLabel: "Today")
    }
    .padding()
}
