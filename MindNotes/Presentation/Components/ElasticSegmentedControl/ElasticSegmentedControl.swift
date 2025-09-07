
//  ElasticCustomSegmentedControl.swift
//  Kavsoft_Learning
//
//  Created by Mateus Martins Pires on 12/03/24.
//

import SwiftUI
import SwiftData

struct ElasticCustomSegmentedControl<Indicator: View>: View {
    var tabs: [SegmentedTab]
    @Binding var activeTab: SegmentedTab
    var height: CGFloat = 45
    // Customization properties
    // Will display the given enum raw value as a text view
    var displayAsText: Bool = false
    var font: Font = .title3
    var activeTint: Color
    var inActiveTint: Color
    // Indicator View
    @ViewBuilder var indicatorView: (CGSize) -> Indicator
    
    // View Properties
    @State private var excessTabWidth: CGFloat = .zero
    @State private var minX: CGFloat = .zero
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let containerWidthForEachTab = size.width / CGFloat(tabs.count)
            
            HStack(spacing: 0) {
                ForEach(tabs, id: \.rawValue) { tab in
                    Group {
                        if displayAsText {
                            Text(tab.rawValue)
                        } else {
                            Image(systemName: tab.rawValue)
                        }
                    }
                    .font(font)
                    // Change the foregroundColor when select a specific tab
                    .foregroundStyle(activeTab == tab ? activeTint : inActiveTint)
                    .animation(.snappy, value: activeTab)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.rect)
                    .onTapGesture {
                        /*
                         tabs.firstIndex(of: tab): Isso retorna o índice da aba atual (tab) dentro do array tabs. Se a aba atual não estiver presente no array, esse valor será nil.
                         tabs.firstIndex(of: activeTab): Isso retorna o índice da aba selecionada (activeTab) dentro do array tabs. Se a aba selecionada não estiver presente no array, esse valor será nil.
                         */
                        if let index = tabs.firstIndex(of: tab), let activeIndex = tabs.firstIndex(of: activeTab) {
                            // Updating this value
                            activeTab = tab

                            withAnimation(.snappy(duration: 0.25, extraBounce: 0), completionCriteria: .logicallyComplete) {
                                    // Calculating the excessTabWidth
                                    excessTabWidth = containerWidthForEachTab * CGFloat(index - activeIndex)
                                print(excessTabWidth)
                            } completion: {
                                withAnimation(.snappy(duration: 0.25, extraBounce: 0), {
                                    minX = containerWidthForEachTab * CGFloat(index)
                                    excessTabWidth = 0
                                })
                            }
                           
                        }
                    }
                    .background(alignment: .leading) {
                        if tabs.first == tab {
                            GeometryReader {
                                let size = $0.size
                                
                                indicatorView(size)
                                    //👇🏼 These two frames makes the stretching effect
                                    .frame(width: size.width + (excessTabWidth < 0 ? -excessTabWidth : excessTabWidth), height: size.height)
                                    .frame(width: size.width, alignment: excessTabWidth < 0 ? .trailing : .leading)
                                    //👇🏼 This piece that moves the segment to the selected tab
                                    .offset(x: minX)
                            }
                        }
                    }
                }
            }
            .preference(key: SizeKey.self, value: size)
            .onPreferenceChange(SizeKey.self, perform: { value in
                if let index = tabs.firstIndex(of: activeTab) {
                    minX = containerWidthForEachTab * CGFloat(index)
                    excessTabWidth = 0
                }
            })
        }
        .frame(height: height)
    }
}

// This handle when the device orientation changes
fileprivate struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

// MARK: - Preview
#Preview {
    
    let sharedModelContainer: ModelContainer = {
        let schema = Schema(versionedSchema: SchemaV1.self)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    ThoughtsContentView()
        .modelContainer(sharedModelContainer)
        .environmentObject(JourneyService(context: sharedModelContainer.mainContext))
        .environmentObject(ThoughtService(context: sharedModelContainer.mainContext))
}
