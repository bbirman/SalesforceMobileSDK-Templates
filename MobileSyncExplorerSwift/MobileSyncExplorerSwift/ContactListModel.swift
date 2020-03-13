//
//  ContactListModel.swift
//  MobileSyncExplorerSwift
//
//  Created by Brianna Birman on 3/11/20.
//  Copyright © 2020 MobileSyncExplorerSwiftOrganizationName. All rights reserved.
//

import Foundation
import Combine


struct Contact: Hashable, Identifiable, Decodable {
    let id: String
    let name: String
    let industry: String
}

class ContactListModel: ObservableObject {
    @Published var contacts: [Contact] = []
    private var cancellableSet: Set<AnyCancellable> = []
    
    
    
}
