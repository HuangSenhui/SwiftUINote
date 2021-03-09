/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a list of landmarks.
*/

import SwiftUI

struct LandmarkList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly = false
    @State private var filter = FilterEnum.all
    @State private var selectedLandMark: Landmark?
    
    enum FilterEnum: String, CaseIterable, Identifiable {
        case all = "All"//"全部"
        case lakes = "Lakes"//"湖泊"
        case rivers = "Rivers"//"河流"
        case mountains = "Mountains"//"山川"
        
        var id: FilterEnum { self }
    }
    

    var filteredLandmarks: [Landmark] {
        // 进行过滤
        modelData.landmarks.filter { landmark in
            // 是否显示标记
            // 是否选择分类
            (!showFavoritesOnly || landmark.isFavorite) &&
                (filter == .all || filter.rawValue == landmark.category.rawValue)
        }
    }
    
    var title: String {
        let title = filter == .all ? "地标" : filter.rawValue
        return showFavoritesOnly ? "喜爱 \(title)" : title
    }
    
    var index: Int? {
        modelData.landmarks.firstIndex(where: { $0.id == selectedLandMark?.id })
    }

    var body: some View {
        NavigationView {
            List(selection: $selectedLandMark) {

                ForEach(filteredLandmarks) { landmark in
                    NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
                        LandmarkRow(landmark: landmark)
                    }
                    .tag(landmark)
                }
            }
            .navigationTitle(title)
            .listStyle(InsetGroupedListStyle())
            .frame(minWidth: 300)   // watch 不支持最小宽度
            .toolbar(content: {
                ToolbarItem {
                    Menu {
                        Picker("类别", selection: $filter) {
                            ForEach(FilterEnum.allCases) { category in
                                Text(category.rawValue)
                                    .tag(category)
                            }
                        }
                        .pickerStyle(InlinePickerStyle())
                        
                        Toggle(isOn: $showFavoritesOnly, label: {
                            Label("最爱", systemImage: "star.fill")
                                .foregroundColor(.orange)
                        })
                    } label: {
                        Label("筛选", systemImage: "slider.horizontal.3")
                    }

                }
            })
            
            Text("地标")
        }
        
//        .focusedValue(\.seletedLandmark, $modelData.landmarks[index ?? 0])
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
            .environmentObject(ModelData())
    }
}
