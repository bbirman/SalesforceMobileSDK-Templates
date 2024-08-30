//
//  Settings.swift
//  MobileSyncExplorerSwift
//
//  Created by Brianna Birman on 8/16/24.
//  Copyright © 2024 MobileSyncExplorerSwiftOrganizationName. All rights reserved.
//

import SwiftUI
import SalesforceSDKCore
import MobileSync


class SettingsViewModel: ObservableObject {
    @Published var alertContent: AlertContent?
    @Published var showAlertContent = false
    @ObservedObject var sObjectDataManager: SObjectDataManager

    init(sObjectDataManager: SObjectDataManager)  {
        self.sObjectDataManager = sObjectDataManager
    }

    
    // MARK: User Actions
    func alertOkTapped() {
        withAnimation {
            alertContent = nil
            showAlertContent = false
        }
    }

    func alertStopTapped() {
        stopSyncManager()
        updateAlert(info: "\nRequesting sync manager stop")
    }


    private func createAlert(title: String, message: String?, stopButton: Bool, okayButton: Bool = false) {
        alertContent = AlertContent(title: title, message: message, stopButton: stopButton, okayButton: okayButton)
        showAlertContent = true
    }

    func cleanGhosts() {
        createAlert(title: "Cleaning Sync Ghosts", message: nil, stopButton: true)
        sObjectDataManager.cleanGhosts(onError: { [weak self] mobileSyncError in
            self?.updateAlert(info: "Failed with error \(mobileSyncError)")
        }, onValue: { [weak self] numRecords in
            self?.updateAlert(info: "Clean ghosts: \(numRecords) records")
        })
    }

    func clearLocalData() {
        sObjectDataManager.clearLocalData()
    }

    func refreshLocalData() {
        sObjectDataManager.loadLocalData()
    }

    func syncDown() {
        sync(syncName: sObjectDataManager.kSyncDownName)
    }

    func syncUp() {
        sync(syncName: sObjectDataManager.kSyncUpName)
    }

    func resumeSyncManager() {
        createAlert(title: "Resuming Sync Manager", message: nil, stopButton: true)
        do {
            try sObjectDataManager.resumeSyncManager { [weak self] syncState in
                let isLast = syncState.status != .running
                self?.updateAlert(info: self?.infoForSyncState(syncState), okayButton: isLast)
            }
        } catch {
            self.updateAlert(info: "Failed with error \(error)")
        }
    }

    func stopSyncManager() {
        sObjectDataManager.stopSyncManager()
    }

    
    func stopAction() {
        sObjectDataManager.stopSyncManager()
        updateAlert(info: "\nRequesting sync manager stop")
    }
    
    private func sync(syncName: String) {
        createAlert(title: "Running \(syncName)", message: nil, stopButton: true)
        sObjectDataManager.sync(syncName: syncName, onError: { [weak self] mobileSyncError in
            self?.updateAlert(info: "Failed with error: \(mobileSyncError)")
        }, onValue: { [weak self] syncState in
        let info = self?.infoForSyncState(syncState)
            let isLast = syncState.status != .running
            self?.updateAlert(info: info, okayButton: isLast)
       })
    }
    
    
    
    func showInfo() {
        let syncManagerState = sObjectDataManager.isSyncManagerStopping() ? "stopping" : (sObjectDataManager.isSyncManagerStopped() ? "stopped" : "accepting_syncs")
        let info = ""
           + "syncManager:\(syncManagerState)\n"
            + "numberOfContacts=\(sObjectDataManager.countContacts())\n"
            + "syncDownContacts=\(infoForSyncState(sObjectDataManager.getSync("syncDownContacts")))\n"
            + "syncUpContacts=\(infoForSyncState(sObjectDataManager.getSync("syncUpContacts")))"
       
        createAlert(title: "Sync Info", message: info, stopButton: false, okayButton: true)
    }
    
    private func updateAlert(info: String?, okayButton: Bool = true) {
        showAlertContent = true
        if alertContent != nil {
            alertContent!.message = info
            alertContent!.okayButton = okayButton
        }
    }
    
    private func infoForSyncState(_ syncState: SyncState?) -> String {
        guard let syncState = syncState else {
            return "No sync provided"
        }
        return "\(syncState.progress)% \(SyncState.syncStatus(toString:syncState.status)) totalSize: \(syncState.totalSize) maxTs: \(syncState.maxTimeStamp)"
    }
}



struct Settings: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var modalPresented: ModalAction?
    @State private var logoutAlertPresented = false
    
    init(sObjectDataManager: SObjectDataManager) {
        viewModel = SettingsViewModel(sObjectDataManager: sObjectDataManager)
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button("Clear Local Data", action: viewModel.clearLocalData)
                    Button("Show Info", action: viewModel.showInfo)
                    Button("Refresh Local Data", action: viewModel.refreshLocalData)
                    Button("Sync Down", action: viewModel.syncDown)
                    Button("Sync Up", action: viewModel.syncUp)
                    Button("Clean Sync Ghosts", action: viewModel.cleanGhosts)
                    Button("Stop Sync Manager", action: viewModel.stopSyncManager)
                    Button("Resume Sync Manager", action: viewModel.resumeSyncManager)
                }
                
                Section {
                    Button("Inspect Database", action: {
                        modalPresented = .inspectDB
                    })
                }
                
                
                Section {
                    Button("Logout", action: {
                        logoutAlertPresented = true
                    })
                    Button("Switch User", action: {
                        modalPresented = .switchUser
                    })
                }
            }
            .sheet(item: $modalPresented) { creationType in
                if creationType == ModalAction.inspectDB { //let store = self.viewModel.sObjectDataManager.store,
                    //                 InspectorViewControllerWrapper(store: store)
                } else if creationType == ModalAction.switchUser {
                    SalesforceUserManagementViewControllerWrapper()
                }
            }
            
            
            .alert(viewModel.alertContent?.title ?? "", isPresented: $viewModel.showAlertContent) {
                if viewModel.alertContent?.stopButton ?? false {
                    Button("Stop") {
                        viewModel.alertStopTapped()
                    }
                }
                if viewModel.alertContent?.okayButton ?? false {
                    Button("Okay") {
                        viewModel.alertOkTapped()
                    }
                }
            } message: {
                Text(viewModel.alertContent?.message ?? "")
            }
            .alert(isPresented: $logoutAlertPresented, content: {
                Alert(title: Text("Are you sure you want to log out?"),
                      primaryButton: .destructive(Text("Logout"), action: {
                          UserAccountManager.shared.logout()
                      }),
                      secondaryButton: .cancel())
            })
        }
    }
}


// TODO
//#Preview {
//   // Settings()
//}
