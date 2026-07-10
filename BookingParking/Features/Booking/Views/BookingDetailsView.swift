import SwiftUI

struct BookingDetailsView: View {
    @Binding var path: NavigationPath
    @State var viewModel: BookingFormViewModel
    @State private var showAddVehicleSheet: Bool = false
    @Environment(\.dismiss) private var dismiss
    let userSession: UserSession
    
    var body: some View {
        VStack(spacing: 0) {
            headerImage
            
            ScrollView {
                VStack(alignment: .leading) {
                    mallInfoSection
                    Divider().padding(.vertical, 16)
                    bookingDetailsSection
                    Divider().padding(.vertical, 16)
                    paymentDetailsSection
                }
                .padding(.horizontal)
                
                bottomBar
                    .padding(.top, 24)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $showAddVehicleSheet) {
            AddVehicleView(viewModel: viewModel)
        }
    }
    
    private var headerImage: some View {
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
    }
    
    private var mallInfoSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(viewModel.mall.name.uppercased())
                    .font(.title3.bold())
                Text(viewModel.mall.address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("Rp \(viewModel.pricePerHour.formattedThousands())/hour")
                .font(.headline)
            
        }
        .padding(.top, 20)
    }
    
    private var bookingDetailsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Booking Details")
                .font(.headline)
                .padding(.bottom, 4)
            
            VehiclePickerView(viewModel: viewModel) {
                showAddVehicleSheet = true
            }
            
            ParkingSlotPickerRow(viewModel: viewModel)
        }
    }
    
    private var paymentDetailsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Payment Details")
                .font(.headline)
                .padding(.bottom, 4)
            
            VoucherPickerRow(voucherCode: nil, discountLabel: nil)
        }
    }
    
    private var lateFeeReminder: some View {
        HStack(spacing: 6) {
            Image(systemName: "info.circle")
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack(spacing: 4) {
                Text("Late Exit Fee !")
                    .bold()
                    .foregroundColor(.primary)
                Text("Rp10,000/hour after parking expires.")
                    .foregroundColor(.secondary)
            }
            .font(.caption)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var bottomBar: some View {
        BookingBottomBar(
            hasBooked: viewModel.hasBooked,
            totalLabel: viewModel.hasBooked ? "Rp \(viewModel.total.formattedThousands())" : "Rp 0",
            timeRangeLabel: viewModel.timeRangeLabel,
            durationLabel: viewModel.durationLabel,
            isFormValid: viewModel.isFormValid,
            isSubmitting: viewModel.isSubmitting,
            onPayNow: {
                Task {
                    print("🔵 onPayNow ditekan, userId:", userSession.userId as Any)
                    guard let userId = userSession.userId else {
                        print("❌ STOP — userId nil")
                        return
                    }
                    print("🔵 lanjut submitBooking")
                    if let booking = await viewModel.submitBooking(userId: userId) {
                        path.append(booking)
                    }
                }
            }
        )
    }
}

#Preview {
    NavigationStack {
        BookingDetailsView(path: .constant(NavigationPath()), viewModel: BookingFormViewModel(mall: .sample), userSession: UserSession())
    }
}

