//
//  HomeViewController.swift
//  Question
//
//  Created by Jose Vazquez on 2/16/23.
//

import SwiftUI
import Republished
import Combine

@MainActor
class HomeViewController: ObservableObject {
    weak var sessionModel: SessionModel!
    var cancellable: Cancellable? = nil
    @Published var detailViewController: DetailViewController? = nil
    
    
    init(sessionModel: SessionModel) {
        print("created homeViewController with sessionModel: \(sessionModel)")
        self.sessionModel = sessionModel
        self.cancellable = sessionModel.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func detailViewToShow(title: String) -> DetailViewController {
        DetailViewController(sessionModel: sessionModel, title: title)
    }
    
    struct ContentView: View {
        @ObservedObject var viewController: HomeViewController
        
        var body: some View {
            NavigationStack {
                VStack {
                    List {
                        Section {
                            Text("Home View")
                            Text("permission: \(viewController.sessionModel.token())")
                        }
                        Section {
                            ForEach(viewController.sessionModel.mockAPIcall(), id: \.self) {
                                NavigationLink("\($0)", value: $0)
                            }
                        }
                        Section {
                            Button("Log out") {
                                viewController.sessionModel.logOut()
                            }
                        }
                    }
                }
                .navigationDestination(for: String.self, destination: { value in
                    viewController.detailViewToShow(title: value).view()
                })
            }
        }
    }
    
    func view() -> ContentView {
        return ContentView(viewController: self)
    }
}


// MARK: - Preview
#if DEBUG

struct SessionModelHolder: View {
    @StateObject var sessionModel: SessionModel
    @StateObject var homeViewController: HomeViewController
    
    init() {
        let sessionModel = SessionModel(authentication: Authentication(token: "Granted!"),
                                      logoutAction: { print("log out!") })
        _sessionModel = .init(wrappedValue: sessionModel)
        _homeViewController = .init(wrappedValue: HomeViewController(sessionModel: sessionModel))
    }
    
    var body: some View {
        homeViewController.view()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        SessionModelHolder()
    }
}

#endif
