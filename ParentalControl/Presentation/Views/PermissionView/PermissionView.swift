import SwiftUI
import FamilyControls

struct PermissionView: View {
    @StateObject private var permissionViewModel = PermissionViewModel()
    @State private var isParent: Bool?
    @State private var permissionError: Error?

    @ViewBuilder
    func mainView(for member: FamilyControlsMember) -> some View {
        if let permissionError {
            Text(permissionError.localizedDescription)

        } else {
            VStack(alignment: .center) {
                navigationHeaderLikeView()
                decorationView()
                permissionButtonView(for: member)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .top
            )
            .sheet(isPresented: $permissionViewModel.isSheetActive) {
                sheetView()
            }
            .onAppear {
                permissionViewModel.handleTranslationView()
            }
        }
    }

    var body: some View {
        if let isParent {
            mainView(for: isParent ? .individual : .child)

        } else {
            VStack {
                Button("I'm a parent") {
                    isParent = true
                }

                Button("I'm a child") {
                    isParent = false
                }
            }
        }
    }
}

// MARK: - Views
extension PermissionView {
    private func navigationHeaderLikeView() -> some View {
        HStack {
            Button {
                permissionViewModel.showIsSheetActive()
            } label: {
                Image(systemName: permissionViewModel.HEADER_ICON_LABEL)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.secondary)
            }
            .frame(width: 40, height: 40)
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: 42, alignment: .trailing)
        .opacity(permissionViewModel.isViewLoaded ? 1 : 0)
    }
    
    private func decorationView() -> some View {
        VStack(spacing: 12) {
            Image(permissionViewModel.DECORATION_TEXT_INFO.imgSrc)
                .resizable()
                .frame(width: 100, height: 100)
            if permissionViewModel.isViewLoaded {
                Text(permissionViewModel.DECORATION_TEXT_INFO.title)
                    .font(.largeTitle)
                    .foregroundColor(Color.primaryColor)
                    .bold()
                Text(permissionViewModel.DECORATION_TEXT_INFO.subTitle)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func permissionButtonView(for member: FamilyControlsMember) -> some View {
        HStack {
            Button {
                permissionViewModel.handleRequestAuthorization(for: member, errorCompletion: { error in
                    permissionError = error
                })
            } label: {
                Text(permissionViewModel.PERMISSION_BUTTON_LABEL)
            }
            .buttonStyle(.borderless)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: 128)
        .opacity(permissionViewModel.isViewLoaded ? 1 : 0)
    }
    
    private func sheetView() -> some View {
        VStack {
            Text(permissionViewModel.SHEET_INFO_LIST)
                .multilineTextAlignment(.center)
                .padding(.bottom, 24)
                .font(.title2)
        }
        .padding(24)
    }
}
