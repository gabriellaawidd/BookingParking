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
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.headline)
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    HStack {
        BookingDetailRow(title: "Date and Time", value: "25 April 2025")
    }
    .padding()
}
