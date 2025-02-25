import SwiftUI

struct SettingsView: View {
    let isParent: Bool
    @State private var showingScheduleView: Bool = false
    @State private var settingsViewModel = SettingsViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button("Create an app Limit >") {
                        showingScheduleView = true
                    }
                    .font(.headline)
                    Spacer()
                }
                .padding(.all, 20)

                Spacer()
            }
            .navigationDestination(isPresented: $showingScheduleView) {
                ScheduleView(isParent: isParent)
            }
            .navigationTitle("Settings")
        }
    }
}
