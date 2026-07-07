import SwiftUI
import MapKit

struct HomePageView: View {
    @Binding var selectedTab: String
    @State var viewModel: HomeViewModel
    @State private var locationManager = LocationManager()
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $viewModel.cameraPosition) {
                UserAnnotation()
            }
            .mapControls {
                MapUserLocationButton()
            }
            .ignoresSafeArea()
            VStack(spacing: 12) {
                sessionCard
            }
            .padding(.horizontal)
            .padding(.bottom, 12)
            .navigationBarHidden(true)
            .sheet(isPresented: $viewModel.showSearchSheet) {
                SearchMallModalView()
            }
            .onAppear {
                locationManager.requestLocation()
            }
            .onReceive(locationManager.$currentLocation) { newLocation in
                guard let coordinate = newLocation else { return }
                withAnimation {
                    viewModel.cameraPosition = .region(
                        MKCoordinateRegion(
                            center: coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                        )
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    private var sessionCard: some View {
        switch viewModel.sessionState {
        case .empty:
            EmptySessionCard {
                // TODO: sambungin ke BookingDetails setelah router/navigation flow untuk booking digarap
            }
            
        case .upcoming(let session):
            UpcomingSessionCard(
                session: session,
                onNavigate: { viewModel.openMaps(for: session) },
                onCallStaff: { viewModel.callStaff(phoneNumber: session.staffNumber, openURL: openURL) }
            )
            
        case .active(let session):
            ActiveSessionCard(
                session: session,
                remainingTime: viewModel.remainingTime,
                onOpenSlot: { viewModel.openSlot() },
                onCallStaff: { viewModel.callStaff(phoneNumber: session.staffNumber, openURL: openURL) }
            )
        }
    }
}

#Preview("Active State with TabBar") {
    RootTabView(
        selectedTab: .constant("Home"),
        viewModel: HomeViewModel(
            sessionState: .active(
                BookingSession(
                    mallName: "AEON Mall BSD City",
                    floor: "B2",
                    zone: "Red Zone",
                    slot: "A1",
                    bookingDateTime: .now,
                    sessionEndDate: .now.addingTimeInterval(5449),
                    staffNumber: "+622112345678"
                )
            )
        )
    )
}
