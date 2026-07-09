// MARK: - ProfilePageView.swift
import SwiftUI

struct ProfilePageView: View {
//    @EnvironmentObject var router: AppRouter

    var body: some View {
        VStack {
            header
            Spacer()
            Text("Halaman Profile")
                .foregroundColor(.gray)
            Spacer()
        }
    }

    private var header: some View {
        HStack {
            Spacer()
            Text("Profile")
                .font(.title3.bold())
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 50)
        .padding(.bottom, 12)
    }
}

#Preview {
    ProfilePageView()
}
