import SwiftUI
import FamilyControls

struct ScheduleView: View {
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel
    @State var tempSelection = FamilyActivitySelection()
    let isParent: Bool

    var body: some View {
        VStack {
            setupListView()
        }
        .background(Color(UIColor.secondarySystemBackground))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .modifier(ToolbarModifier(tempSelection: $tempSelection, isParent: isParent))
        .navigationTitle("Schedule")
        .navigationBarTitleDisplayMode(.inline)
        .familyActivityPicker(
            isPresented: $scheduleViewModel.isFamilyActivitySectionActive,
            selection: $tempSelection
        )
        .alert("It has been saved.", isPresented: $scheduleViewModel.isSaveAlertActive) {
            Button("OK", role: .cancel) {
            }
        }
        .alert("When monitoring is stopped, the set time and app are reset.",
               isPresented: $scheduleViewModel.isStopMonitoringAlertActive) {
            Button("Cancel", role: .cancel) {}
            Button("Approve", role: .destructive) {
                tempSelection = FamilyActivitySelection()
                scheduleViewModel.stopScheduleMonitoring()
            }
        }
        .alert("When you remove permission, the schedule is also removed.",
               isPresented: $scheduleViewModel.isRevokeAlertActive) {
            Button("Cancel", role: .cancel) {
            }
            Button("Approve", role: .destructive) {
                FamilyControlsManager.shared.requestAuthorizationRevoke()
            }
        }
        .onAppear {
            tempSelection = scheduleViewModel.selection
        }
    }
}

// MARK: - Views
extension ScheduleView {
    /// 스케쥴 페이지 내 전체 리스트 뷰입니다.
    private func setupListView() -> some View {
        List {
            if isParent {
                setUpTimeSectionView()
                setUPAppSectionView()
                stopScheduleMonitoringSectionView()
                revokeAuthSectionView()

            } else {
                revokeAuthSectionView()
            }
        }
        .listStyle(.insetGrouped)
    }
    
    /// 전체 리스트 중 시간 설정 섹션에 해당하는 뷰입니다.
    private func setUpTimeSectionView() -> some View {
        let TIME_LABEL_LIST = ["Start time", "End time"]
        let times = [$scheduleViewModel.scheduleStartTime, $scheduleViewModel.scheduleEndTime]
        
        return Section(
            header: Text(ScheduleSectionInfo.time.header),
            footer: Text(ScheduleSectionInfo.time.footer)) {
                ForEach(0..<TIME_LABEL_LIST.count, id: \.self) { index in
                    DatePicker(selection: times[index], displayedComponents: .hourAndMinute) {
                        Text(TIME_LABEL_LIST[index])
                    }
                }
            }
    }
    
    /// 전체 리스트 중 앱 설정 섹션에 해당하는 뷰입니다.
    private func setUPAppSectionView() -> some View {
        let BUTTON_LABEL = "Change"
        let EMPTY_TEXT = "Choose Your App"
        
        return Section(
            header: HStack {
                Text(ScheduleSectionInfo.apps.header)
                Spacer()
                Button {
                    scheduleViewModel.showFamilyActivitySelection()
                } label: {
                    Text(BUTTON_LABEL)
                }
            },
            footer: Text(ScheduleSectionInfo.apps.footer)
        ) {
            if isSelectionEmpty() {
                Text(EMPTY_TEXT)
                    .foregroundColor(Color.secondary)
            } else {
                ForEach(Array(tempSelection.applicationTokens), id: \.self) { token in
                    Label(token)
                }
                ForEach(Array(tempSelection.categoryTokens), id: \.self) { token in
                    Label(token)
                }
                ForEach(Array(tempSelection.webDomainTokens), id: \.self) { token in
                    Label(token)
                }
            }
        }
    }
    
    /// 전체 리스트 중 스케줄 모니터링 중단 섹션에 해당하는 뷰입니다.
    private func stopScheduleMonitoringSectionView() -> some View {
        Section(
            header: Text(ScheduleSectionInfo.monitoring.header)
        ) {
            stopScheduleMonitoringButtonView()
        }
    }
    
    /// 스케줄 모니터링 중단 섹션의 버튼에 해당하는 버튼입니다.
    private func stopScheduleMonitoringButtonView() -> some View {
        let BUTTON_LABEL = "Stop monitoring schedule"

        return Button {
            scheduleViewModel.showStopMonitoringAlert()
        } label: {
            Text(BUTTON_LABEL)
                .tint(Color.red)
        }
    }
    
    /// 전체 리스트 중 권한 제거 섹션에 해당하는 뷰입니다.
    private func revokeAuthSectionView() -> some View {
        Section(
            header: Text(ScheduleSectionInfo.revoke.header)
        ) {
            revokeAuthButtonView()
        }
    }
    
    /// 권한 제거 섹션의 버튼에 해당하는 버튼입니다.
    /// 버튼 클릭 시 alert 창을 통해 스크린 타임 권한을 제거할 수 있습니다.
    private func revokeAuthButtonView() -> some View {
        let BUTTON_LABEL = "Remove Screen Time Permissions"

        return Button {
            scheduleViewModel.showRevokeAlert()
        } label: {
            Text(BUTTON_LABEL)
                .tint(Color.red)
        }
    }
    
}

// MARK: - Methods

extension ScheduleView {
    private func isSelectionEmpty() -> Bool {
        tempSelection.applicationTokens.isEmpty &&
        tempSelection.categoryTokens.isEmpty &&
        tempSelection.webDomainTokens.isEmpty
    }
}
