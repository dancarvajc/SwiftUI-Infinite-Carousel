//
//  File.swift
//  
//
//  Created by Daniel Carvajal on 22-10-22.
//

import Foundation
import SwiftUI

// Monitors the life cycles of view (onWillAppear or onWillDisappear)
private struct ViewLifeCycleHandler: UIViewControllerRepresentable {

    let onWillDisappear: () -> Void
    let onWillAppear: () -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        ViewLifeCycleViewController(onWillDisappear: onWillDisappear, onWillAppear: onWillAppear)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

private class ViewLifeCycleViewController: UIViewController {
    let onWillDisappear: () -> Void
    let onWillAppear: () -> Void
    
    init(onWillDisappear: @escaping () -> Void, onWillAppear: @escaping () -> Void) {
        self.onWillDisappear = onWillDisappear
        self.onWillAppear = onWillAppear
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onWillDisappear()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onWillAppear()
    }
}

extension View {
    func onWillDisappear(_ perform: @escaping () -> Void) -> some View {
        background(ViewLifeCycleHandler(onWillDisappear: perform, onWillAppear: {}))
    }
    func onWillAppear(_ perform: @escaping () -> Void) -> some View {
        background(ViewLifeCycleHandler(onWillDisappear: {}, onWillAppear: perform))
    }
}
