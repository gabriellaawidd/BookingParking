//
//  SettingsMenuRow.swift
//  BookingParking
//
//  Created by M. TAQWA ADDARI on 10/07/26.
//

import SwiftUI

struct SettingsMenuRow: View {
    let icon: String
    let title: String
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 17))
                    .foregroundColor(.primary)
                    .frame(width: 22)

                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(red: 1/255, green: 31/255, blue: 75/255))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 0) {
        SettingsMenuRow(icon: "bell", title: "Notification Settings", onTap: {})
        Divider().padding(.leading, 46)
        SettingsMenuRow(icon: "questionmark.circle", title: "Help Center", onTap: {})
        Divider().padding(.leading, 46)
        SettingsMenuRow(icon: "info.circle", title: "About Us", onTap: {})
    }
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 14))
    .overlay(
        RoundedRectangle(cornerRadius: 14)
            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
    )
    .padding()
}
