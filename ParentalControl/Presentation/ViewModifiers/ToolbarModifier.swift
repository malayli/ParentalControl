import SwiftUI
import FamilyControls

struct ToolbarModifier: ViewModifier {
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel
    @Binding var tempSelection: FamilyActivitySelection
    let isParent: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if isParent {
            content.toolbar { ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    scheduleViewModel.saveSchedule(selectedApps: tempSelection)
                } label: {
                    Text("Save")
                }
            }
            }

        } else {
            content
        }
    }
}
