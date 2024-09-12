//
//  App.swift
//  MobileSyncExplorerSwift
//
//  Created by Brianna Birman on 8/20/24.
//  Copyright © 2024 MobileSyncExplorerSwiftOrganizationName. All rights reserved.
//

import Foundation
import SwiftUI
import SalesforceSDKCore
import MobileSync

struct RadialLayout: SwiftUI.Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {

        let radius = min(bounds.size.width, bounds.size.height) / 2

           // figure out the angle between each subview on our circle
           let angle = Angle.degrees(200 / Double(subviews.count)).radians

           for (index, subview) in subviews.enumerated() {
               // ask this view for its ideal size
               let viewSize = subview.sizeThatFits(.unspecified)

               // calculate the X and Y position so this view lies inside our circle's edge
               let xPos = cos(angle * Double(index) - .pi / 2) * (radius - viewSize.width / 2)
               let yPos = sin(angle * Double(index) - .pi / 2) * (radius - viewSize.height / 2)

               // position this view relative to our centre, using its natural size ("unspecified")
               let point = CGPoint(x: bounds.midX + xPos, y: bounds.midY + yPos)
               subview.place(at: point, anchor: .center, proposal: .unspecified)
        
               
//               subview.offset(point.y)
           }
    }
}

struct ContactListImmersive: View {
//    
//    @ObservedObject var viewModel: ContactListViewModel
//   
//    
//    init(selectedRecord: String? = nil, newContact: Bool = false, searchFocused: Bool = false) {
////        let sObjectManager = SObjectDataManager.sharedInstance(for: UserAccountManager.shared.currentUserAccount!)
////        self.viewModel = ContactListViewModel(sObjectDataManager: sObjectManager, presentNewContact: newContact, selectedRecord: selectedRecord)
//    }
    
    func point(count: Int, index: Int, width: Double, height: Double) -> CGPoint {
        let radius =  height / 2
           // figure out the angle between each subview on our circle
        let angle = Angle.degrees((180 / Double(count)) ).radians

//           for (index, subview) in subviews.enumerated() {
               // ask this view for its ideal size
//               let viewSize = subview.sizeThatFits(.unspecified)
        let viewSize = CGSize(width: 100, height: 100)

               // calculate the X and Y position so this view lies inside our circle's edge
        let xPos = cos(angle * Double(index) - .pi ) * (radius - (viewSize.width / 2.0))
        let yPos = sin(angle * Double(index) - .pi ) * (radius - (viewSize.height / 2.0))

               // position this view relative to our centre, using its natural size ("unspecified")
        let point = CGPoint(x: xPos + radius, y: yPos + radius)
        return point
               
//           }
    }
    
    
    
    
    func circleXY(r: Double, degrees: Double) -> CGPoint {
      // Convert angle to radians
        let theta = (degrees - 180) * .pi / 180;

        return CGPoint(x: r * cos(theta), y: r * sin(theta))
    }
    
    func angle(x: Double, cardWidth: Double, containerWidth: Double) -> Angle {
        let midpoint = containerWidth / 2
        
        
        let distanceFromMidpoint = midpoint - x
        
        let percentage = (distanceFromMidpoint / midpoint) * 45
         return Angle(degrees: percentage)
    }
    
    func offset(x: Double, cardWidth: Double, containerWidth: Double) -> Double {
        
        let side1 = cardWidth/2
        
        let angle = angle(x: x, cardWidth: cardWidth, containerWidth: containerWidth)
        let midpoint = containerWidth / 2
        
        
        let distanceFromMidpoint = midpoint - x
        
        let percentage = (distanceFromMidpoint / midpoint) * 45
        
       // let offset = (side1 * sin(angle.degrees)) / sin(90)
        //let offset = (side1 * sin(angle.degrees)) / (sin(180 - 90 - angle.degrees))
        
        let offset = abs((distanceFromMidpoint / midpoint) * 300)
        
        return offset
    }
    
    var body: some View {
        GeometryReader3D { sv in
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 0) {
                    ForEach(1..<20) { num in
                        VStack {
                            GeometryReader3D { geo in
                                
                                Text("Number \(num)\nminX:\(geo.frame(in: .global).minX)\nmidX: \(geo.frame(in: .global).midX) \n maxX:\(geo.frame(in: .global).maxX) \nsv: \(geo.frame(in: .scrollView).midX)\n size: \(geo.size)\n sv: \(sv.size)")
                                    .font(.largeTitle)
                                    .padding()
                                    .glassBackgroundEffect()
                                    //.background(.red)
                                    
                                    .rotation3DEffect(angle(x: geo.frame(in: .global).midX, cardWidth: 200, containerWidth: sv.size.width), axis: .y)
//                                    .offset(z: 200)
                                    .offset(z: 200 + offset(x: geo.frame(in: .global).midX, cardWidth: 200, containerWidth: sv.size.width))
                                    //.offset(z: 200 + geo.frame(in: .global).midZ - geo.frame(in: .global).minZ )
                                
                                //                                .rotation3DEffect(<#T##angle: Angle##Angle#>, axis: .y)
                                //                                .rotationEffect(/*@START_MENU_TOKEN@*/.zero/*@END_MENU_TOKEN@*/)
                                //                                .rotation3DEffect(
                                //                                    geo.frame(in: .global).midX - geo.frame(in: .global).minX > 0  ? .degrees(-Double(geo.frame(in: .global).minX)) / 8 : .degrees(0),
                                //                                                  axis: (x: 0, y: 1, z: 0))
                                    .frame(width: 200, height: 400)
                            }
                            .frame(width: 300, height: 400)
                        }
                    }
                }
            }
        }
        
//        VStack{
//            Text("hi")
//        }.frame(width: 1000, height: 1000)
//            .perspectiveRotationEffect(Angle(degrees: 50), axis: (x: 0, y: 1, z: 0))
        //               // .background(.black)

        ScrollView(.horizontal, showsIndicators: true) {
//                    RadialLayout {
            ZStack(alignment: .center) {
                ForEach(0..<12, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(hue: Double(index) / 11, saturation: 1, brightness: 1).gradient)
                        .frame(width: 100, height: 100)
                        .rotation3DEffect(Angle(degrees: Double(-20 * (index - 5))) , axis: .y)
                        .position(x: point(count: 10, index: index, width: 1000, height: 1000).x, y: 100 )
                        .offset(z: point(count: 10, index: index, width: 1000, height: 1000).y)
                        
                }
                
            }.scrollTargetLayout()
            .frame(width: 500, height: 1000)
               // .background(.black)
        }
        
        
//        VStack {
//        ForEach(1..<11 ) { i in
//            RoundedRectangle(cornerRadius: 25)
//                .fill(Color(hue: Double(i) / 10, saturation: 1, brightness: 1).gradient)
//                .position(x: point(index: i).x , y: point(index: i).y)
//            
//            //                                        .offset(x: (50 * cos(CGFloat(i)*10.0)))
//            //                .position(x: (100.0 * cos(.pi/10.0 * CGFloat(i))),
//            //                          y: (100.0 * sin(.pi/10.0 * CGFloat(i))))
//                .frame(width: 100, height: 100)
//            
//            //                                .padding3D()
//            //                                .padding(.horizontal)
//            
//            //                                        .frame(depth: Double(i*100))
//            //                                        .offset(z: abs(Double((i-5)*100)))
//            //                                        .offset(z: (100 * sin(CGFloat(i))))
//            
//            
//            //                                        .rotation3DEffect(Angle(degrees: Double((5 - i) * 10)), axis: (x: 0, y: 1, z: 0))
//            //                                        .rotation3DEffect(Angle(degrees:  Double(30)), axis: (x: 0, y: 1, z: 0))
//            
//            
//        }
//        }.frame(width: 1000, height: 1000)
        
        
//        ScrollView(.horizontal) {
//           // 10 / 2 = 5
//            LazyHStack() {
//                
//                ForEach(1..<10 ) { i in
//                                    RoundedRectangle(cornerRadius: 25)
//                                        .fill(Color(hue: Double(i) / 10, saturation: 1, brightness: 1).gradient)
////                                        .offset(x: (50 * cos(CGFloat(i)*10.0)))
//                    
//                                        .frame(width: 100, height: 100)
//                                        .padding3D()
//                                        .padding(.horizontal)
//                                        
////                                        .frame(depth: Double(i*100))
////                                        .offset(z: abs(Double((i-5)*100)))
////                                        .offset(z: (100 * sin(CGFloat(i))))
//                                        
//                    
////                                        .rotation3DEffect(Angle(degrees: Double((5 - i) * 10)), axis: (x: 0, y: 1, z: 0))
////                                        .rotation3DEffect(Angle(degrees:  Double(30)), axis: (x: 0, y: 1, z: 0))
//                    
//                                        
//                                }
////                ForEach(viewModel.sObjectDataManager.contacts) { contact in
////                    VStack {
////                        Text(contact.firstName ?? "")
////                        Text(contact.lastName ?? "")
////                    }.frame(width: 200, height: 400)
////                        .clipShape(.rect(cornerRadius: 20))
////                    
////                }
//            }.scrollTargetLayout()
//                .frame(width: 1000, height: 100)
//            
//        }.scrollTargetBehavior(.paging)
//            .frame(width: 1000, height: 100)
        
        
        
        
        
//            List(viewModel.sObjectDataManager.contacts.filter { contact in
//                    self.searchTerm.isEmpty ? true : self.viewModel.contactMatchesSearchTerm(contact: contact, searchTerm: self.searchTerm)
//                },
//                 selection: $viewModel.selectedRecord) { contact in
//                    ContactCell(contact: contact)
//                        .onDrag { return viewModel.itemProvider(contact: contact) }
//                }
//                 .listStyle(.plain)
//            .searchable(text: $searchTerm)
//            .navigationBarTitle("Contacts")
//            .navigationBarItems(trailing: NavBarButtons(viewModel: viewModel, notificationModel: notificationModel))
//       
       
        
        // TODO
       // if viewModel.alertContent != nil {
       //                    StatusAlert(viewModel: viewModel)
       //                }
    }
}



struct MyImmersiveApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @State private var currentStyle: ImmersionStyle = .full
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @State private var isImmersed = false

    var body: some Scene {
        WindowGroup() {
            let sObjectManager = SObjectDataManager.sharedInstance(for: UserAccountManager.shared.currentUserAccount!)
            ContactListImmersive()
          
                .ornament(attachmentAnchor: .scene(.bottomTrailing)) {
                    Button("Show Solar System") {
                        Task {
                            let result = await openImmersiveSpace(id: "solarSystem")
                            isImmersed = true
                            if case .error = result {
                                print("An error occurred")
                            }
                        }
                    }

                }
//
//
//            // TODO
//            //UIHostingController(rootView: Tabs(sObjectDataManager: sObjectManager))
        }.windowStyle(.volumetric)
            .defaultSize(width: 2, height: 1, depth: 0.25, in: .meters)


        // Display a fully immersive space.
        ImmersiveSpace(id: "solarSystem") {
//            RealityView { content in
//                
//            }
//            
            
          
        }.immersionStyle(selection: $currentStyle, in: .full)
    }
}

