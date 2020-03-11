//
//  ContactListView.swift
//  MobileSyncExplorerSwift
//
//  Created by Brianna Birman on 2/28/20.
//  Copyright © 2020 MobileSyncExplorerSwiftOrganizationName. All rights reserved.
//

import SwiftUI

class ContactListViewModel {
    var dataRows: [SObjectData] = []
    
    init(dataRows: [SObjectData]) {
        self.dataRows = dataRows
    }
    
    func contactRows() -> [ContactSObjectData] {
        return dataRows as! [ContactSObjectData]
    }
}


class ContactCellModel {
    var contact: ContactSObjectData
    
    init(contact: ContactSObjectData) {
        self.contact = contact
    }
    
    func showRefresh() -> Bool {
        SObjectDataManager.dataLocallyUpdated(contact)
    }
    
    func showCreated() -> Bool {
        SObjectDataManager.dataLocallyCreated(contact)
    }
}



struct ContactCell: View {
    var contact: ContactSObjectData
    var contactCellModel: ContactCellModel
    
    init(contact: ContactSObjectData) {
        self.contactCellModel = ContactCellModel(contact: contact)
        self.contact = contact
    }
    
    var body: some View {
        HStack() {
            Image(uiImage: ContactHelper.initialsImage(ContactHelper.colorFromContact(contact), initials: ContactHelper.initialsStringFromContact(contact))!)
            VStack(alignment: .leading) {
                Text(ContactHelper.nameStringFromContact(contact)).font(Font(UIFont.appRegularFont(16)!)).foregroundColor(Color(UIColor.contactCellTitle))
                Text(ContactHelper.titleStringFromContact(contact)).font(Font(UIFont.appRegularFont(12)!)).foregroundColor(Color(UIColor.secondaryLabelText))
            }
            Spacer()
            if contactCellModel.showRefresh() {
                Image(systemName: "arrow.2.circlepath").foregroundColor(Color(UIColor.appBlue))
            }
            if contactCellModel.showCreated() {
                Image(systemName: "plus").foregroundColor(Color(UIColor.appBlue))
            }
        }
        .padding([.all], 10)
    }
}

struct SearchBar: UIViewRepresentable {

    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = "Search"
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar,
                      context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

struct ContactListView: View {
    var listViewModel: ContactListViewModel
    
    @State private var searchQuery: String = ""
    
    init(dataRows: [SObjectData]) {
        self.listViewModel = ContactListViewModel(dataRows: dataRows)
    }
    var body: some View {
        List {
            Section(header: SearchBar(text: self.$searchQuery).listRowInsets(EdgeInsets())) {
                ForEach(listViewModel.contactRows().filter { contact in
                    self.searchQuery.isEmpty ?
                        true :
                        ContactHelper.nameStringFromContact(contact).localizedStandardContains(self.searchQuery)
                }) { contact in
                    NavigationLink(destination: ContactDetailView()) {
                        ContactCell(contact: contact)
                    }
                }
            }
            //.listRowInsets(EdgeInsets())
        }
        
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView(dataRows: [])
        //Text("Test")
    }
}
