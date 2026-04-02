import SwiftUI

@main
struct GovOpsApp: App {
    @StateObject private var dataService = DataService.shared

    var body: some Scene {
        WindowGroup {
            JobListView()
                .environmentObject(dataService)
        }
    }
}
