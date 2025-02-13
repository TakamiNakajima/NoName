import SwiftUI

struct BaseView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresented = false
    
    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                AppView(isPresented: $isPresented)
                    .sheet(isPresented: $isPresented, onDismiss: {
                        isPresented = false
                    }) {
                        AddPage(isPresented: $isPresented)
                    }
                    .onChange(of: scenePhase) { newPhase in
                        if newPhase == .active {
                                isPresented = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    isPresented = true
                                }
                            }
                    }
            } else {
                LoginPage()
                    .modelContainer(for: UserCredentials.self)
            }
        }
    }
}
