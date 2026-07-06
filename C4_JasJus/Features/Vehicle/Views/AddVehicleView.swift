// MARK: - AddVehicleView.swift
import SwiftUI
import Combine

struct AddVehicleView: View {
    @EnvironmentObject var router: AppRouter

    @State private var vehicleName: String = ""
    @State private var vehicleType: String = ""
    @State private var licensePlate: String = ""

    let vehicleTypes = ["Sedan", "SUV", "MPV", "Hatchback", "Truck", "Motorcycle"]

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Vehicle Name")
                            .font(.subheadline.bold())
                        TextField("Dad's Car", text: $vehicleName)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Vehicle Type")
                            .font(.subheadline.bold())
                        Menu {
                            ForEach(vehicleTypes, id: \.self) { type in
                                Button(type) { vehicleType = type }
                            }
                        } label: {
                            HStack {
                                Text(vehicleType.isEmpty ? "Select vehicle type" : vehicleType)
                                    .foregroundColor(vehicleType.isEmpty ? .gray : .primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("License Plate Number")
                            .font(.subheadline.bold())
                        TextField("Example : B 1234 ABC", text: $licensePlate)
                            .autocapitalization(.allCharacters)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
            }

            Button {
                let newVehicle = Vehicle(
                    name: vehicleName.isEmpty ? "My Vehicle" : vehicleName,
                    type: vehicleType.isEmpty ? "Unknown" : vehicleType,
                    licensePlate: licensePlate.isEmpty ? "-" : licensePlate
                )
                router.vehicles.append(newVehicle)
                router.selectedVehicle = newVehicle
                router.pop()
            } label: {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.05, green: 0.2, blue: 0.4))
                    .cornerRadius(14)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            .disabled(vehicleName.isEmpty || licensePlate.isEmpty)
            .opacity(vehicleName.isEmpty || licensePlate.isEmpty ? 0.5 : 1)
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
            Text("Add Vehicle")
                .font(.title3.bold())
            Spacer()
            Color.clear.frame(width: 36, height: 36)
        }
        .padding(.horizontal)
        .padding(.top, 50)
        .padding(.bottom, 12)
    }
}
