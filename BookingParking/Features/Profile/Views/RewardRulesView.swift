//
//  RewardRulesView.swift
//  BookingParking
//
//  Created by M. TAQWA ADDARI on 10/07/26.
//

import SwiftUI

struct RewardRulesView: View {
    var onDismiss: () -> Void

    var body: some View {
       
        VStack(alignment: .leading, spacing: 0) {
            
        
            Text("Reward Rules")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.navy)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 29)

            
            RuleSection(title: "Earn Points") {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Weekends")
                        .foregroundColor(.navy)

                    BulletItem(text: "Gold : 1 point")
                    BulletItem(text: "Platinum : 2 points")
                    BulletItem(text: "Diamond : 3 points")

                    Text("Weekdays : All earned points receive a 1.5× multiplier")
                        .foregroundColor(.navy)
                        .padding(.top, 4)
                        
                }
            }
            .padding(.bottom, 10)
            // MARK: - Bonus & Penalty
            RuleSection(title: "Bonus & Penalty") {
                VStack(alignment: .leading, spacing: 6) {
                    BulletItem(text: "Park within your booked time: +5 points")
                    BulletItem(text: "Overtime parking: −5 points/hour")
                }
            }
            .padding(.bottom, 10)
            RuleSection(title: "Poin Expiration") {
                Text("If no parking transaction is made for 2 consecutive months, your points will reset to the minimum point of your current level.")
                    .foregroundColor(.navy)
                    .padding(.top, 4)
                   
            }

            .padding(.bottom, 29)

           
            Button(action: onDismiss) {
                Text("Got It")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 118, height: 50, alignment: .center)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, 22) //
        .padding(.vertical, 35)
        .frame(width: 311)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .shadow(color: Color.black.opacity(0.25), radius: 2, x: 0, y: 4)
    }
}


private struct RuleSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 13, weight: .bold)) // Ukuran font 13
                .foregroundColor(.navy)

            content
                .font(.system(size: 13))
        }
    }
}

private struct BulletItem: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .foregroundColor(.navy)
            Text(text)
                .foregroundColor(.navy)
        }
        .padding(.leading, 8)
    }
}


private extension Color {
    static let navy = Color(red: 0.05, green: 0.13, blue: 0.30)
}


#Preview {
    ZStack {
        Color.black.opacity(0.4).ignoresSafeArea()
        RewardRulesView(onDismiss: {})
    }
}
