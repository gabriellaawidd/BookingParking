import SwiftUI
import Combine

struct BookingDetailsView: View {
    @EnvironmentObject var router: AppRouter
    @StateObject private var viewModel: BookingFormViewModel

    init(mall: Mall) {
        _viewModel = StateObject(wrappedValue: BookingFormViewModel(mall: mall))
    }

    var body: some View {
        VStack(spacing: 0) {
            headerImage
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    mallInfoSection
                    
                    Divider()
                        .padding(.vertical, 16)
                    
                    bookingDetailsSection
                    
                    Divider()
                        .padding(.vertical, 16)
                    
                    paymentDetailsSection
                    
                    lateFeeBanner
                        .padding(.top, 24)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            
            bottomBar
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.syncFromDraft(router)
        }
    }
    // MARK: - Header image + back button
    private var headerImage: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 260)
                .overlay(
                    Image(systemName: "building.2.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray.opacity(0.4))
                        .padding(60)
                )

            Button {
                router.pop()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(10)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Circle())
            }
            .padding(.top, 50)
            .padding(.leading, 16)
        }
    }

    // MARK: - Nama mall, alamat, harga
    private var mallInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Text(viewModel.mall.name.uppercased())
                    .font(.title3.bold())
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    Text("Rp \(viewModel.mall.pricePerHour.formattedThousands())")
                        .font(.headline)
                    Text("/ hour")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }

            HStack(alignment: .top, spacing: 6) {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.gray)
                Text(viewModel.mall.address)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.top, 20)
    }

    // MARK: - Vehicle & Slot
    private var bookingDetailsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Booking Details")
                .font(.headline)

            vehiclePicker
            slotPicker
        }
    }

    private var vehiclePicker: some View {
        Menu {
            ForEach(router.vehicles) { vehicle in
                Button {
                    viewModel.selectedVehicle = vehicle
                } label: {
                    Label("\(vehicle.name) (\(vehicle.licensePlate))", systemImage: "car.fill")
                }
            }
            Divider()
            Button {
                router.push(.addVehicle)
            } label: {
                Label("Add Vehicle", systemImage: "plus")
            }
        } label: {
            VehiclePickerCard(vehicle: viewModel.selectedVehicle)
//            BookingRow(
//                icon: "car.fill",
//                title: viewModel.selectedVehicle?.name ?? "Vehicle",
//                trailingIcon: "chevron.up.chevron.down",
//                isPlaceholder: viewModel.selectedVehicle == nil
//            )
        }
    }

    private var slotPicker: some View {
        Button {
            router.push(.chooseParkingSlot(viewModel.mall))
        } label: {
            BookingRow(
                icon: "p.square.fill",
                title: viewModel.selectedSlot ?? "Slot",
                trailingIcon: "chevron.right",
                isPlaceholder: viewModel.selectedSlot == nil
            )
        }
    }
        
    private var slotRowTitle: String {
        guard let slot = viewModel.selectedSlot else { return "Slot" }
        return "\(slot) • \(viewModel.timeRangeLabel)"
    }

    // MARK: - Voucher
    private var paymentDetailsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Payment Details")
                .font(.headline)

            Button {
                // nanti navigasi ke halaman pilih voucher
            } label: {
                BookingRow(
                    icon: "ticket.fill",
                    title: viewModel.selectedVoucher ?? "Voucher",
                    trailingIcon: "chevron.right",
                    isPlaceholder: viewModel.selectedVoucher == nil
                )
            }
        }
    }

    // MARK: - Late fee warning banner
    private var lateFeeBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
                .fixedSize()

            HStack(spacing:4){
                Text("Late Exit Fee! ").bold()
                Text("Rp10,000/hour after parking expires.")
            }
            .font(.caption)
            .foregroundColor(.primary)
            .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color.red.opacity(0.1))
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Bottom bar: total + Pay Now
    private var bottomBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("RP \(viewModel.total.formattedThousands())")
                    .font(.title3.bold())
                    .underline()
                Text("\(viewModel.durationLabel) • \(viewModel.timeRangeLabel)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            Button {
                Task {
                    if let booking = await viewModel.submitBooking() {
                        router.currentBooking = booking
//                        router.push(.bookingDetails(booking))
                        router.popToRoot() 
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    if viewModel.isSubmitting {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: viewModel.isFormValid ? "lock.open.fill" : "lock.fill")
                    }
                    Text("Pay Now")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(viewModel.isFormValid ? Color.blue : Color.gray.opacity(0.4))
                .cornerRadius(24)
            }
            .disabled(!viewModel.isFormValid || viewModel.isSubmitting)
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
        .background(
            Color(.systemBackground)
                .shadow(color: .black.opacity(0.05), radius: 8, y: -2)
        )
    }
}

// MARK: - Vehicle Picker Card
struct VehiclePickerCard: View {
    let vehicle: Vehicle?

    var body: some View {
        HStack(spacing: 14) {
            iconBox

            VStack(alignment: .leading, spacing: 2) {
                Text("Vehicle")
                    .font(.caption2)
                    .foregroundColor(.gray)

                if let vehicle = vehicle {
                    Text(vehicle.name)
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                    Text(vehicle.licensePlate)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray5))
                        .cornerRadius(4)
                } else {
                    Text("Select a vehicle")
                        .font(.subheadline.bold())
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            Image(systemName: "chevron.up.chevron.down")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(vehicle == nil ? Color.gray.opacity(0.3) : Color.blue.opacity(0.4), lineWidth: 1.5)
        )
        .animation(.easeInOut(duration: 0.2), value: vehicle)
    }

    private var iconBox: some View {
        Image(systemName: "car.fill")
            .font(.system(size: 18))
            .foregroundColor(.white)
            .frame(width: 44, height: 44)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(vehicle == nil ? Color.gray.opacity(0.5) : Color(red: 0.05, green: 0.2, blue: 0.4))
            )
    }
}

// MARK: - Reusable Booking Row
struct BookingRow: View {
    let icon: String
    let title: String
    let trailingIcon: String
    let isPlaceholder: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.primary)
                .frame(width: 28)
            Text(title)
                .foregroundColor(isPlaceholder ? .gray : .primary)
            Spacer()
            Image(systemName: trailingIcon)
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}
