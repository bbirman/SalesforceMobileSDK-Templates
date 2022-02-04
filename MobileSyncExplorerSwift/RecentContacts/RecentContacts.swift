//
//  RecentContacts.swift
//  RecentContacts
//
//  Created by Brianna Birman on 1/21/22.
//  Copyright © 2022 MobileSyncExplorerSwiftOrganizationName. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Helper {
    static func contactListForWidgetSize(_ family: WidgetFamily, contacts: [WidgetContact]) -> [WidgetContact]? {
        switch family {
        case .systemSmall:
            return Array(contacts.prefix(1))
        case .systemMedium:
            return Array(contacts.prefix(3))
        case .systemLarge:
            return Array(contacts.prefix(6))
        case .systemExtraLarge:
            return Array(contacts.prefix(6))
        @unknown default:
             return nil
        }
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
       return SimpleEntry(date: Date(), contacts: [WidgetContact(id: "999", firstName: "placeholder", lastName: "")])
        
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(SimpleEntry(date: Date(), contacts: [WidgetContact(id: "999", firstName: "snapshot", lastName: "")]))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let url = FileManager.default.containerURL(
             forSecurityApplicationGroupIdentifier: "group.com.salesforce.mobilesyncexplorer")!.appendingPathComponent("contents.json")

        let decoder = JSONDecoder()
        guard let codeData = try? Data(contentsOf: url), let contacts = try? decoder.decode([WidgetContact].self, from: codeData) else {
            completion(Timeline(entries: [SimpleEntry(date: Date(), contacts: [WidgetContact(id: "999", firstName: "", lastName: "")])], policy: .atEnd))
            return
        }
        
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 1 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, contacts: Helper.contactListForWidgetSize(context.family, contacts: contacts))
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    var contacts: [WidgetContact]?
}


struct Cell : View {
    let image: Image
    let text: String
    let url: URL
    
    var body: some View {
        
        Link(destination: url) {
            HStack {
                image
                Text(text)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
            }.padding(10)
        }.frame(width: 125, height: 50, alignment: .leading)
        
        .background(Color(uiColor: .systemFill))
        .cornerRadius(20)
    }
}

struct RecentContactsEntryView : View {
    var entry: Provider.Entry
    
    func displayName(for contact: WidgetContact) -> String {
//        if let lastInitial = contact.lastName?.first {
//            return "\(contact.firstName ?? "") \(lastInitial)."
//        }
        return "\(contact.firstName ?? "")"
    }
    
    func backgroundColor() {
        
    }

    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: 125, maximum: 140), spacing: 5, alignment: .center)
        ]

        VStack {
            Link(destination: URL(string: "mobilesyncexplorerswift://search")!) {
                Text("Search")
            }
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                if let contacts = entry.contacts {
                    ForEach(contacts, id: \.self) { contact in
                        Cell(image: Image(uiImage:
                                            ContactHelper.initialsImage(
                                                ContactHelper.colorFromContact(lastName: contact.lastName),
                                                initials: ContactHelper.initialsStringFromContact(firstName: contact.firstName, lastName: contact.lastName), alpha: 0.2, diameter: 30.0)!), text: displayName(for: contact), url: URL(string: "mobilesyncexplorerswift://contact/\(contact.id)")!)
                    }
                }
                Cell(image: .init(systemName: "plus.circle"), text: "New", url: URL(string: "mobilesyncexplorerswift://newContact")!) // TODO: show even if contacts are empty
            }
        }
    }
}

@main
struct RecentContacts: Widget {
    let kind: String = "RecentContacts"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RecentContactsEntryView(entry: entry)
        }
        .configurationDisplayName("Recent Contacts")
        .description("This is an example widget.")
    }
}

struct RecentContacts_Previews: PreviewProvider {
    static var previews: some View {
       // SimpleEntry(date: Date(), content: [WidgetContact(id: "999", firstName: "", lastName: "")])
        let contacts =
        [WidgetContact(id: "1", firstName: "Andy", lastName: "Herrera"),
         WidgetContact(id: "2", firstName: "Dean", lastName: "Miller"),
         WidgetContact(id: "3", firstName: "Jack", lastName: "Gibson"),
         WidgetContact(id: "4", firstName: "Travis", lastName: "Montgomery"),
         WidgetContact(id: "5", firstName: "Victoria", lastName: "Hughes"),
         WidgetContact(id: "6", firstName: "Robert", lastName: "Sullivan")
       ]
        
        Group {
            RecentContactsEntryView(entry: SimpleEntry(date: Date(), contacts: Helper.contactListForWidgetSize(.systemMedium, contacts: contacts)))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 mini (15.2)"))

            RecentContactsEntryView(entry: SimpleEntry(date: Date(), contacts: Helper.contactListForWidgetSize(.systemSmall, contacts: contacts)))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 mini (15.2)"))

            RecentContactsEntryView(entry: SimpleEntry(date: Date(), contacts: Helper.contactListForWidgetSize(.systemLarge, contacts: contacts)))
                .previewContext(WidgetPreviewContext(family: .systemLarge))

            if #available(iOS 15.0, *) {
                RecentContactsEntryView(entry: SimpleEntry(date: Date(), contacts: Helper.contactListForWidgetSize(.systemExtraLarge, contacts: contacts)))
                    .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
            }
            
//            RecentContactsEntryView(entry: SimpleEntry(date: Date(), contacts: contacts))
//                .previewContext(WidgetPreviewContext(family: .systemLarge))
//                .previewDevice(PreviewDevice(rawValue: "Mac Catalyst"))
        }
    }
}

