//
//  ProfileView.swift
//  NoName
//
//  Created by 中島昂海 on 2024/03/24.
//

import SwiftUI
import HealthKit

struct TopPage: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var topPageViewModel: TopPageViewModel
    @EnvironmentObject var manager: StepRepository
    var body: some View {
        if let user = authViewModel.currentUser {
            NavigationView {
                ZStack {
                    // 背景色
                    VStack(spacing: 0) {
                        Color.customThemeColor
                            .frame(height: 144)
                        Color.customSubColor
                    }
                    .edgesIgnoringSafeArea(.all)
                    
                    // アカウント情報
                    VStack(alignment: .center) {
                        
                        Spacer()
                            .frame(height: 16)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.customSubColor)
                            .frame(height: 100)
                            .shadow(radius: 5)
                            .overlay(
                                HStack {
                                    Text(user.initials)
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .frame(width: 64, height: 64)
                                        .background(Color(.systemGray3))
                                        .clipShape(Circle())
                                    VStack(alignment: .leading) {
                                        Text(user.fullname)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .padding(.top, 4)
                                        Text(user.email)
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    VStack {
                                        Text(topPageViewModel.stepData.step.formattedString())
                                            .font(.system(size: 24))
                                            .fontWeight(.bold)
                                        
                                        Text("(\(topPageViewModel.stepData.timeStamp.displayDateString())更新)")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                            .fontWeight(.light)
                                    }
                                    
                                }
                                    .padding()
                                    .onAppear {
                                        Task {
                                            try await topPageViewModel.fetchAndSaveSteps(uid: authViewModel.currentUser!.id)
                                        }
                                    }
                            )
                            .padding()
                        
                        Spacer()
                        
                        NavigationLink(destination: SearchUserPage()) {
                            Text("ユーザ検索画面")
                                .foregroundColor(Color.customThemeColor)
                        }
                        
                        Spacer()
                        
                        Button {
                            authViewModel.signOut()
                        } label: {
                            SettingsRow(
                                imageName: "arrow.left.circle.fill",
                                title: "Sign Out",
                                tintColor: Color.customThemeColor
                            )
                        }
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    TopPage()
}
