//
//  RPBrowserWidget.swift
//  RPBrowserWidget
//
//  Created by Zach Maillard on 8/15/26.
//

import WidgetKit
import SwiftUI
import rpbrowser

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ImageEntry {
        let snapshotSign = UIImage(named: "random-sign")!
        let entry = ImageEntry(date: Date(), image: snapshotSign)
        return entry
    }

    func getSnapshot(in context: Context, completion: @escaping (ImageEntry) -> ()) {
        var snapshotSign: UIImage
        
        if context.isPreview && !RandomSignFetcher.cachedDataAvailable {
            snapshotSign = UIImage(named: "random-sign")!
        } else {
            snapshotSign = RandomSignFetcher.cachedSign!
        }
        
        let entry = ImageEntry(date: Date(), image: snapshotSign)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            guard let image = try? await RandomSignFetcher.fetchRandomSign() else {
                return
            }
            
            let entry = ImageEntry(date: Date(), image: image)
            
            let nextUpdate = Calendar.current.date(byAdding: DateComponents(hour: 12), to: Date())!
            
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            
            completion(timeline)
        }
    }

}

struct ImageEntry: TimelineEntry {
    let date: Date
    let image: UIImage
}

struct RPBrowserWidgetEntryView : View {
    var entry: ImageEntry

    var body: some View {
        Image(uiImage: entry.image)
            .resizable()
            .scaledToFill()
            .clipped()
            .containerBackground(for: .widget) {}
    }
}

struct RPBrowserWidget: Widget {
    let kind: String = "RPBrowserWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                RPBrowserWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                RPBrowserWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
        .configurationDisplayName("Random Road Sign")
        .description("Show a random road sign")
    }
}


#Preview(as: .systemSmall) {
    RPBrowserWidget()
} timeline: {
    ImageEntry(date: .now, image: UIImage(named: "random-sign")!)
}

