/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Tran Mai Nhung
 ID: s3879954
 Created  date: 15/08/2022
 Last modified: 29/08/2022
 Acknowledgement: Canvas, Tom Huynh github
 // https://stackoverflow.com/questions/61424225/macos-swiftui-navigation-for-a-single-view
 */




import SwiftUI

// This file for custom navigation in menu view
struct StackNavigationView<RootContent, SubviewContent>: View where RootContent: View, SubviewContent: View {
    
    @Binding var currentSubviewIndex: Int
    @Binding var showingSubview: Bool
    let subviewByIndex: (Int) -> SubviewContent
    let rootView: () -> RootContent
    
    var body: some View {
        VStack {
            VStack{
                if !showingSubview { // Root view
                    rootView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(AnyTransition.move(edge: .leading)).animation(.default)
                }
                if showingSubview { // Correct subview for current index
                    StackNavigationSubview(isVisible: self.$showingSubview) {
                        self.subviewByIndex(self.currentSubviewIndex)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(AnyTransition.move(edge: .trailing)).animation(.default)
                }
            }
        }
    }
    
    init(currentSubviewIndex: Binding<Int>, showingSubview: Binding<Bool>, @ViewBuilder subviewByIndex: @escaping (Int) -> SubviewContent, @ViewBuilder rootView: @escaping () -> RootContent) {
        self._currentSubviewIndex = currentSubviewIndex
        self._showingSubview = showingSubview
        self.subviewByIndex = subviewByIndex
        self.rootView = rootView
    }
    
    private struct StackNavigationSubview<Content>: View where Content: View {
        
        @Binding var isVisible: Bool
        let contentView: () -> Content
        
        var body: some View {
            VStack {
                // MARK: content view
                contentView() // Main view content
            }
        }
    }
}
