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
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: "Home") {
                NavigationStack {
                    HomePageView(selectedTab: $selectedTab, viewModel: viewModel)
                }
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
            
            if selectedTab == "Home" {
                Tab(value: "Search", role: .search) {
                    NavigationStack {
                        SearchMallModalView()
                    }
                }
            }
        }
    }
}

#Preview {
    RootTabView(selectedTab: .constant("Home"), viewModel: HomeViewModel())
}
