// MARK: - MallDetailView.swift
import SwiftUI
import Combine

struct MallDetailView: View {
    @EnvironmentObject var router: AppRouter
    let mall: Mall

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 320)
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
                        .background(Color.white)
                        .clipShape(Circle())
                }
                .padding(.top, 50)
                .padding(.leading, 16)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Capsule()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 40, height: 5)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)

                    Text(mall.name)
                        .font(.title2.bold())

                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", mall.rating))
                            .font(.subheadline.bold())
                        Text("(\(mall.reviewCount))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("See Review")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .underline()
                    }

                    HStack(alignment: .top, spacing: 6) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.gray)
                        Text(mall.address)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Parking Fee")
                            .font(.subheadline.bold())
                            .foregroundColor(.blue)
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("Rp \(mall.pricePerHour.formattedThousands())")
                                .font(.title3.bold())
                            Text("/hour")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)
            }

//            Button {
//                let booking = Booking(
//                    mall: mall,
//                    date: "",
//                    timeRange: "",
//                    slot: "",
//                    vehicle: router.selectedVehicle,
//                    tariffPerHour: mall.pricePerHour,
//                    duration: "-",
//                    total: mall.pricePerHour
//                )
//                router.currentBooking = booking
//                router.push(.bookingDetails(booking))
//            } label: {
//                Text("Book Your Park")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color(red: 0.05, green: 0.2, blue: 0.4))
//                    .cornerRadius(14)
//            }
            
            Button {
                let booking = Booking(
                    mall: mall,
                    date: "",
                    timeRange: "",
                    slot: "",
                    vehicle: router.selectedVehicle,
                    tariffPerHour: mall.pricePerHour,
                    duration: "-",
                    total: mall.pricePerHour
                )
                router.currentBooking = booking
                router.push(.bookingDetails(booking))
            } label: {
                Text("Book Now")   // diganti dari "Book Your Park"
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)   // diganti dari warna gelap ke biru, sesuai gambar
                    .cornerRadius(14)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
    }
}
