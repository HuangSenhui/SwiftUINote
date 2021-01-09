#  SwiftUI Note

# iOS App Dev with SwiftUI Tutorials

## 使用 Stacks 布局 Views
1. `ProgressView`
2. `.strokeBorder(:)`
3. `Label`
4. `.accessibilityElement(:)、.accessibilityLabel(:)、.accessibilityValue(:)`

## 创建 View
1. 创建模型
    1.1 定义数据类型
    1.2 使用扩展，提供Mock数据
    
2. 创建View
    2.1 声明定义普通数据模型，并使用Mock数据
    2.2 添加`accessibilty`可访问性
    
3. 在列表中展示数据
1. `List` 让模型遵循`Identifiable`，使用`UUID`初始化数据

## 导航和数据呈现

1. 导航栏
    1.1 `NavigationView`
    1.2 `NavigationLink` 将`View`添加到导航栈
        1.2.1 `.listRowBackground()`
        1.2.2 `.listStyle(InsetGroupedListStyle())`
2. 详情页
    1. `Section`
    
3. 创建编辑视图
    3.1 定义嵌套数据结构Data，声明需要修改的字段
    3.2 声明`data`计算属性，使用当前对象创建新副本Data实例
    3.3 在视图定义状态模型
    ```swift
    struct EditView: View {
        @State private var scrumData = DailyScrum.Data()
    }
    
    ```
    3.4 `ColorPicker`
    3.5 `.disabled()` 
    3.6 `.fullyScreenCover()` 全屏弹出界面

## 传递数据
1. 使用`@Binding`传递数据
    ```swift
    struct EditView: View {
        @Binding var scrumData: DailyScrum.Data
    }

    ```
2. 在来源View中将数据声明为`@State`
    2.1 点击编辑按钮时,传递数据
    ```swift
    struct DetailView: View {
        let scum: DailyScrum
        @State private data = DailyScrum.Data()
        
        // 通过data副本同步当前数据
        action
            data = scrum.data
        // 返回时，通过副本data同步数据
        completion
            scrum.update(from: data)
    }
    ```
    2.2 使用`@Binding`引用数据源
    2.3 `ForEach` 中，将普通数据转换`Binding`类型
    ```swift
    private func binding(for scrum: DailyScrum) -> Binding<DailyScrum> {
        guard let scrumIndex = scrums.firstIndex(where: { $0.id == scrum.id }) else {
            fatalError("Can't find scrum in array")
        }
        return $scrums[scrumIndex]
    }
    ```

## 管理状态和生命周期
1. 对`MeetingView`进一步分解header、body、footer
2. `.progressViewStyle()` 自定义进度条样式
3. `@StateObject` 包装引用属性，使其声明周期同`View`
4. `@StateObject var scrumTimer = ScrumTimer()` 单一数据源
5. `.onAppear {}、onDisAppear {}` 生命周期回调函数

## AVFoundation
1. `AVPlayer`
    1.1 `player.seek(to: .zero)`


## 更新App数据
1. `.alert()` 在主页弹出编辑界面，作为新增数据功能
2. `Text(Date(),style:.date)` 使用时间格式以本地化字符显示

## 数据持久化
1. `Codable` 
2.  读写数据
    ```swift
    class ScrumData: ObservableObject {
        
        //...
        
        @Published var scrums: [DailyScrum] = []
        
        func load() {
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let data = try? Data(contentsOf: Self.fileURL) else {
                    #if DEBUG
                    DispatchQueue.main.async {
                        self?.scrums = DailyScrum.data
                    }
                    #endif
                    return
                }
                
                guard let dailyscrums = try? JSONDecoder().decode([DailyScrum].self, from: data) else {
                    fatalError("Scrum 数据解码失败")
                }
                DispatchQueue.main.async {
                    self?.scrums = dailyscrums
                }
            }
        }
        func save() {
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let scrums = self?.scrums else { return }
                guard let data = try? JSONEncoder().encode(scrums) else { fatalError("scrum 数据出错")}
                do {
                    let outfile = Self.fileURL
                    try data.write(to: outfile)
                } catch {
                    fatalError("写入文件出错")
                }
            }
        }
    }
    ```
3. 当App window显示时，加载数据
4. 监听环境变量
    ```swift
    @Environment(\.scenePhase) private var scenePhase  
    
    .onChange(of: scenePhase) { phase in 
        // 保存数据
    }
    ```

## 绘制计时器
1. `Shape`
2. `Path` 开始角度、结束角度、每段的角度
3. `.addArc()` 圆心

## 语言转译文字
1. 申请授权：Speech、Microphone
    ```swift
    SFSpeechRecognizer.requestAuthorization {_ in}
    ```
2. `SpeechRecognizer.swift`
    2.1 `Speech` 语音识别
3. 将转录结果保存至历史

##  [Next 进阶](https://developer.apple.com/tutorials/app-dev-training/wrapping-up)
