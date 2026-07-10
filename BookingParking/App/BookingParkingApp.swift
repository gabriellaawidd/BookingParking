import SwiftUI

@main
struct C4_JasJusApp: App {
    @State private var selectedTab: String = "Home"
    
    var body: some Scene {
        WindowGroup {
            RootTabView(selectedTab: $selectedTab, viewModel: HomeViewModel())
        }
    }
}

