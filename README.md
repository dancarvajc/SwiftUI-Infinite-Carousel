# SwiftUI Infinite Carousel



An infinite caurrsel made for SwiftUI, compatible with iOS 14+. Easy to use and customizable.

https://user-images.githubusercontent.com/71818002/183007353-7f6cce02-1c81-40c8-a3fd-e64c194742fc.mp4

## Features

- Infinite elements
- Custom transitions beetwen pages
- Timer to display a number of seconds per element
- iOS +14 compatibility

## Install

### Swift Package Manager

```
https://github.com/dancarvajc/SwiftUIInfiniteCarousel.git
```

## Example

```swift
let elements: [String] = ["Data 1","Data 2","Data 3","Data 4"]
var body: some View {
    ZStack {
        Color(red: 0/255, green: 67/255, blue: 105/255)
            .ignoresSafeArea()
        InfiniteCarousel(data: elements, height: 300, cornerRadius: 15, transition: .scale) { element in
            Text(element)
                .font(.title.bold())
                .foregroundColor(Color(red: 1/255, green: 148/255, blue: 154/255))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background( Color(red: 229/255, green: 221/255, blue: 200/255))
        }
    }
}
```

