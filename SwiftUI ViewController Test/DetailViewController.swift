//
//  DetailViewController.swift
//  Question
//
//  Created by Jose Vazquez on 2/16/23.
//

import SwiftUI
import Republished

@MainActor
class DetailViewController: ObservableObject {
    @Republished var sessionModel: SessionModel
    var title: String
    
    init(sessionModel: SessionModel, title: String) {
        _sessionModel = .init(wrappedValue: sessionModel)
        self.title = title
    }
    
    struct ContentView: View {
        @ObservedObject var viewController: DetailViewController
        
        var body: some View {
            VStack {
                Text(viewController.title)
                    .font(.largeTitle)
                Text("permission: \(viewController.sessionModel.token())")
                Button("Log out") {
                    viewController.sessionModel.logOut()
                }
                .padding(.all)
            }
        }
    }
    
    func view() -> ContentView {
        return ContentView(viewController: self)
    }
}


// MARK: - Preview
#if DEBUG

struct DetailViewController_Previews: PreviewProvider {
    static var previews: some View {
        let sessionModel: SessionModel = {
            SessionModel(authentication: Authentication(token: "Granted!"),
                        logoutAction: { print("logout") })
        }()
        
        let detailViewController: DetailViewController = {
            DetailViewController(sessionModel: sessionModel, title: "Title")
        }()
        
        detailViewController.view()
    }
}

#endif
