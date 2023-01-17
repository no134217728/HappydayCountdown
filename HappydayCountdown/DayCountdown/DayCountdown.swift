//
//  DayCountdown.swift
//  DayCountdown
//
//  Created by Wei Jen Wang on 2022/9/13.
//

import WidgetKit
import SwiftUI
import Intents

class Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct DayCountdownEntryView : View {
    var body: some View {
        VStack {
            Text("\(Utilities.shared.takeStringFromUserDefault(theKey: .todayDate))")
            Text("🥫 \(Utilities.shared.takeStringFromUserDefault(theKey: .toNextMoneyDays))")
            Text("🐱 \(Utilities.shared.takeStringFromUserDefault(theKey: .toNextLongHolidayDays))")
        }.task {
            Utilities.shared.computeAllDayData()
        }
    }
}

@main
struct DayCountdown: Widget {
    let kind: String = "DayCountdown"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { _ in
            DayCountdownEntryView()
        }
        .configurationDisplayName("")
        .description("")
        .supportedFamilies([.systemMedium])
    }
}

//struct DayCountdown_Previews: PreviewProvider {
//    static var previews: some View {
//        DayCountdownEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
