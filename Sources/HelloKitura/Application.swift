//
//  File.swift
//  
//
//  Created by Bohdan Koshyrets on 10/16/19.
//

import Foundation
import Kitura
import LoggerAPI

public class App {
    
    let router = Router()
    
    private func postInit() {
        finalizeRoutes()
    }
      
    private func finalizeRoutes() {
        initializeEventsRoutes(app: self)
        Log.info("Events routes created")

    }
    
    public func run() {
        postInit()
        Kitura.addHTTPServer(onPort: 8083, with: router)
        Kitura.run()

    }

}
