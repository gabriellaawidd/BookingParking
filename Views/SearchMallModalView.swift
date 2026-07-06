//// MARK: - SearchMallSheetView.swift
//import SwiftUI
//import Combine
//
//struct SearchMallModalView: View {
//    @EnvironmentObject var router: AppRouter
//    @Environment(\.dismiss) var dismiss
//    @State private var query: String = ""
//
//    var body: some View {
//        VStack(spacing: 0) {
//            Capsule()
//                .fill(Color.gray.opacity(0.4))
//                .frame(width: 40, height: 5)
//                .padding(.top, 8)
//                .padding(.bottom, 16)
//
//            HStack {
//                Image(systemName: "magnifyingglass")
//                    .foregroundColor(.gray)
//                TextField("Search", text: $query)
//                Image(systemName: "mic.fill")
//                    .foregroundColor(.gray)
//            }
//            .padding(12)
//            .background(Color(.systemGray6))
//            .cornerRadius(14)
//            .padding(.horizontal)
//
//            HStack {
//                Text("Recent")
//                    .font(.headline)
//                Spacer()
//            }
//            .padding(.horizontal)
//            .padding(.top, 20)
//
//            ScrollView {
//                VStack(spacing: 12) {
//                    ForEach(Mall.recentList) { mall in
//                        MallRow(mall: mall) {
//                            dismiss()
//                            // slight delay so sheet dismiss animation completes before push
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                router.push(.mallDetail(mall))
//                            }
//                        }
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.top, 12)
//            }
//
//            Spacer()
//        }
//        .background(Color(.systemBackground))
//    }
//}
//
//struct MallRow: View {
//    let mall: Mall
//    let onBook: () -> Void
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Text(mall.name)
//                    .font(.headline)
//                Spacer()
//                Text(mall.distance)
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//            Text(mall.address)
//                .font(.caption)
//                .foregroundColor(.gray)
//
//            HStack(alignment: .bottom) {
//                Text("Rp \(mall.pricePerHour.formattedThousands())")
//                    .font(.subheadline.bold())
//                Text("/hour")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                Spacer()
//                Button(action: onBook) {
//                    Text("Book")
//                        .font(.subheadline.bold())
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 8)
//                        .background(Color.blue.opacity(0.9))
//                        .cornerRadius(16)
//                }
//            }
//        }
//        .padding(14)
//        .background(Color.blue.opacity(0.06))
//        .cornerRadius(14)
//    }
//}
//
extension Int {
    func formattedThousands() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
//---------------------------------------------------------------

// MARK: - SearchMallModalView.swift
import SwiftUI

struct SearchMallModalView: View {
    @EnvironmentObject var router: AppRouter
    @Environment(\.dismiss) var dismiss
    @State private var query: String = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search", text: $query)
                Image(systemName: "mic.fill")
                    .foregroundColor(.gray)
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(14)
            .padding(.horizontal)
            .padding(.top, 16)

            HStack {
                Text(query.isEmpty ? "Nearby" : "Results")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)

            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Mall.recentList) { mall in
                        Button {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                router.push(.mallDetail(mall))
                            }
                        } label: {
                            SearchMallRow(mall: mall)
                        }
                        Divider()
                            .padding(.leading, 56)
                    }
                }
                .padding(.top, 8)
            }

            Spacer()
        }
        .background(Color(.systemBackground))
    }
}

struct SearchMallRow: View {
    let mall: Mall

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 22))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(Color.blue.opacity(0.9))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(mall.name)
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
                Text("\(mall.distance) · \(mall.address)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}
