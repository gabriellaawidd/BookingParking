//
//   Loyaltylevelcard .swift
//  BookingParking
//
//  Created by M. TAQWA ADDARI on 10/07/26.
//


import SwiftUI

struct LoyaltyLevelCard: View {
    var body: some View {
        VStack(spacing: 0) {
            
           
            VStack(alignment: .leading, spacing: 22) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("PLATINUM")
                            .font(.system(size: 20, weight: .semibold))
                            .tracking(-0.45)
                            .foregroundColor(Color(red: 1/255, green: 31/255, blue: 75/255))
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Total Points")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.secondary)

                        Text("3,650 Pts")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(red: 1/255, green: 31/255, blue: 75/255))
                            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 3)
                    }
                }

                VStack(spacing: 8) {
                    HStack {
                        Text("You're 350 points away from Platinum")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Color(red: 1/255, green: 31/255, blue: 75/255))
                            .lineLimit(1)
                            .minimumScaleFactor(0.9)

                        Spacer(minLength: 8)

                        Text("3,650 / 4,000")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Color(red: 1/255, green: 31/255, blue: 75/255))
                            .lineLimit(1)
                            .minimumScaleFactor(0.9)
                    }

                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.black.opacity(0.08))
                            .frame(height: 8)

                        Capsule()
                            .fill(Color.primary)
                            .frame(width: 250, height: 8)
                    }
                }
            }
           
            .padding(16)
            .background(Color.blue.opacity(0.12))

            // MARK: - Bagian bawah (grid benefit)
            HStack(spacing: 8) {
                benefitItem(icon: "car.fill", title: "Priority\nParking")
                benefitItem(icon: "percent", title: "Discount\nup to 20%")
                benefitItem(icon: "clock.fill", title: "Free\nextra time")
                benefitItem(icon: "person.2.fill", title: "Partner\nDeals")
            }
           
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.white)
            
            Spacer(minLength: 0)
        }
        
        .frame(width: 360, height: 230)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }

    private func benefitItem(icon: String, title: String) -> some View {
        
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 200/255, green: 230/255, blue: 255/255))
                
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 17))
                        .foregroundColor(Color(red: 1/255, green: 31/255, blue: 75/255))
                )

            Text(title)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(Color(red: 1/255, green: 31/255, blue: 75/255))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

// MARK: - Preview
#Preview {
    LoyaltyLevelCard()
        .padding()
        .background(Color(.systemGray6))
}
