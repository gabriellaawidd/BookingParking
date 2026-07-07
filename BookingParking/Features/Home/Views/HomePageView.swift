import SwiftUI
import MapKit

struct HomePageView: View {
    @Binding var selectedTab: String
    @State var viewModel: HomeViewModel
    @State private var locationManager = LocationManager()
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack(alignment: .bottom) {
                Map(position: $viewModel.cameraPosition) { UserAnnotation() }
                    .mapControls { MapUserLocationButton() }
                    .ignoresSafeArea()

                VStack(spacing: 12) { sessionCard }
                    .padding(.horizontal)
                    .padding(.bottom, 12)
            }
            .navigationBarHidden(true)
            .navigationDestination(for: MallLocation.self) { mall in
                // BookingDetailsView(mall: mall)
            }
        }
        .sheet(isPresented: $viewModel.showSearchSheet, onDismiss: {
            if let mall = viewModel.pendingMallDetail {
                viewModel.selectedMall = mall
                viewModel.pendingMallDetail = nil
            }
        }) {
            SearchMallModalView(userLocation: locationManager.currentLocation) { mall in
                viewModel.pendingMallDetail = mall
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .sheet(item: $viewModel.selectedMall) { mall in
            MallDetailView(mall: mall) { bookedMall in
                viewModel.selectedMall = nil
                viewModel.navigationPath.append(bookedMall)
            }
            .presentationDetents([.height(420)])
            .presentationDragIndicator(.visible)
        }
        .onAppear { locationManager.requestLocation() }
        .onReceive(locationManager.$currentLocation) { newLocation in
            guard let coordinate = newLocation else { return }
            withAnimation {
                viewModel.cameraPosition = .region(
                    MKCoordinateRegion(center: coordinate,
                                       span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                )
            }
        }
    }

    @ViewBuilder
    private var sessionCard: some View {
        switch viewModel.sessionState {
        case .empty:
            EmptySessionCard { viewModel.showSearchSheet = true }
        case .upcoming(let session):
            UpcomingSessionCard(session: session,
                                 onNavigate: { viewModel.openMaps(for: session) },
                                 onCallStaff: { viewModel.callStaff(phoneNumber: session.staffNumber, openURL: openURL) })
        case .active(let session):
            ActiveSessionCard(session: session, remainingTime: viewModel.remainingTime,
                               onOpenSlot: { viewModel.openSlot() },
                               onCallStaff: { viewModel.callStaff(phoneNumber: session.staffNumber, openURL: openURL) })
        }
    }
}
