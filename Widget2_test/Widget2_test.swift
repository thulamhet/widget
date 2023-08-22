//
//  Widget2_test.swift
//  Widget2_test
//
//  Created by Nguyễn Công Thư on 22/08/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct Widget2_testEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family
    @Environment(\.colorScheme) var colorScheme
    
    @ViewBuilder
    var body: some View {
        switch family {
            case .systemMedium:
                ZStack {
                    if colorScheme == .dark {
                        LinearGradient(gradient: Gradient(colors: [Color(hex: "#062a46"), Color(hex: "#5b1929")]),startPoint: .leading, endPoint: .trailing)
                    } else {
                        Color.white
                    }
                    HStack(spacing: 15) {
                        QRCodeInfoView()
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Tran Cong Quynh Lan")
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hex: colorScheme == .light ? "#062a46" : "#ffffff"))
                                Text("1019991888000")
                                    .font(.system(size: 13))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(hex: colorScheme == .light ? "#8294a2" : "#d9e1e7"))
                                Text("VietinBank CN Ha Thanh")
                                    .font(.system(size: 13))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(hex: colorScheme == .light ? "#8294a2" : "#d9e1e7"))
                            }
                            TableRowView(customFunction: [.transferMoney, .topUp])
                        }
                    }.padding(.all, 15)
                }
            default:
                ZStack {
                    if colorScheme == .dark {
                        LinearGradient(gradient: Gradient(colors: [Color(hex: "#062a46"), Color(hex: "#5b1929")]),startPoint: .leading, endPoint: .trailing)
                    } else {
                        Color.white
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        QRCodeInfoView()
                            .frame(width: 70, height: 70)
                        Text("Tran Cong Quynh Lan")
                            .font(.system(size: 13))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: colorScheme == .light ? "#062a46" : "#ffffff"))
                        Text("1019991888000")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: colorScheme == .light ? "#8294a2" : "#d9e1e7"))
                        Text("VietinBank")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: colorScheme == .light ? "#8294a2" : "#d9e1e7"))
                    }
//                  TableRowView(customFunction: [.transferMoney, .topUp])
                }
        }
    }
}

struct TableRowView: View {
    let customFunction: [CustomFunction]
    var body: some View {
        HStack {
            ForEach(customFunction) { function in
                Link(destination: function.url) {
                    FunctionView(customFunc: function)
                }
            }
        }
    }
}

struct CustomFunction: Identifiable {
    let id = UUID()
    let icon: String
    let funcName: String
    let url: URL

    static let transferMoney = CustomFunction(
        icon: "x",
        funcName: "Chuyển tiền",
        url: URL(string: "vietinbankmobilewidget://Transfer")!)
    static let openSaving = CustomFunction(
        icon: "iconHomeMainSavings",
        funcName: "Gửi tiết kiệm",
        url: URL(string: "vietinbankmobilewidget://Openda")!)
    static let topUp = CustomFunction(
        icon: "x",
        funcName: "Thanh toán",
        url: URL(string: "vietinbankmobilewidget://Billpay000000")!)
    static let buyFlightTicket = CustomFunction(
        icon: "saokethe",
        funcName: "Mua vé máy bay",
        url: URL(string: "vietinbankmobilewidget://Booking_flight")!)

    static let availableFunctions: [CustomFunction] = [.transferMoney, .openSaving, .topUp, .buyFlightTicket]
}


struct Widget2_test: Widget {
    let kind: String = "Widget2_test"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Widget2_testEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Widget2_test_Previews: PreviewProvider {
    static var previews: some View {
        Widget2_testEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


@available(iOS 13.0.0, *)
struct FunctionView: View {
    let customFunc: CustomFunction
    @State private var hexColor: UInt32 = 0xFF0077
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(spacing: 5) {
            Image(customFunc.icon)
                .resizable()
                .frame(width: 16, height: 16)
            Text(customFunc.funcName)
                .font(.system(size: 10))
                .fontWeight(.medium)
                .foregroundColor(Color(hex: colorScheme == .dark ? "ffffff" : "#2183db"))
                .multilineTextAlignment(.center)
        }
        .padding(10)
        .frame(width: 82, height: 65)
        .background(Color(UIColor.white).opacity(0))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(LinearGradient(gradient: Gradient(colors: [Color(hex: "#3c93d2"), Color(hex: "#de4d76")]),
                                        startPoint: .leading, endPoint: .trailing), lineWidth: 1)
        )
    }
}

@available(iOS 13.0.0, *)
struct QRCodeInfoView: View {
    @State private var text = "dsadasd"
    func getQRCodeDate(text: String) -> Data? {
          guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
          let data = text.data(using: .ascii, allowLossyConversion: false)
          filter.setValue(data, forKey: "inputMessage")
          guard let ciimage = filter.outputImage else { return nil }
          let transform = CGAffineTransform(scaleX: 10, y: 10)
          let scaledCIImage = ciimage.transformed(by: transform)
          let uiimage = UIImage(ciImage: scaledCIImage)
          return uiimage.pngData()!
    }
    
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(data: getQRCodeDate(text: text)!)!)
                .resizable()
        }
    }
}

func getWidgetSize(forFamily family:WidgetFamily) -> CGSize {
    switch family {
    case .systemSmall:
        switch UIScreen.main.bounds.size {
        case CGSize(width: 428, height: 926):   return CGSize(width:170, height: 170)
        case CGSize(width: 414, height: 896):   return CGSize(width:169, height: 169)
        case CGSize(width: 414, height: 736):   return CGSize(width:159, height: 159)
        case CGSize(width: 390, height: 844):   return CGSize(width:158, height: 158)
        case CGSize(width: 375, height: 812):   return CGSize(width:155, height: 155)
        case CGSize(width: 375, height: 667):   return CGSize(width:148, height: 148)
        case CGSize(width: 360, height: 780):   return CGSize(width:155, height: 155)
        case CGSize(width: 320, height: 568):   return CGSize(width:141, height: 141)
        default:                                return CGSize(width:155, height: 155)
        }
    case .systemMedium:
        switch UIScreen.main.bounds.size {
        case CGSize(width: 428, height: 926):   return CGSize(width:364, height: 170)
        case CGSize(width: 414, height: 896):   return CGSize(width:360, height: 169)
        case CGSize(width: 414, height: 736):   return CGSize(width:348, height: 159)
        case CGSize(width: 390, height: 844):   return CGSize(width:338, height: 158)
        case CGSize(width: 375, height: 812):   return CGSize(width:329, height: 155)
        case CGSize(width: 375, height: 667):   return CGSize(width:321, height: 148)
        case CGSize(width: 360, height: 780):   return CGSize(width:329, height: 155)
        case CGSize(width: 320, height: 568):   return CGSize(width:292, height: 141)
        default:                                return CGSize(width:329, height: 155)
        }
    case .systemLarge:
        switch UIScreen.main.bounds.size {
        case CGSize(width: 428, height: 926):   return CGSize(width:364, height: 382)
        case CGSize(width: 414, height: 896):   return CGSize(width:360, height: 379)
        case CGSize(width: 414, height: 736):   return CGSize(width:348, height: 357)
        case CGSize(width: 390, height: 844):   return CGSize(width:338, height: 354)
        case CGSize(width: 375, height: 812):   return CGSize(width:329, height: 345)
        case CGSize(width: 375, height: 667):   return CGSize(width:321, height: 324)
        case CGSize(width: 360, height: 780):   return CGSize(width:329, height: 345)
        case CGSize(width: 320, height: 568):   return CGSize(width:292, height: 311)
        default:                                return CGSize(width:329, height: 345)
        }
        
    default:                                return CGSize(width:329, height: 345)
    }
}

@available(iOS 13.0.0, *)
extension Color {
 init(hex: String) {
     let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
     var int: UInt64 = 0
     Scanner(string: hex).scanHexInt64(&int)
     let a, r, g, b: UInt64
     switch hex.count {
     case 3: // RGB (12-bit)
         (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
     case 6: // RGB (24-bit)
         (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
     case 8: // ARGB (32-bit)
         (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
     default:
         (a, r, g, b) = (1, 1, 1, 0)
     }

     self.init(
         .sRGB,
         red: Double(r) / 255,
         green: Double(g) / 255,
         blue:  Double(b) / 255,
         opacity: Double(a) / 255
     )
 }
}
