/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view wrapping a UIPageControl.
*/

import SwiftUI
import UIKit

struct PageControl: UIViewRepresentable {
    var numberOfPages: Int
    @Binding var currentPage: Int

    // 1. 协程： View & UIView 事件交互
    // Context.coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // 2. 初始化
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.addTarget(context.coordinator, // target：
                          action: #selector(Coordinator.updateCurrentPage(sender:)),
                          for: .valueChanged)

        return control
    }

    // 3. 更新
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }

    class Coordinator: NSObject {
        var control: PageControl

        init(_ control: PageControl) {
            self.control = control
        }

        @objc func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}
