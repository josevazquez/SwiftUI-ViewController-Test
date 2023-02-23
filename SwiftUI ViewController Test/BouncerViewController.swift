//
//  BouncerViewController.swift
//  Question
//
//  Created by Jose Vazquez on 2/10/23.
//

import SwiftUI
import Combine

@MainActor
class BouncerViewController: ObservableObject {
    weak private var appModel: AppModel! = nil
    var cancellable: Cancellable? = nil

    @Published private var homeViewController: HomeViewController? = nil
    
    init(appModel: AppModel) {
        self.appModel = appModel
        cancellable = appModel.objectWillChange.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.onAppModelChange()
            }
        }
    }
    
    func onAppModelChange() {
        switch appModel.appState {
        case .loginRequired:
            homeViewController = nil
        case .authenticated(let sessionModel):
            homeViewController = HomeViewController(sessionModel: sessionModel)
        }
    }

    struct ContentView: View {
        @ObservedObject var viewController: BouncerViewController
        
        var body: some View {
            if let homeViewController = viewController.homeViewController {
                homeViewController.view()
            } else {
                VStack {
                    Text("loginRequired v2")
                    Button("Fake Login") {
                        viewController.appModel.authenticate()
                    }
                    .padding(.all)
                }
            }
        }
    }
    
    func view() -> ContentView {
        return ContentView(viewController: self)
    }
}


// MARK: - Preview
#if DEBUG

struct BouncerView_Previews: PreviewProvider {
    static var previews: some View {
        let appModel: AppModel = AppModel()
        let bouncerViewController: BouncerViewController = {
            BouncerViewController(appModel: appModel)
        }()

        bouncerViewController.view()
    }
}

#endif
