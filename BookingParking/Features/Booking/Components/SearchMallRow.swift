// MARK: - SearchMallRow.swift
import SwiftUI

struct SearchMallRow: View {
    let mall: MallLocation

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 22))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color(red: 0.05, green: 0.2, blue: 0.4))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(mall.name)
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
                Text("\(mall.distanceInMeters) · \(mall.address)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6))
        )
    }
}
