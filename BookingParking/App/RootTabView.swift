//
//  TabView.swift
//
//
//  Created by Gabriella Angelina Widjaja on 07/07/26.
//

import SwiftUI

struct RootTabView: View {
    @Binding var selectedTab: String
    @State var viewModel: HomeViewModel
    @State private var userSession = UserSession()
    @State private var previousTab: String = "Home"

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Booking", systemImage: "calendar.badge.clock", value: "Home") {
                HomePageView(selectedTab: $selectedTab, viewModel: viewModel, userSession: userSession)
            }

            Tab("Ticket", systemImage: "ticket.fill", value: "Ticket") {
                NavigationStack {
                    TicketPageView()
                }
            }

            Tab("Profile", systemImage: "person.fill", value: "Profile") {
                NavigationStack {
                    ProfilePageView()
                }
            }
        }
    }
}

#Preview {
    RootTabView(selectedTab: .constant("Home"), viewModel: HomeViewModel())
}
