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
                    case .bookingDetails(let mall):
                        BookingDetailsView(mall: mall)
                    case .chooseParkingSlot(let mall):
                        ChooseParkingSlotView(mall: mall)
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
