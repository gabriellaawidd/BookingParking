//// MARK: - HomeView.swift
//import SwiftUI
//import MapKit
//import Combine
//
//struct HomePageView: View {
//    @EnvironmentObject var router: AppRouter
//    @StateObject private var locationManager = LocationManager()
//    @State private var showSearchSheet = false
//    @State private var showBottomSheet = true
//
//    // Fallback default: BSD City, dipakai kalau lokasi user belum didapat / ditolak
//    @State private var cameraPosition: MapCameraPosition = .region(
//        MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: -6.3025, longitude: 106.6524),
//            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
//        )
//    )
//
//    // Dummy active booking state — set to nil to hide the card
//    @State private var activeBooking: ActiveBookingInfo? = ActiveBookingInfo(
//        mallName: "AEON Mall BSD",
//        date: "25 June 2027, 13.00 - 15.00",
//        zone: "Red Zone, B2",
//        timeRemaining: "59:30"
//    )
//
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            Map(position: $cameraPosition) {
//                UserAnnotation()
//            }
//            .mapControls {
//                MapUserLocationButton()
//            }
//            .ignoresSafeArea()
//
//            VStack(spacing: 0) {
//                Spacer()
//                bottomSheet
//                    .presentationDetents([
//                        .height(140),   // collapsed — cuma search bar kelihatan
//                        .medium,        // setengah layar — search bar + active booking + tab bar
//                        .large          // full layar
//                    ])
//                    .presentationBackgroundInteraction(.enabled(upThrough: .medium)) // peta tetap bisa di-drag sampai posisi medium
//                    .interactiveDismissDisabled(true)
//                    .presentationDragIndicator(.visible)
//                    .presentationCornerRadius(24)
//            }
//        }
//        .navigationBarHidden(true)
//        .sheet(isPresented: $showSearchSheet) {
//            SearchMallModalView()
//                .presentationDetents([.large])
//                .presentationDragIndicator(.hidden)
//        }
//        .onAppear {
//            locationManager.requestLocation()
//        }
//        .onReceive(locationManager.$currentLocation) { newLocation in
//            guard let coordinate = newLocation else { return }
//            withAnimation {
//                cameraPosition = .region(
//                    MKCoordinateRegion(
//                        center: coordinate,
//                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
//                    )
//                )
//            }
//        }
//    }
//    
////    var body: some View {
////        Map(position: $cameraPosition) {
////            UserAnnotation()
////        }
////        .mapControls {
////            MapUserLocationButton()
////        }
////        .ignoresSafeArea()
////        .navigationBarHidden(true)
////        .sheet(isPresented: $showBottomSheet) {
////            bottomSheet
////                .presentationDetents([.height(140), .medium, .large])
////                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
////                .interactiveDismissDisabled(true)
////                .presentationDragIndicator(.visible)
////                .presentationCornerRadius(24)
////        }
////        .sheet(isPresented: $showSearchSheet) {
////            SearchMallModalView()
////                .presentationDetents([.large])
////                .presentationDragIndicator(.hidden)
////        }
////        .onAppear {
////            locationManager.requestLocation()
////        }
////        .onReceive(locationManager.$currentLocation) { newLocation in
////            guard let coordinate = newLocation else { return }
////            withAnimation {
////                cameraPosition = .region(
////                    MKCoordinateRegion(
////                        center: coordinate,
////                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
////                    )
////                )
////            }
////        }
////    }
//    
//
//    private var bottomSheet: some View {
//        VStack(spacing: 16) {
//            Capsule()
//                .fill(Color.gray.opacity(0.4))
//                .frame(width: 40, height: 5)
//                .padding(.top, 8)
//
//            searchBar
//
//            if let booking = activeBooking {
//                ActiveBookingCard(info: booking)
//            }
//
//            HomeTabBar()
//        }
//        .padding(.horizontal)
//        .background(
//            RoundedRectangle(cornerRadius: 24)
//                .fill(Color(.systemBackground))
//                .shadow(radius: 8)
//                .ignoresSafeArea(edges: .bottom)
//        )
//    }
//    
////    private var bottomSheet: some View {
////        VStack(spacing: 16) {
////            searchBar
////
////            if let booking = activeBooking {
////                ActiveBookingCard(info: booking)
////            }
////
////            HomeTabBar()
////        }
////        .padding(.horizontal)
////        .padding(.top, 8)
////        .background(Color(.systemBackground))
////    }
//
//
//    private var searchBar: some View {
//        Button {
//            showSearchSheet = true
//        } label: {
//            HStack {
//                Image(systemName: "magnifyingglass")
//                    .foregroundColor(.gray)
//                Text("Search")
//                    .foregroundColor(.gray)
//                Spacer()
//                Image(systemName: "mic.fill")
//                    .foregroundColor(.gray)
//            }
//            .padding(12)
//            .background(Color(.systemGray6))
//            .cornerRadius(14)
//        }
//    }
//}
//
//struct ActiveBookingInfo {
//    let mallName: String
//    let date: String
//    let zone: String
//    let timeRemaining: String
//}
//
//struct ActiveBookingCard: View {
//    let info: ActiveBookingInfo
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            HStack {
//                Image(systemName: "mappin.circle.fill")
//                    .foregroundColor(.blue)
//                Text(info.mallName)
//                    .font(.headline)
//            }
//
//            HStack(spacing: 8) {
//                Image(systemName: "calendar")
//                    .foregroundColor(.gray)
//                Text(info.date)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//
//            HStack(spacing: 8) {
//                Image(systemName: "parkingsign.circle")
//                    .foregroundColor(.gray)
//                Text(info.zone)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//
//            Divider()
//                .background(Color.gray.opacity(0.3))
//
//            HStack {
//                VStack(alignment: .leading, spacing: 4) {
//                    Text("Time Remaining")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                    Text(info.timeRemaining)
//                        .font(.title2.bold())
//                        .foregroundColor(.red)
//                }
//                Spacer()
//                Button {
//                    // call action
//                } label: {
//                    Label("Call", systemImage: "phone.fill")
//                        .font(.subheadline.bold())
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 10)
//                        .background(Color.blue.opacity(0.9))
//                        .cornerRadius(20)
//                }
//            }
//        }
//        .padding(16)
//        .background(Color.blue.opacity(0.08))
//        .cornerRadius(16)
//    }
//}
//
//struct HomeTabBar: View {
//    var body: some View {
//        HStack {
//            TabItem(icon: "house.fill", title: "Home", isSelected: true)
//            Spacer()
//            TabItem(icon: "ticket", title: "Ticket", isSelected: false)
//            Spacer()
//            TabItem(icon: "trophy", title: "Reward", isSelected: false)
//            Spacer()
//            TabItem(icon: "person", title: "Profile", isSelected: false)
//        }
//        .padding(.top, 8)
//        .padding(.bottom, 12)
//    }
//}
//
//struct TabItem: View {
//    let icon: String
//    let title: String
//    let isSelected: Bool
//
//    var body: some View {
//        VStack(spacing: 4) {
//            Image(systemName: icon)
//                .font(.system(size: 20))
//            Text(title)
//                .font(.caption2)
//        }
//        .foregroundColor(isSelected ? .primary : .gray)
//    }
//}

// MARK: - HomeView.swift
import SwiftUI
import MapKit
import Combine

struct HomePageView: View {
    @EnvironmentObject var router: AppRouter
    @StateObject private var locationManager = LocationManager()
    @State private var showSearchSheet = false

    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -6.3025, longitude: 106.6524),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
    )

    // Set ke nil untuk lihat state "No Active Session"
    @State private var activeBooking: ActiveBookingInfo? = ActiveBookingInfo(
        mallName: "AEON Mall BSD City",
        zone: "B2 - Red Zone",
        timeRemaining: "01:30:49"
    )

    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $cameraPosition) {
                UserAnnotation()
            }
            .mapControls {
                MapUserLocationButton()
            }
            .ignoresSafeArea()

            VStack(spacing: 12) {
                statusCard
                bottomControls
            }
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showSearchSheet) {
            SearchMallModalView()
        }
        .onAppear {
            locationManager.requestLocation()
        }
        .onReceive(locationManager.$currentLocation) { newLocation in
            guard let coordinate = newLocation else { return }
            withAnimation {
                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                    )
                )
            }
        }
    }

    // MARK: - Status Card (Active Session / No Active Session)
    @ViewBuilder
    private var statusCard: some View {
        if let booking = activeBooking {
            ActiveSessionCard(info: booking)
        } else {
            NoActiveSessionCard()
        }
    }

    // MARK: - Tab bar pill + search FAB
    private var bottomControls: some View {
        HStack(alignment: .bottom, spacing: 12) {
            HomeTabBarPill()
            Spacer()
            SearchFabButton {
                showSearchSheet = true
            }
        }
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.90 : 1.0)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct NoActiveSessionCard: View {
    var body: some View {
        VStack(spacing: 6) {
            Text("You have no active session yet.")
                .font(.subheadline.bold())
                .foregroundColor(.primary)
            Text("Let's book your parking spot now!")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(
            UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, y: -2)
        )
    }
}

// MARK: - Active Session Card
struct ActiveBookingInfo {
    let mallName: String
    let zone: String
    let timeRemaining: String
}

struct ActiveSessionCard: View {
    let info: ActiveBookingInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(info.mallName)
                .font(.title3.bold())
            Text(info.zone)
                .font(.subheadline)
                .foregroundColor(.primary.opacity(0.8))
            Text(info.timeRemaining)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 0.7, green: 0.15, blue: 0.1))
            Text("Until Your Booked Session Starts")
                .font(.caption)
                .italic()
                .foregroundColor(.gray)

            HStack {
                Spacer()
                Button {
                    // call staff action
                } label: {
                    Label("Call Staff", systemImage: "phone.fill")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .background(Color(red: 0.05, green: 0.2, blue: 0.4))
                        .cornerRadius(24)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, y: -2)
        )
    }
}

struct HomeTabBarPill: View {
//    @State private var selectedTab: String = "Home"
    @EnvironmentObject var router: AppRouter

    var body: some View {
        HStack(spacing: 4) {
            Button {
                router.selectedTab = "Home"
                router.popToRoot()
            } label: {
                TabItem(icon: "house.fill", title: "Home", isSelected: router.selectedTab == "Home")
            }
            .buttonStyle(PressableButtonStyle())

            Spacer()

            Button {
                router.selectedTab = "Ticket"
                router.popToRoot()
                router.push(.ticket)
            } label: {
                TabItem(icon: "ticket.fill", title: "Ticket", isSelected: router.selectedTab == "Ticket")
            }
            .buttonStyle(PressableButtonStyle())

            Spacer()

            Button {
                router.selectedTab = "Profile"
                router.popToRoot()
                router.push(.profile)
            } label: {
                TabItem(icon: "person.fill", title: "Profile", isSelected: router.selectedTab == "Profile")
            }
            .buttonStyle(PressableButtonStyle())
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .glassEffect(.regular, in: .capsule)
    }
}


struct SearchFabButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
                .frame(width: 58, height: 58)
        }
        .glassEffect(.regular, in: .circle)
    }
}

struct TabItem: View {
    let icon: String
    let title: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
            Text(title)
                .font(.system(size: 10))
        }
        .foregroundColor(.primary)
        .frame(width: 72, height: 48)
        .background(
            Capsule()
                .fill(isSelected ? Color(.systemGray6) : Color.clear)
        )
    }
}
