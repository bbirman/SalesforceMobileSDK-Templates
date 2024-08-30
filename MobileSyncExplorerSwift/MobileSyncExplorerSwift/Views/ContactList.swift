//
//  ContactList.swift
//  MobileSyncExplorerSwift
//
//  Created by Brianna Birman on 3/20/20.
//  Copyright (c) 2020-present, salesforce.com, inc. All rights reserved.
//
//  Redistribution and use of this software in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//  * Redistributions of source code must retain the above copyright notice, this list of conditions
//  and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright notice, this list of
//  conditions and the following disclaimer in the documentation and/or other materials provided
//  with the distribution.
//  * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
//  endorse or promote products derived from this software without specific prior written
//  permission of salesforce.com, inc.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
//  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
//  WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import SwiftUI
import MobileSync

struct ContactListView: View {
    @ObservedObject var viewModel: ContactListViewModel
    private var notificationModel = NotificationListModel()
    private let sObjectManager: SObjectDataManager
    @State private var columnVisibility =
    NavigationSplitViewVisibility.doubleColumn
    
    @State private var searchTerm: String = ""
    
    init(sObjectManager: SObjectDataManager, selectedRecord: String? = nil, newContact: Bool = false, searchFocused: Bool = false) {
        self.sObjectManager = sObjectManager
        self.viewModel = ContactListViewModel(sObjectDataManager: sObjectManager, presentNewContact: newContact, selectedRecord: selectedRecord)
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            ScrollViewReader { proxy in
                List(viewModel.sObjectDataManager.contacts.filter { contact in
                    self.searchTerm.isEmpty ? true : self.viewModel.contactMatchesSearchTerm(contact: contact, searchTerm: self.searchTerm)
                },
                     selection: $viewModel.selectedRecord) { contact in
                    ContactCell(contact: contact)
                        .onDrag { return viewModel.itemProvider(contact: contact) }
                }
                 .listStyle(.plain)
                 .searchable(text: $searchTerm)
                 .navigationBarTitle("Contacts")
                 .navigationBarItems(trailing: NavBarButtons(viewModel: viewModel, notificationModel: notificationModel))
            }
            
        } detail: {
            ContactDetailView(localId: viewModel.selectedRecord, sObjectDataManager: self.viewModel.sObjectDataManager)
        }
        .navigationSplitViewStyle(BalancedNavigationSplitViewStyle())
        .onAppear {
            self.notificationModel.fetchNotifications()
        }.sheet(isPresented: $viewModel.newContact, content: {
            NavigationStack {
                ContactDetailView(localId: nil, sObjectDataManager: sObjectManager) { newContactId in
                    viewModel.selectedRecord = newContactId
                }
            }
        })
        
        // TODO
       // if viewModel.alertContent != nil {
       //                    StatusAlert(viewModel: viewModel)
       //                }
    }
}

struct StatusAlert: View {
    @ObservedObject var viewModel: SettingsViewModel

    func twoButtonDisplay() -> Bool {
        if let alertContent = viewModel.alertContent {
            return alertContent.okayButton && alertContent.stopButton
        }
        return false
    }

    func stopButton() -> Bool {
        return viewModel.alertContent?.stopButton ?? false
    }

    func okayButton() -> Bool {
        return viewModel.alertContent?.okayButton ?? false
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
            VStack {
                Text(viewModel.alertContent?.title ?? "").bold()
                Text(viewModel.alertContent?.message ?? "").lineLimit(nil)
                
                if stopButton() || okayButton() {
                    Divider()
                    HStack {
                        if stopButton() {
                            if twoButtonDisplay() {
                                Spacer()
                            }
                            Button(action: {
                                self.viewModel.alertStopTapped()
                            }, label: {
                                Text("Stop").foregroundColor(Color.blue)
                            })
                        }
                        
                        if twoButtonDisplay() {
                            Spacer()
                            Divider()
                            Spacer()
                        }

                        if okayButton() {
                            Button(action: {
                                self.viewModel.alertOkTapped()
                            }, label: {
                                Text("Ok").foregroundColor(Color.blue)
                            })
                            if twoButtonDisplay() {
                                Spacer()
                            }
                        }
                    }
                    .frame(height: 30)
                }
            }
            .padding(10)
            .frame(maxWidth: 300, minHeight: 100)
            .background(Color(UIColor.secondarySystemBackground))
            .opacity(1.0)
            .foregroundColor(Color(UIColor.label))
            .cornerRadius(20)
        }
    }
}

enum ModalAction: Identifiable {
    case switchUser
    case inspectDB
    case newContact

    var id: Int {
        return self.hashValue
    }
}

struct NavBarButtons: View {
    @ObservedObject var viewModel: ContactListViewModel
    @ObservedObject var notificationModel: NotificationListModel

    var body: some View {
        HStack {
            Button(action: {
                viewModel.newContactToggled()
            }, label: { Image("plusButton").renderingMode(.template) })
            Button(action: {
                self.viewModel.syncUpDown()
            }, label: { Image("sync").renderingMode(.template) })
        }
    }
}

struct NotificationBell: View {
    @ObservedObject var notificationModel: NotificationListModel
    var sObjectDataManager: SObjectDataManager

    var body: some View {
        NavigationLink(destination: NotificationList(model: notificationModel, sObjectDataManager: sObjectDataManager)) {
            ZStack {
                Image(systemName: "bell.fill").frame(width: 20, height: 30, alignment: .center)
                if notificationModel.unreadCount() > 0 {
                    ZStack {
                        Circle().foregroundColor(.red)
                        Text("\(notificationModel.unreadCount())").foregroundColor(.white).font(Font.system(size: 12))
                    }
                    .frame(width: 12, height: 12)
                    .position(x: 15, y: 10)
                }
              }
              .frame(width: 20, height: 30)
        }
    }
}

struct ContactCell: View {
    var contact: ContactSObjectData

    var body: some View {
        HStack {
            Circle()
                .fill(Color(ContactHelper.colorFromContact(lastName: contact.lastName)))
                .frame(width: 45, height: 45)
                .overlay(
                    Text(ContactHelper.initialsStringFromContact(firstName: contact.firstName, lastName: contact.lastName))
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                       // .kerning(0.3)
                )
           
            
            VStack(alignment: .leading) {
                Text(ContactHelper.nameStringFromContact(firstName: contact.firstName, lastName: contact.lastName))
                    .font(.headline)
                    .foregroundColor(Color(UIColor.label))
                Text(ContactHelper.titleStringFromContact(title: contact.title))
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabelText)
            }
            Spacer()
            if SObjectDataManager.dataLocallyUpdated(contact) {
                Image(systemName: "arrow.2.circlepath").foregroundColor(.appBlue)
            }
            if SObjectDataManager.dataLocallyCreated(contact) {
                Image(systemName: "plus").foregroundColor(.appBlue)
            }
            if SObjectDataManager.dataLocallyDeleted(contact) {
                Image(systemName: "trash").foregroundColor(.red)
            }
        }
        .padding([.all], 10)
    }
}

struct InspectorViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = InspectorViewController
    var store: SmartStore

    func updateUIViewController(_ uiViewController: InspectorViewController, context: Context) {
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<InspectorViewControllerWrapper>) -> InspectorViewControllerWrapper.UIViewControllerType {
        return InspectorViewController(store: store)
    }
}

struct SalesforceUserManagementViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = SalesforceUserManagementViewController
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<SalesforceUserManagementViewControllerWrapper>) -> SalesforceUserManagementViewControllerWrapper.UIViewControllerType {
        return SalesforceUserManagementViewController { _ in
            self.presentationMode.wrappedValue.dismiss()
        }
    }

    func updateUIViewController(_ uiViewController: SalesforceUserManagementViewControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<SalesforceUserManagementViewControllerWrapper>) {
    }
}

#Preview {
    let credentials = OAuthCredentials(identifier: "test", clientId: "", encrypted: false)!
    let userAccount = UserAccount(credentials: credentials)
    let sObjectManager = SObjectDataManager.sharedInstance(for: userAccount)
    
    return ContactListView(sObjectManager: sObjectManager)
}
