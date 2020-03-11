//
//  ContactDetailView.swift
//  MobileSyncExplorerSwift
//
//  Created by Brianna Birman on 3/2/20.
//  Copyright © 2020 MobileSyncExplorerSwiftOrganizationName. All rights reserved.
//

import SwiftUI

struct EditView: View {
    @State var firstName: String = ""
    @State var lastName: String = "Last Name"
    @State var mobilePhone: String = ""
    @State var homePhone: String = ""
    @State var jobTitle: String = ""
    @State var email: String = ""
    @State var department: String = ""
    
    var body: some View {
        Form {
            TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)
            TextField("Mobile Phone", text: $mobilePhone)
            TextField("Home Phone", text: $homePhone)
            TextField("Job Title", text: $jobTitle)
            TextField("Email Address", text: $email)
            TextField("Department", text: $department)
        }
    }
    
}

struct ReadView: View {
    @State var firstName: String = ""
    @State var lastName: String = "Last Name"
    
    var body: some View {
        VStack(alignment: .leading) {
          //  List {
                       VStack(alignment: .leading, spacing: 3) {
                           Text("First Name").font(.subheadline).foregroundColor(.gray)
                           Text(firstName)
                       }
            Divider()
                       VStack(alignment: .leading, spacing: 3) {
                           Text("Last Name").font(.subheadline).foregroundColor(.gray)
                           Text(lastName)
                       }
                    //.listStyle(GroupedListStyle())
            Spacer()
                   Button(action: {
                          //self.action()
                    }, label: {
                          Text("Delete")
                            .frame(width: 350, height: 50, alignment: .center)
                            .background(Color.red)
                            .foregroundColor(.white)
            //                  .overlay(
            //                      RoundedRectangle(cornerRadius: 5)
            //                          .stroke(isDisabled ? Colors.disabledButtonBorder : Colors.buttonBorder, lineWidth: 1)
            //                  )
                      })
            
      //  }
        }
    }
}

struct ContactDetailView: View {
    @Environment(\.editMode) var mode
    @State var firstName: String = ""
    @State var lastName: String = "Last Name"
    @State var mobilePhone: String = ""
    @State var homePhone: String = ""
    @State var jobTitle: String = ""
    @State var email: String = ""
    @State var department: String = ""

    var body: some View {
       // NavigationView {
            VStack {
                EditButton()
                if self.mode?.wrappedValue == .inactive {
                    EditView()
                    //Text("Inactive")

                } else {
                    ReadView()
                    //Text("Active")
                }
                
                
                
                //.navigationBarTitle("Title", displayMode: .inline)
                //.navigationBarItems(trailing: EditButton())
            }

        }

    //}
}

struct ContactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetailView()
    }
}
