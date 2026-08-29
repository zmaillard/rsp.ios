//
//  Router.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/18/26.
//
import SwiftUI


@Observable
@MainActor
final class Router<T: Codable> : Codable {
    var path: [T] = []
    
    func push(_ route: T) {
        path.append(route)
    }
    
    func pop() {
        _ = path.popLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    func setPath(_ newPath: [T]) {
        path = newPath
    }
    
}


 @Observable
 @MainActor
class AppRouter : Codable {
    var browseRouter = Router<BrowseRoute>()
    var mapRouter = Router<MapRoute>()
    var selectedTab: TabIdentifier = .random
    
    func navigateTo(tab: TabIdentifier) {
        self.selectedTab = tab
    }
}
