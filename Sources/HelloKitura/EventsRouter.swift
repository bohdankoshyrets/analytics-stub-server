//
//  File.swift
//  
//
//  Created by Bohdan Koshyrets on 10/16/19.
//

import Kitura
import Foundation

func initializeEventsRoutes(app: App) {
    
    app.router.get("/handler", handler: getEvents)
    
    app.router.post("/api/report/hydra_kit") { request, response, next in
        let payload = try request.readString()
        array.append(payload!)
        next()
    }
    
    app.router.get("/events") { request, response, next in
        if array.isEmpty {
            response.statusCode = .noContent
            next()
            return
        }
        
        for event in array {
            response.send(event)
        }
        next()
    }
    
    app.router.delete("/events") { request, response, next in
        array.removeAll()
        if array.isEmpty {
            response.statusCode = .noContent
            next()
            return
        } else {
            response.statusCode = .internalServerError
            next()
        }
    }
    
}

private func getEvents(completion: ([String]?, RequestError?) -> Void) {
    if array.isEmpty {
        return completion(nil, .noContent)
    } else {
        return completion(["response"], .ok)
    }
}
