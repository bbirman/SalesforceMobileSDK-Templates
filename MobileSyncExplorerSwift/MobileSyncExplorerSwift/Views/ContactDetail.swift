//
//  ContactDetail.swift
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

struct ContactReadView: View {
    var contact: ContactSObjectData
    var account: [String: Any]?
    let sobjectDataManager: SObjectDataManager

    var body: some View {
        List {
            ReadViewField(fieldName: "First Name", fieldValue: contact.firstName)
            ReadViewField(fieldName: "Last Name", fieldValue: contact.lastName)
            ReadViewLinkField(fieldName: "Account", objectType: "Account", objectData: account, sobjectDataManager: sobjectDataManager)
            ReadViewField(fieldName: "Mobile Phone", fieldValue: contact.mobilePhone)
            ReadViewField(fieldName: "Home Phone", fieldValue: contact.homePhone)
            ReadViewField(fieldName: "Job Title", fieldValue: contact.title)
            ReadViewField(fieldName: "Email Address", fieldValue: contact.email)
            ReadViewField(fieldName: "Department", fieldValue: contact.department)
        }
    }
}

struct AccountReadView: View {
    var account: AccountSObjectData
    var opportunities: [OpportunitySObjectData]?
    let sobjectDataManager: SObjectDataManager

    var body: some View {
        
        List {
            ReadViewField(fieldName: "Name", fieldValue: account.name)
            ReadViewField(fieldName: "Industry", fieldValue: account.industry)
            ReadViewField(fieldName: "Phone", fieldValue: account.phone)
            ReadViewField(fieldName: "Website", fieldValue: account.website)
            
            if let opportunities = opportunities, !opportunities.isEmpty {
                Section(header: Text("Related Opportunities")) {
                    ForEach(opportunities) { opportunity in
                        ReadViewLinkField(fieldName: nil, objectType: "Opportunity", objectData: opportunity.soupDict, sobjectDataManager: sobjectDataManager)
                    }
                }
            }
        }
       // Spacer()
       
//        if let opportunities = opportunities {
//            Text("Related Opportunities")
//            List(opportunities) {
////            opportunities?.forEach { opportunity in
//                ReadViewLinkField(fieldName: "Opportunity", objectType: "Opportunity", objectData: $0.soupDict, sobjectDataManager: sobjectDataManager)
//            }
//        }
        
    }
}

struct OpportunityReadView: View {
    var opportunity: OpportunitySObjectData
    let sobjectDataManager: SObjectDataManager

    var body: some View {
        List {
            ReadViewField(fieldName: "Name", fieldValue: opportunity.name)
            ReadViewField(fieldName: "Description", fieldValue: opportunity.description)
            ReadViewField(fieldName: "Amount", fieldValue: opportunity.amount)
            ReadViewField(fieldName: "Close Date", fieldValue: opportunity.closeDate)
        }
    }
}


struct ReadViewLinkField: View {
    var fieldName: String?
    var fieldDisplayValue: String?
    var objectType: String?
    var objectData: [String: Any]?
    let sobjectDataManager: SObjectDataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            if let fieldDisplayValue = objectData?["Name"] as? String {
                NavigationLink {
                    if let recordId = objectData?["Id"] as? String {
                        
                    
                        if objectType == "Account" {
                            AccountDetailView(id: recordId, sObjectDataManager: sobjectDataManager) {
                        
                            }
                        } else if objectType == "Opportunity" {
                            OpportunityDetailView(id: recordId, sObjectDataManager: sobjectDataManager) {
                                
                            }
                        }
                    }
//                    NavigationLink(destination: ContactDetailView(localId: viewModel.selectedRecord, sObjectDataManager: self.viewModel.sObjectDataManager, dismiss: { self.viewModel.dismissDetail()}), isActive: $viewModel.showContactDetail) { EmptyView() }
                } label: {
                    VStack(alignment: .leading, spacing: 3) {
                        if let fieldName = fieldName {
                            Text(fieldName).font(.subheadline).foregroundColor(.secondaryLabelText)
                        }
                        
                        
                        Text(fieldDisplayValue)
                    }
                }
            }
        }
    }
}

struct ReadViewField: View {
    var fieldName: String
    var fieldValue: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(fieldName).font(.subheadline).foregroundColor(.secondaryLabelText)
            Text(fieldValue ?? "")
        }
    }
}

struct EditView: View {
    @Binding var contact: ContactSObjectData

    var body: some View {
        Form {
            TextField("First Name", text: $contact.firstName.bound)
                .disableAutocorrection(true)
            TextField("Last Name", text: $contact.lastName.bound)
                .disableAutocorrection(true)
            TextField("Mobile Phone", text: $contact.mobilePhone.bound)
                .keyboardType(.numberPad)
            TextField("Home Phone", text: $contact.homePhone.bound)
                .keyboardType(.numberPad)
            TextField("Job Title", text: $contact.title.bound)
            TextField("Email Address", text: $contact.email.bound)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            TextField("Department", text: $contact.department.bound)
        }
    }
}

struct OpportunityDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: OpportunityDetailViewModel
    @State private var isEditing: Bool = false
    private var onAppearAction: () -> Void = {}
    private var dismissAction: () -> Void = {}
    private let sobjectDataManager: SObjectDataManager

    init(id: String, sObjectDataManager: SObjectDataManager, onAppear: @escaping () -> Void) {
        self.viewModel = OpportunityDetailViewModel(id: id, sObjectDataManager: sObjectDataManager)
        self.onAppearAction = onAppear
        self.sobjectDataManager = sObjectDataManager
    }

    var body: some View {
        VStack {
            OpportunityReadView(opportunity: viewModel.opportunity, sobjectDataManager: sobjectDataManager)
           
            Spacer()
//            DeleteButton(label: viewModel.deleteButtonTitle(), isDisabled: viewModel.isNewRecord) {
//                self.viewModel.deleteButtonTapped()
//                self.dismissAction()
//            }
        }.onAppear {
            self.onAppearAction()
        }
        .navigationBarTitle(Text(viewModel.title), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                if self.isEditing {
                    withAnimation {
                       self.isEditing.toggle()
                    }
                } else {
                    self.presentationMode.wrappedValue.dismiss()
                    self.dismissAction()
                }
            }, label: {
                if self.isEditing {
                    Text("Cancel")
                } else {
                    HStack {
                        Image("backArrow")
                            .renderingMode(.template)
                        Text("Back")
                    }
                }
            }), trailing:
            Button(action: {
                if self.isEditing {
                    self.viewModel.saveButtonTapped()
                    self.dismissAction()
                }
                withAnimation {
                   self.isEditing.toggle()
                }
            }, label: {
                self.isEditing ? Text("Save") : Text("Edit")
            })
        )
    }
}

struct AccountDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: AccountDetailViewModel
    @State private var isEditing: Bool = false
    private var onAppearAction: () -> Void = {}
    private var dismissAction: () -> Void = {}
    private let sobjectDataManager: SObjectDataManager

    init(id: String, sObjectDataManager: SObjectDataManager, onAppear: @escaping () -> Void) {
        self.viewModel = AccountDetailViewModel(id: id, sObjectDataManager: sObjectDataManager)
        self.onAppearAction = onAppear
        self.sobjectDataManager = sObjectDataManager
    }

    var body: some View {
        VStack {
            AccountReadView(account: viewModel.account, opportunities: viewModel.opportunities, sobjectDataManager: sobjectDataManager)
           
            Spacer()
//            DeleteButton(label: viewModel.deleteButtonTitle(), isDisabled: viewModel.isNewRecord) {
//                self.viewModel.deleteButtonTapped()
//                self.dismissAction()
//            }
        }.onAppear {
            self.onAppearAction()
        }
        .navigationBarTitle(Text(viewModel.title), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                if self.isEditing {
                    withAnimation {
                       self.isEditing.toggle()
                    }
                } else {
                    self.presentationMode.wrappedValue.dismiss()
                    self.dismissAction()
                }
            }, label: {
                if self.isEditing {
                    Text("Cancel")
                } else {
                    HStack {
                        Image("backArrow")
                            .renderingMode(.template)
                        Text("Back")
                    }
                }
            }), trailing:
            Button(action: {
                if self.isEditing {
                    self.viewModel.saveButtonTapped()
                    self.dismissAction()
                }
                withAnimation {
                   self.isEditing.toggle()
                }
            }, label: {
                self.isEditing ? Text("Save") : Text("Edit")
            })
        )
    }
}


struct ContactDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: ContactDetailViewModel
    @State private var isEditing: Bool = false
    private var onAppearAction: () -> Void = {}
    private var dismissAction: () -> Void = {}
    private let sobjectDataManager: SObjectDataManager
    

    init(id: String, sObjectDataManager: SObjectDataManager, onAppear: @escaping () -> Void) {
        self.viewModel = ContactDetailViewModel(id: id, sObjectDataManager: sObjectDataManager)
        self.onAppearAction = onAppear
        self.sobjectDataManager = sObjectDataManager
    }

    init(localId: String?, sObjectDataManager: SObjectDataManager, dismiss: @escaping () -> Void) {
        self.viewModel = ContactDetailViewModel(localId: localId, sObjectDataManager: sObjectDataManager)
        self.dismissAction = dismiss
        self.sobjectDataManager = sObjectDataManager
        if viewModel.isNewRecord {
            self._isEditing = State(initialValue: true)
        }
    }

    var body: some View {
        VStack {
            if isEditing {
                EditView(contact: $viewModel.contact)
            } else {
                ContactReadView(contact: viewModel.contact, account: viewModel.account, sobjectDataManager: sobjectDataManager)
            }
            Spacer()
            DeleteButton(label: viewModel.deleteButtonTitle(), isDisabled: viewModel.isNewRecord) {
                self.viewModel.deleteButtonTapped()
                self.dismissAction()
            }
        }.onAppear {
            self.onAppearAction()
        }
        .navigationBarTitle(Text(viewModel.title), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                if self.isEditing {
                    withAnimation {
                       self.isEditing.toggle()
                    }
                } else {
                    self.presentationMode.wrappedValue.dismiss()
                    self.dismissAction()
                }
            }, label: {
                if self.isEditing {
                    Text("Cancel")
                } else {
                    HStack {
                        Image("backArrow")
                            .renderingMode(.template)
                        Text("Back")
                    }
                }
            }), trailing:
            Button(action: {
                if self.isEditing {
                    self.viewModel.saveButtonTapped()
                    self.dismissAction()
                }
                withAnimation {
                   self.isEditing.toggle()
                }
            }, label: {
                self.isEditing ? Text("Save") : Text("Edit")
            })
        )
    }
}

struct DeleteButton: View {
    let label: String
    let isDisabled: Bool
    let action: () -> ()
    
    func buttonBackground() -> Color {
        isDisabled ? Color.disabledDestructiveButton : Color.destructiveButton
    }

    var body: some View {
        Button(action: {
            self.action()
        }, label: {
            Text(label)
            .frame(width: 350, height: 50, alignment: .center)
            .background(buttonBackground())
            .foregroundColor(.white)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(buttonBackground(), lineWidth: 1))
            .padding([.bottom], 10)
        }).disabled(isDisabled)
    }
}
