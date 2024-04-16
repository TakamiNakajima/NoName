//
//  NoNameApp.swift
//  NoName
//
//  Created by 中島昂海 on 2024/03/22.
//

import SwiftUI
import Firebase

@main
struct NoNameApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var topPageViewModel = TopPageViewModel()
    @StateObject var userSearchViewModel = SearchUserViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(topPageViewModel)
                .environmentObject(userSearchViewModel)
        }
    }
}
