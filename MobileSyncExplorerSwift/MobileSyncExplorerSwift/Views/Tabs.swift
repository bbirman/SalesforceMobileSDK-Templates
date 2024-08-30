//
//  Tabs.swift
//  MobileSyncExplorerSwift
//
//  Created by Brianna Birman on 8/12/24.
//  Copyright © 2024 MobileSyncExplorerSwiftOrganizationName. All rights reserved.
//

import SwiftUI
import SalesforceSDKCore

struct Tabs: View {
    @State private var selectedTab = "One" // TODO
    var sObjectDataManager: SObjectDataManager
    
    var body: some View {
        TabView {
            ContactListView(sObjectManager: sObjectDataManager)
                .tabItem {
                    Label("Contacts", systemImage: "person.2.fill")
                }
            
            Text("Notifications")
                .tabItem {
                    Label(title: {
                        Text("Notifications")
                    }, icon: {
                        NotificationBell(notificationModel: NotificationListModel(), sObjectDataManager: sObjectDataManager)
                    })
                }
            
            Settings(sObjectDataManager: sObjectDataManager)
                .tabItem {
                    Label(title: {
                        Text("Settings")
                    }, icon: {
                        Image("setting").renderingMode(.template)
                    })
                }
        }
    }
}

#Preview {
    let credentials = OAuthCredentials(identifier: "test", clientId: "", encrypted: false)!
    let userAccount = UserAccount(credentials: credentials)
    let sObjectManager = SObjectDataManager.sharedInstance(for: userAccount)
    
    return Tabs(sObjectDataManager: sObjectManager)
}
