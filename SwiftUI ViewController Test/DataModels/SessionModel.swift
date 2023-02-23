//
//  SessionModel.swift
//  Question
//
//  Created by Jose Vazquez on 2/17/23.
//

import SwiftUI

class SessionModel: ObservableObject, CustomStringConvertible {
    @Published var authentication: Authentication
    private var logoutAction: (() -> Void)?
    
    let id = UUID()
    var description: String { "SessionModel: \(id.description)" }
    
    init(authentication: Authentication, logoutAction: @escaping () -> Void) {
        self.authentication = authentication
        self.logoutAction = logoutAction
    }
    
    func token() -> String {
        authentication.token
    }
    
    func logOut() {
        logoutAction?()
        objectWillChange.send()
    }
    
    func mockAPIcall() -> [String] {
        ["some", "silly", "response"]
    }
}
