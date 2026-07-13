import SwiftUI

@main
struct C4_JasJusApp: App {
    @State private var selectedTab: String = "Home"
    @State private var notificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            RootTabView(selectedTab: $selectedTab, viewModel: HomeViewModel())
                .onAppear {
                    notificationManager.requestPermission()
                }
        }
    }
}

