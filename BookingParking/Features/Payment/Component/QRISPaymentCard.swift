//
//  QRISPaymentCard.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import SwiftUI
import UIKit

struct QRISPaymentCard: View {
    let mallName: String
    let qrImage: UIImage?
    let timeRemainingLabel: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image("logo_qris")
                .resizable()
                .scaledToFit()
                .frame(height: 32)
            
            Text(mallName)
                .font(.headline)
            
            if let qrImage {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
            }
            else {
                ProgressView()
                    .frame(width: 220, height: 220)
            }
            
            Text("Scan the QR code above using the application")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 8) {
                ForEach(["gopay_logo", "ovo_logo", "dana_logo", "shopeepay_logo"], id: \.self) { assetName in
                    Image(assetName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                }
            }
            
            Text("or other QRIS payment appllications")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            Divider()
            
            
            Text("Time Remaining: " + timeRemainingLabel)
                .font(.headline)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    QRISPaymentCard(mallName: "AEON Mall BSD City", qrImage: nil, timeRemainingLabel: "14:59")
        .padding()
}
