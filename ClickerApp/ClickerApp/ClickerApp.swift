import SwiftUI

@main
struct ClickerApp: App {
    @StateObject private var simulator = TouchSimulator()
    @State private var selectedTab = 0

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(simulator)
        }
    }
}
