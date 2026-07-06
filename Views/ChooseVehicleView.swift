// MARK: - ChooseVehicleView.swift
import SwiftUI
import Combine

struct ChooseVehicleView: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(router.vehicles) { vehicle in
                        VehicleRow(
                            vehicle: vehicle,
                            isSelected: router.selectedVehicle == vehicle
                        ) {
                            router.selectedVehicle = vehicle
                        }
                    }

                    Button {
                        router.push(.addVehicle)
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                            Text("Add Vehicle")
                                .foregroundColor(.blue)
                                .font(.subheadline.bold())
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.blue.opacity(0.4), style: StrokeStyle(lineWidth: 1, dash: [6]))
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
            }

            Spacer()
        }
        .navigationBarHidden(true)
    }

    private var header: some View {
        HStack {
            Button {
                router.pop()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
            }
            Spacer()
            Text("Choose Vehicle")
                .font(.title3.bold())
            Spacer()
            Color.clear.frame(width: 36, height: 36)
        }
        .padding(.horizontal)
        .padding(.top, 50)
        .padding(.bottom, 12)
    }
}

struct VehicleRow: View {
    let vehicle: Vehicle
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 14) {
                Image(systemName: "car.side.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.primary)
                    .frame(width: 48, height: 48)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 4) {
                    Text(vehicle.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(vehicle.licensePlate)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(6)
                }

                Spacer()

                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                    .font(.system(size: 20))
            }
            .padding(14)
            .background(Color.blue.opacity(0.06))
            .cornerRadius(14)
        }
    }
}
