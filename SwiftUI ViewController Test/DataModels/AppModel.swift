//
//  AppModel.swift
//  Question
//
//  Created by Jose Vazquez on 2/17/23.
//

import SwiftUI

struct Authentication {
    var token: String
}

enum AppState {
    case loginRequired
    case authenticated(SessionModel)
}

class AppModel: ObservableObject, CustomStringConvertible {
    @Published var appState: AppState = .loginRequired
    @Published var sessionModel: SessionModel? = nil
    
    let id = UUID()
    var description: String { "AppModel: \(id.description)" }
    
    func authenticate() {
        let authentication = Authentication(token: "Granted \(Int.random(in: 1...1000))")
        let sessionModel = SessionModel(authentication: authentication, logoutAction: { self.logOut() })
        self.sessionModel = sessionModel
        appState = .authenticated(sessionModel)
    }
    
    func logOut() {
        appState = .loginRequired
    }
    
}
