//
//  Immsersive.swift
//  MobileSyncExplorerSwift
//
//  Created by Brianna Birman on 8/22/24.
//  Copyright © 2024 MobileSyncExplorerSwiftOrganizationName. All rights reserved.
//

import Foundation
import SwiftUI
import SalesforceSDKCore
import RealityKit

//#if os(visionOS)
//#if os(visionOS)#if

struct WhiteBorder: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .foregroundStyle(.black)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill()
            )
    }
}

struct ToolbarLeadingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20)
            )
    }
}


struct ToolbarTrailingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                UnevenRoundedRectangle(bottomTrailingRadius: 20, topTrailingRadius: 20)
            )
    }
}

struct ToolbarMiddleButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                Rectangle()
            )
    }
}

struct FilterButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 40)
            )
    }
}


struct Header: View {
    @ObservedObject var viewModel: ContactListViewModel
    @State private var searchTerm: String = ""
    
    var body: some View {
            VStack(alignment: .leading) {
                Text("\(viewModel.sObjectDataManager.contacts.count) Contacts")
                    .font(.title)
                    .foregroundStyle(.black)
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 30) {
                            TextField("", text: $searchTerm, prompt: Text("\(Image(systemName: "magnifyingglass")) Search")
                                .foregroundStyle(.black))
                            .textFieldStyle(WhiteBorder())
                            .frame(maxWidth: 300)
                            
                            
                            
                            HStack(spacing: 0) {
                                
                                Button {
                                    viewModel.newContact = true
                                } label: {
                                    Image(systemName: "plus")
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.gray)
                                    
                                }.buttonStyle(ToolbarLeadingButton())
                                Button {
                                    
                                } label: {
                                    Image(systemName: "bell.fill")
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.gray)
                                    
                                }.buttonStyle(ToolbarMiddleButton())
                                Button {
                                    
                                } label: {
                                    Image(systemName: "xmark")
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.gray)
                                    
                                }.buttonStyle(ToolbarTrailingButton())
                            }
                        }
                        
                        
                        
                        
                        HStack {
                            Button {
                                
                            } label: {
                                Text("All")
                                    .foregroundColor(.black)
                                    .fontWeight(.light)
                                
                            }.buttonStyle(FilterButton())
                            
                            Button {
                                
                            } label: {
                                Text("Recently Viewed")
                                    .foregroundColor(.black)
                            }
                            .buttonStyle(FilterButton())
                        }
                    }.fontWeight(.light)
                }
            }
    }
}


struct ContactList3D: View {
    @State private var searchTerm: String = ""
    @ObservedObject var viewModel: ContactListViewModel

    init(sObjectManager: SObjectDataManager, selectedRecord: String? = nil, newContact: Bool = false, searchFocused: Bool = false) {
        self.viewModel = ContactListViewModel(sObjectDataManager: sObjectManager, presentNewContact: newContact, selectedRecord: selectedRecord)
    }
    
    func angle(x: Double, containerWidth: Double) -> Angle {
        let midpoint = containerWidth / 2
        let distanceFromMidpoint = midpoint - x
        let percentage = (distanceFromMidpoint / midpoint) * 45
        return Angle(degrees: percentage)
    }
    
    func offset(x: Double, containerWidth: Double) -> Double {
        let midpoint = containerWidth / 2
        let distanceFromMidpoint = midpoint - x
        let offset = abs((distanceFromMidpoint / midpoint) * 300)
        return offset
    }
    var body: some View {
        VStack(alignment: .center) {
            Header(viewModel: viewModel)
                .offset(z: 200)
            
            GeometryReader3D { sv in
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(viewModel.sObjectDataManager.contacts) { contact in
                            VStack {
                                GeometryReader3D { geo in
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Circle()
                                                .fill(Color(ContactHelper.colorFromContact(lastName: contact.lastName)))
                                                .frame(width: 80, height: 80)
                                                .overlay(
                                                    Text(ContactHelper.initialsStringFromContact(firstName: contact.firstName, lastName: contact.lastName))
                                                        .foregroundColor(.white)
                                                ).font(.largeTitle)
                                            
                                            
                                            VStack(alignment: .leading) {
                                                Text(contact.firstName ?? "")
                                                    .font(.largeTitle)
                                                Text(contact.lastName ?? "")
                                                    .font(.largeTitle)
                                            }
                                            .padding()
                                            //                                       / .frame(width: geo.size.width - 100, alignment: .leading)
                                        }
                                        .padding()
                                        //
                                        VStack(alignment: .leading) {
                                            Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 15) {
                                                
                                                if let contactTitle = contact.title {
                                                    GridRow() {
                                                        Image(systemName: "person.text.rectangle.fill")
                                                        Text(contactTitle)
                                                            .fontWeight(.regular)
                                                        
                                                    }
                                                }
                                                if let mobilePhone = contact.mobilePhone {
                                                    GridRow() {
                                                        Image(systemName: "phone.fill")
                                                        Text(mobilePhone)
                                                            .fontWeight(.regular)
                                                    }
                                                }
                                                
                                                if let homePhone = contact.homePhone {
                                                    GridRow {
                                                        Image(systemName: "house.fill")
                                                        Text(homePhone)
                                                            .fontWeight(.regular)
                                                    }
                                                }
                                                
                                                if let email = contact.email {
                                                    GridRow {
                                                        Image(systemName: "envelope.fill")
                                                        Text(email)
                                                            .fontWeight(.regular)
                                                    }
                                                }
                                                if let department = contact.department {
                                                    GridRow {
                                                        Image(systemName: "building.2.fill")
                                                        Text(department)
                                                            .fontWeight(.regular)
                                                    }
                                                }
                                            }.font(.title)
                                            
                                        }.padding()
                                        
                                        
                                        Spacer()
                                        
                                        HStack {
                                            Spacer()
                                            ContactButton(value: contact.mobilePhone, urlScheme: "facetime", imageName: "video.fill")
                                            Spacer()
                                            ContactButton(value: contact.email, urlScheme: "mailto", imageName: "envelope.fill")
                                            Spacer()
                                            ContactButton(value: contact.mobilePhone, urlScheme: "sms", imageName: "message.fill")
                                            Spacer()
                                        }.padding()
                                        //
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding()
                                    .glassBackgroundEffect()
                                    .rotation3DEffect(angle(x: geo.frame(in: .global).center.x, containerWidth: sv.size.width), axis: .y)
                                    .offset(z: offset(x: geo.frame(in: .global).center.x, containerWidth: sv.size.width))
                                    // .frame(minWidth: 400, minHeight: 500) // TODO
                                    
                                }
                                
                            }
                            .padding()
                            .frame(minWidth: 450, maxHeight: 600)
                        }
                    }
                    
                    
                    //                .ornament(visibility: .visible, attachmentAnchor: .scene(.top)) {
                    //
                    //
                    //                }
                }
                .searchable(text: $searchTerm)
                
            }
        }.frame(minWidth: 1800)
    }
}
//#endif

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
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

@main
struct ContactsApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @State private var isImmersed = false
    
//#if os(visionOS)
    @State private var currentStyle: ImmersionStyle = .mixed
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openWindow) private var openWindow
//    #endif

//    init() {
//        MobileSyncSDKManager.initializeSDK()
//    }
//#if os(visionOS)
    func createImmersivePicture(imageName : String) -> Entity {
           // 2.
           let modelEntity = Entity()
           // 3.
           let texture = try? TextureResource.load(named: "mascots")
           // 4.
           var material = UnlitMaterial()
        
//        material.color =
           // 5.
           // material.color = .init(texture: .init(texture!))
        
        
        
        material.color = PhysicallyBasedMaterial.BaseColor(tint: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
           // 6.
           modelEntity.components.set(ModelComponent(mesh: .generateSphere(radius: 1E3), materials: [material]))
           // 7.
           modelEntity.scale = .init(x: -1, y: 1, z: 1)
           modelEntity.transform.translation += SIMD3<Float>(0.0, 1.0, 0.0)
           // 8.
           return modelEntity
       }
    
    
    
//    #endif
    var body: some SwiftUI.Scene {
        @Environment(\.scenePhase) var scenePhase
        WindowGroup(id: "2D") {
            
            if let userAccount = UserAccountManager.shared.currentUserAccount {
                let sObjectManager = SObjectDataManager.sharedInstance(for: userAccount)

                if !isImmersed {
//                    Tabs(sObjectDataManager: sObjectManager)
                    ContactListView(sObjectManager: sObjectManager)
    //#if os(visionOS)
                        .ornament(attachmentAnchor: .scene(.bottomTrailing)) {
                            Button("Immerse") {
                                
                                Task {
                                    
                                    let result = await openImmersiveSpace(id: "immersive")
                                    //dismissWindow(id: "2D")
                                    // openWindow(id: "3D")
                                    isImmersed = true
                                    
                                    if case .error = result {
                                        print("An error occurred")
                                    }
                                }
                            }
                        }//.glassBackgroundEffect()
    //                #endif
                } else {
    //#if os(visionOS)
                    ContactList3D(sObjectManager: sObjectManager)
    //                #endif
                }
            }
            
        }
    
//        .onChange(of: scenePhase) { v1, newPhase in
//            if newPhase == .active {
//                AuthHelper.loginIfRequired() {
//                    if let userAccount = UserAccountManager.shared.currentUserAccount {
//                        let sObjectManager = SObjectDataManager.sharedInstance(for: userAccount)
//                        
//                        if !isImmersed {
//                            Tabs(sObjectDataManager: sObjectManager)
//                        }
//                    }
//                }
//            }
//        }
           
        
        .defaultSize(width: 1600, height: 800)
//#if os(visionOS)
        .windowStyle(.plain)
           // .windowResizability(.contentSize)
//        #endif
           // .defaultSize(width: <#T##CGFloat#>, height: <#T##CGFloat#>, depth: <#T##CGFloat#>)
        WindowGroup(id: "detail") {
            if let userAccount = UserAccountManager.shared.currentUserAccount {
                let sObjectManager = SObjectDataManager.sharedInstance(for: userAccount)
                NavigationStack {
                    //ContactDetailView(localId: <#T##ContactSObjectData.ID?#>, sObjectDataManager: <#T##SObjectDataManager#>)
                    ContactDetailView(sObjectDataManager: sObjectManager)
                }
                    
            }
            
        }
        .handlesExternalEvents(matching: [openDetailActivityType, openDetailPath])
        
//        WindowGroup(id: "3D") {
//           
////            RealityView {
//                ContactList3D()
//                    .toolbar(.visible, for: .navigationBar)
//                    .toolbar(content: {
//                        Text("Hi")
//                    })
//                //            }
//            
//           
//                .ornament(visibility: .visible, attachmentAnchor: .scene(.top)) {
//                    Text("Ornament group").offset(z: 100)
//                }
//            
//        }
//
//        .windowResizability(.contentSize)
        
//#if os(visionOS)
           
        // Display a fully immersive space.
        ImmersiveSpace(id: "immersive") {
//            RealityView { content in
//                content.add(createImmersivePicture(imageName : "mascots"))
//                
//            }
          
        }.immersionStyle(selection: $currentStyle, in: .mixed)
//        #endif
    
    }
}


//#if os(visionOS)

#Preview {
    let credentials = OAuthCredentials(identifier: "test", clientId: "", encrypted: false)!
    let userAccount = UserAccount(credentials: credentials)
    let sObjectManager = SObjectDataManager.sharedInstance(for: userAccount)
    
    return ContactList3D(sObjectManager: sObjectManager)
}
//#endif
