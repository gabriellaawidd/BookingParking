
import SwiftUI

struct BookingDetailsView: View {
    @Binding var path: NavigationPath
    @State var viewModel: BookingFormViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            headerImage

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    mallInfoSection

                    Divider().padding(.vertical, 16)

                    bookingDetailsSection

                    Divider().padding(.vertical, 16)

                    paymentDetailsSection

                    lateFeeBanner.padding(.top, 24)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }

            bottomBar
        }
        .navigationBarHidden(true)
    }

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
                dismiss()
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
            ForEach(viewModel.vehicles) { vehicle in
                Button {
                    viewModel.selectedVehicle = vehicle
                } label: {
                    Label("\(vehicle.name) (\(vehicle.licensePlate))", systemImage: "car.fill")
                }
            }
            Divider()
            NavigationLink {
                AddVehicleView()
            } label: {
                Label("Add Vehicle", systemImage: "plus")
            }
        } label: {
            VehiclePickerCard(vehicle: viewModel.selectedVehicle)
        }
    }

    private var slotPicker: some View {
        NavigationLink {
            ChooseParkingSlotView(
                bookingViewModel : viewModel,
                viewModel: ParkingLotViewModel(mall: viewModel.mall)
            )
        } label: {
            SlotPickerCard(
                slotCode: viewModel.selectedSlot,
                timeRangeLabel: viewModel.timeRangeLabel,
                dayRangeLabel: viewModel.dayRangeLabel
            )
        }
    }

    private var paymentDetailsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Payment Details")
                .font(.headline)

            Button {
                // navigasi voucher, nanti
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

    private var lateFeeBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
                .fixedSize()

            HStack(spacing: 4) {
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
                    if let _ = await viewModel.submitBooking() {
                        path.removeLast(path.count)
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    if viewModel.isSubmitting {
                        ProgressView().tint(.white)
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

struct VehiclePickerCard: View {
    let vehicle: Vehicle?

    var body: some View {
        HStack(spacing: 14) {
            iconBoxVehicle

            VStack(alignment: .leading, spacing: 2) {

                if let vehicle = vehicle {
                    Text(vehicle.name)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Text(vehicle.licensePlate)
                        .font(.caption.bold())
                        .foregroundColor(.black)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray5))
                        .cornerRadius(4)
                } else {
                    Text("Vehicle")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
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
        .frame(height: 68)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(vehicle == nil ? Color.gray.opacity(0.3) : Color.blue.opacity(0.4))
                .animation(.easeInOut(duration: 0.2), value: vehicle)
        )
    }

    private var iconBoxVehicle: some View {
        Image(systemName: "car.fill")
            .font(.system(size: 18))
            .foregroundColor(.white)
            .frame(width: 44, height: 44)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(vehicle == nil ? Color.gray.opacity(0.5) : Color(red: 0.05, green: 0.2, blue: 0.4))
            )
            .animation(.easeInOut(duration: 0.2), value: vehicle)
    }
}
//
//// MARK: - Slot Picker Card
struct SlotPickerCard: View {
    let slotCode: String?
    let timeRangeLabel: String
    let dayRangeLabel: String

    var body: some View {
        HStack(spacing: 14) {
            iconBoxSlot

            VStack(alignment: .leading, spacing: 2) {

                if let slotCode = slotCode {
                    Text(slotCode)
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .padding(.bottom, 2)
                    
                    HStack{
                        Text(dayRangeLabel)
                            .font(.caption2.bold())
                            .foregroundColor(.black)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(.systemGray5))
                            .cornerRadius(4)
                        
                        Text(timeRangeLabel)
                            .font(.caption.bold())
                            .foregroundStyle(.black)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(.systemGray5))
                            .cornerRadius(4)
                    }

                    
                } else {
                    Text("Slot")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    Text("Select a slot")
                        .font(.subheadline.bold())
                        .foregroundColor(.gray)
                        .lineLimit(1)
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
                .stroke(slotCode == nil ? Color.gray.opacity(0.3) : Color.blue.opacity(0.4), lineWidth: 1.5)
                .animation(.easeInOut(duration: 0.2), value: slotCode)
        )
    }

    private var iconBoxSlot: some View {
    Image(systemName: "parkingsign")
        .font(.system(size: 18, weight: .bold))
        .foregroundColor(.white)
        .frame(width: 44, height: 44)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(slotCode == nil ? Color.gray.opacity(0.5) : Color(red: 0.05, green: 0.2, blue: 0.4))
        )
        .animation(.easeInOut(duration: 0.2), value: slotCode)
    }
}
//
//// MARK: - Reusable Booking Row
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



#Preview {
    NavigationStack {
        BookingDetailsView(path: .constant(NavigationPath()), viewModel: BookingFormViewModel(mall: .sample))
    }
}
