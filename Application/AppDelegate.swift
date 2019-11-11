//
//  AppDelegate.swift
//  SourceCodeSyntaxHighlight
//
//  Created by sbarex on 15/10/2019.
//  Copyright © 2019 sbarex. All rights reserved.
//
//
//  This file is part of SourceCodeSyntaxHighlight.
//  SourceCodeSyntaxHighlight is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  SourceCodeSyntaxHighlight is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with SourceCodeSyntaxHighlight. If not, see <http://www.gnu.org/licenses/>.

import Cocoa
import SourceCodeSyntaxHighlightXPCService

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    lazy var connection: NSXPCConnection = {
        let connection = NSXPCConnection(serviceName: "org.sbarex.SourceCodeSyntaxHighlight.XPCService")
        connection.remoteObjectInterface = NSXPCInterface(with: SCSHXPCServiceProtocol.self)
        connection.resume()
        return connection
    }()
    
    lazy var service: SCSHXPCServiceProtocol? = {
        let service = self.connection.synchronousRemoteObjectProxyWithErrorHandler { error in
            print("Received error:", error)
        } as? SCSHXPCServiceProtocol
        
        return service
    }()
    
    private var firstAppear = false
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        firstAppear = true
        
        // Debug constraints.
        // UserDefaults.standard.set(true, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
        // Or put -NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints YES on the launch arguments
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        self.connection.invalidate()
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        if firstAppear && NSApplication.shared.windows.count == 0, let menu = NSApp.menu?.item(at: 0)?.submenu?.item(withTag: 100), let a = menu.action {
            NSApp.sendAction(a, to: menu.target, from: menu)
        }
        firstAppear = false
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}

