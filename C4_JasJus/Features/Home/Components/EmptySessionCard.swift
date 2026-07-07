//
//  EmptySessionCard.swift
//  C4_JasJus
//
//  Created by Gabriella Angelina Widjaja on 07/07/26.
//

import SwiftUI

struct EmptySessionCard: View {
    let onBookNow: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 6) {
                Text("You have no active session yet.")
                    .font(.body)
                    .foregroundColor(.gray)
                Text("Let's book your parking spot now!")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Button(action: onBookNow) {
                Text("Book Now")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .frame(width: 160)
                    .padding(.vertical, 14)
                    .background(Color.blue)
                    .cornerRadius(24)
            }
        }
        .sessionCardStyle()
    }
}

#Preview {
    EmptySessionCard(onBookNow: {})
        .padding()
}
