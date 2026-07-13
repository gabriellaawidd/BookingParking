//
//  VehiclePickerView.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import SwiftUI

struct VehiclePickerView: View {
    let viewModel: BookingFormViewModel
    let onAddVehicleTapped: () -> Void
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            VStack {
                header
                
                if isExpanded {
                    vehicleList
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .animation(.easeInOut(duration: 0.2), value: isExpanded)
            
            if isExpanded {
                AddVehicleButton(action: onAddVehicleTapped)
            }
        }
    }
    
    private var header: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded.toggle()
            }
        } label: {
            HStack {
                headerContent
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
            }
            .padding(.horizontal, 12)
            .frame(height: 72)
        }
    }
    
    @ViewBuilder
    private var headerContent: some View {
        if isExpanded {
            Text("Choose Vehicle")
                .font(.headline.bold())
                .foregroundColor(.primary)
        } else if let vehicle = viewModel.selectedVehicle {
            VStack(alignment: .leading, spacing: 2) {
                Text(vehicle.name)
                    .font(.body)
                    .foregroundColor(.primary)
                Text(vehicle.licensePlate)
                    .font(.subheadline)
                    .foregroundStyle(.black)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color(.systemGray5))
                    .cornerRadius(4)
            }
        } else {
            Text("Choose Vehicle")
                .font(.headline.bold())
                .foregroundColor(.primary)
            
        }
    }
    
    private var vehicleList: some View {
        VStack {
            ForEach(viewModel.vehicles) { vehicle in
                Divider()
                VehicleSelectionRow(
                    vehicle: vehicle,
                    isSelected: viewModel.selectedVehicle?.id == vehicle.id,
                    onSelect: {
                        viewModel.selectedVehicle = vehicle
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isExpanded = false
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
}


private struct AddVehicleButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: "plus.circle.fill")
                Text("Add Vehicle")
            }
            .font(.subheadline.bold())
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color.blue, style: StrokeStyle(lineWidth: 1.5, dash: [6]))
            )
        }
        .buttonStyle(.plain)
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
}

#Preview {
    VehiclePickerView(viewModel: BookingFormViewModel(mall: .sample)) {
    }
    .padding()
}
