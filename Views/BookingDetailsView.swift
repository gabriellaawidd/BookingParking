// MARK: - BookingDetailsView.swift
import SwiftUI
import Combine

struct BookingDetailsView: View {
    @EnvironmentObject var router: AppRouter
    @State var booking: Booking

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 180)
                            .overlay(
                                Image(systemName: "building.2.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray.opacity(0.4))
                                    .padding(40)
                            )
                    }
                    .cornerRadius(14)

                    BookingRow(icon: "car.fill", title: "Vehicle") {
                        router.push(.chooseVehicle)
                    }
                    BookingRow(icon: "calendar", title: "Date & Time") {
                        // navigate to date & time picker (not in scope of given designs)
                    }
                    BookingRow(icon: "parkingsign", title: "Slot") {
                        // navigate to slot picker (not in scope of given designs)
                    }

                    Text("Payment Details")
                        .font(.headline)
                        .padding(.top, 8)

                    BookingRow(icon: "ticket.fill", title: "Voucher") {
                        // navigate to voucher page
                    }
                    BookingRow(icon: "creditcard.fill", title: "Metode Pembayaran") {
                        // navigate to payment method page
                    }

                    VStack(spacing: 10) {
                        HStack {
                            Text("Tarif per jam")
                            Spacer()
                            Text("Rp. \(booking.tariffPerHour.formattedThousands())")
                        }
                        HStack {
                            Text("Durasi")
                            Spacer()
                            Text(booking.duration)
                        }
                        Divider()
                        HStack {
                            Text("Total").font(.headline)
                            Spacer()
                            Text("Rp. \(booking.total.formattedThousands())")
                                .font(.headline)
                        }
                    }
                    .foregroundColor(.primary)
                    .padding(.top, 8)
                }
                .padding(.horizontal)
                .padding(.top, 16)
            }

            Button {
                // proceed with payment
            } label: {
                Text("Pay Now")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.05, green: 0.2, blue: 0.4))
                    .cornerRadius(14)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
        .onChange(of: router.selectedVehicle) { _, newVehicle in
            booking.vehicle = newVehicle
        }
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
            Text("Booking Details")
                .font(.title3.bold())
            Spacer()
            Color.clear.frame(width: 36, height: 36)
        }
        .padding(.horizontal)
        .padding(.top, 50)
        .padding(.bottom, 12)
    }
}

struct BookingRow: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 36, height: 36)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(12)
            .background(Color.blue.opacity(0.06))
            .cornerRadius(12)
        }
    }
}
