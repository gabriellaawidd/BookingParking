//
//  BookingDetailRow.swift
//  BookingParking
//
//  Created by Gabriella Angelina Widjaja on 09/07/26.
//

import SwiftUI

struct BookingDetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            
            Text(value)
                .font(.subheadline)
        }
    }
}

#Preview {
    BookingDetailRow(title: "Date and Time", value: "25 April 2025, 10:00 AM")
        .padding()
}
