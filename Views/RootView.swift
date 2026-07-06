// MARK: - RootView.swift
import SwiftUI
import Combine

struct RootView: View {
    @StateObject var router = AppRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            HomePageView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .mallDetail(let mall):
                        MallDetailView(mall: mall)
                    case .bookingDetails(let booking):
                        BookingDetailsView(booking: booking)
                    case .chooseVehicle:
                        ChooseVehicleView()
                    case .addVehicle:
                        AddVehicleView()
                    case .ticket:
                        TicketPageView()
                    case .profile:
                        ProfilePageView()
                    }
                }
            
        }
        .environmentObject(router)
    }
}
