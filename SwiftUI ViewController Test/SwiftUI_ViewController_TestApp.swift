//
//  SwiftUI_ViewController_TestApp.swift
//  SwiftUI ViewController Test
//
//  Created by Jose Vazquez on 2/23/23.
//

import SwiftUI

@main
struct SwiftUI_ViewController_TestApp: App {
    @StateObject private var appModel: AppModel
    @StateObject private var bouncerViewController: BouncerViewController

    init() {
        let appModel = AppModel()
        _appModel = .init(wrappedValue: appModel)
        _bouncerViewController = .init(wrappedValue: BouncerViewController(appModel: appModel))
    }
    
    var body: some Scene {
        WindowGroup {
            bouncerViewController.view()
        }
    }
    
}
