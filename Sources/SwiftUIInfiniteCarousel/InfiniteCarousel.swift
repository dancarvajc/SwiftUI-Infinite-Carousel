//
//  InfiniteCarousel.swift
//  
//
//  Created by Daniel Carvajal on 01-08-22.
//

import SwiftUI
import Combine

public struct NewHapiBanner<Content: View, T: Any>: View {
    
    // MARK: Properties
    @State private var timer: Timer.TimerPublisher
    @State private var cancellable: Cancellable?
    @State private var selectedTab: Int = 1
    private let data: [T]
    private let seconds: Double
    private let content: (T) -> Content
    private let showAlternativeBanner: Bool
    private let height: CGFloat
    private let horizontalPadding: CGFloat
    private let cornerRadius: CGFloat
    
    // MARK: Init
    public init(data: [T], secondsDisplayingBanner: Double = 3, height: CGFloat = 150, horizontalPadding: CGFloat = 30, cornerRadius: CGFloat = 10, @ViewBuilder content: @escaping (T) -> Content) {
        // We repeat the first and last element and add them to the data array. So we have something like this: [item 4, item 1, item 2, item 3, item 4, item 1]
        var modifiedData = data
        if let firstElement = data.first, let lastElement = data.last {
            modifiedData.append(firstElement)
            modifiedData.insert(lastElement, at: 0)
            showAlternativeBanner = false
        } else {
            showAlternativeBanner = true
        }
        self._timer = .init(initialValue: Timer.publish(every: secondsDisplayingBanner, on: .main, in: .common))
        self.data = modifiedData
        self.content = content
        self.seconds = secondsDisplayingBanner
        self.height = height
        self.horizontalPadding = horizontalPadding
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        TabView(selection: $selectedTab) {
            /*
             The data passed to ForEach is an array ([T]), but the actually data ForEach procesess is an array of tuples: [(1, data1),(2, data2), ...].
             With this, we have the data and its corresponding index, so we don't have the problem of the same id, because the real index for ForEach is using for identify the items is the index generated with the zip function.
             */
            ForEach(Array(zip(data.indices, data)), id: \.0) { index, item in
                GeometryReader { proxy in
                    let positionMinX = proxy.frame(in: .global).minX
                    let rotation = getRotation(positionMinX)
                    
                    content(item)
                        .cornerRadius(cornerRadius)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .rotation3DEffect(rotation, axis: (x: 0, y: 1, z: 0))
                        .padding(.horizontal, horizontalPadding) //CAMBIAR!!
                        .onChange(of: positionMinX) { offset in
                            // If the user change the position of a banner, the offset is different of 0, so we stop the timer
                            if offset != 0 {
                                stopTimer()
                            }
                            // When the banner returns to its initial position (user drops the banner), start the timer again
                            if offset == 0 {
                                startTimer()
                            }
                        }
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: height)
        .onChange(of: selectedTab) { newValue in
            if showAlternativeBanner {
                guard newValue < data.count else {
                    withAnimation {
                        selectedTab = 0
                    }
                    return
                }
            } else {
                // If the index is the first item (which is the last one, but repeated) we assign the tab to the real item, no the repeated one)
                if newValue == 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        selectedTab = data.count - 2
                    }
                }
                
                // If the index is the last item (which is the first one, but repeated) we assign the tab to the real item, no the repeated one)
                if newValue == data.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        selectedTab = 1
                    }
                }
            }
        }
        .onAppear {
           startTimer()
        }
        .onReceive(timer) { _ in
            withAnimation {
                selectedTab += 1
            }
        }
    }
}

// Helpers functions
extension NewHapiBanner {
    
    private func getRotation(_ positionX: CGFloat) -> Angle {
        return withAnimation(.linear(duration: 5)) {
            .degrees(positionX / -10)
        }
//        return .degrees(positionX / -10)
    }
    
    private func startTimer() {
        guard cancellable == nil else {
            return
        }
        timer = Timer.publish(every: seconds, on: .main, in: .common)
        cancellable = timer.connect()
    }
    
    private func stopTimer() {
        guard cancellable != nil else {
            return
        }
        cancellable?.cancel()
        cancellable = nil
    }
}

struct NewHapiBanner_Previews: PreviewProvider {
    static var previews: some View {
        NewHapiBanner(data: ["Element 1", "Element 2", "Element 3", "Element 4"]) { element in
            Text(element)
                .font(.title.bold())
                .padding()
                .background(Color.green)
        }
    }
}
