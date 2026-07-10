import SwiftUI
import MapKit

struct HomePageView: View {
    @Binding var selectedTab: String
    @State var viewModel: HomeViewModel
    @State private var locationManager = LocationManager()
    let userSession: UserSession
    @State private var errorMessage: String?
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack(alignment: .top) {
                Map(position: $viewModel.cameraPosition, selection: $viewModel.selectedMallID) {
                    UserAnnotation()

                    ForEach(viewModel.mapMalls) { mall in
                        Marker(mall.name, systemImage: "bag.fill", coordinate: mall.coordinate)
                            .tint(.orange)
                            .tag(mall.id)
                    }
                }
                .ignoresSafeArea()
                .onChange(of: viewModel.selectedMallID) { _, newID in
                    guard let newID, let mall = viewModel.mapMalls.first(where: {
                        $0.id == newID
                    }) else {
                        return
                    }
                    viewModel.selectedMall = mall
                    viewModel.selectedMallID = nil
                }

                VStack {
                    topSearchBar
                        .padding(.horizontal)
                        .padding(.top, 8)

                    Spacer()

                    sessionCard
                        .padding(.horizontal)
                        .padding(.bottom, 12)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: MallLocation.self) { mall in
                BookingDetailsView(
                    path: $viewModel.navigationPath,
                    viewModel: BookingFormViewModel(mall: mall),
                    userSession: userSession
                )
            }
            .navigationDestination(for: Booking.self) { booking in
                PaymentView(
                    viewModel: PaymentViewModel(booking: booking, userId: userSession.userId),
                    path: $viewModel.navigationPath,
                    homeViewModel: $viewModel
                )
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
            .presentationBackground(.regularMaterial)
        }
        .onAppear { locationManager.requestLocation() }
        .task {
            print("🟡 mulai ensureUser")
            do {
                try await userSession.ensureUser(name: "Taqwa")
                print("🟡 selesai ensureUser, userId:", userSession.userId as Any)
            } catch {
                print("🔴 ensureUser GAGAL:", error)
                print("🔴 detail:", error.localizedDescription)
            }
            await viewModel.loadMapMalls(userLocation: locationManager.currentLocation)
        }
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

    private var topSearchBar: some View {
        Button {
            viewModel.showSearchSheet = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)

                Text("Search mall")
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: .black.opacity(0.08), radius: 6, y: 2)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var sessionCard: some View {
        switch viewModel.sessionState {
        case .empty:
            EmptySessionCard {
                viewModel.showSearchSheet = true
            }
        case .upcoming(let booking):
            UpcomingSessionCard(
                session: booking,
                onNavigate: {
                    viewModel.openMaps(for: booking)
                },
                onCallStaff: {
                    if let staffNumber = booking.staffNumber {
                        viewModel.callStaff(phoneNumber: staffNumber, openURL: openURL)
                    }
                }
            )
        case .active(let booking):
            ActiveSessionCard(
                session: booking,
                isOpeningSlot: viewModel.isOpeningSlot,
                remainingTime: viewModel.remainingTime,
                onOpenSlot: {
                    Task{
                        await viewModel.openSlot()
                    }
                },
                onCallStaff: {
                    if let staffNumber = booking.staffNumber {
                        viewModel.callStaff(phoneNumber: staffNumber, openURL: openURL)
                    }
                }
            )
        }
    }
}
