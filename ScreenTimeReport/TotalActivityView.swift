import SwiftUI
import FamilyControls

struct TotalActivityView: View {
    var activityReport: ActivityReport
    
    var body: some View {
        VStack(spacing: 4) {
            Spacer(minLength: 24)
            Text("Children screen time total usage time")
                .font(.callout)
                .foregroundColor(.secondary)
            Text(activityReport.totalDuration.toString())
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 8)
            List {
                Section {
                    ForEach(activityReport.apps) { eachApp in
                        ListRow(eachApp: eachApp)
                    }
                } footer: {
                }
            }
        }
    }
}

struct ListRow: View {
    var eachApp: AppDeviceActivity
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 0) {
                if let token = eachApp.token {
                    Label(token)
                        .labelStyle(.iconOnly)
                        .offset(x: -4)
                }
                Text(eachApp.displayName)
                Spacer()
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 0) {
                        Text("Wakeup:")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(width: 72, alignment: .leading)
                        Text("\(eachApp.numberOfPickups) Pickups")
                            .font(.caption)
                            .bold()
                            .frame(minWidth: 24, alignment: .trailing)
                    }
                    HStack(spacing: 0) {
                        Text("Duration:")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(width: 72, alignment: .leading)
                        Text(String(eachApp.duration.toString()))
                            .font(.caption)
                            .bold()
                            .frame(minWidth: 24, alignment: .trailing)
                    }
                }
            }
            HStack {
                Text("App ID:")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text(eachApp.id)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .bold()
                Spacer()
            }
        }
        .background(.clear)
    }
}
