//
//  EventsRouter.swift
//  
//
//  Created by Bohdan Koshyrets on 10/16/19.
//

import Kitura
import Foundation
import LoggerAPI

struct Event: Codable {
    let timeReceived: Date
    let rawEvent: String
}

var array: [String] = .init()
var database: [Event] = .init()

func initializeEventsRoutes(app: App) {
    
    app.router.get("/handler", handler: getEvents)
    
    app.router.get("/") { request, response, next in
        response.statusCode = .OK
        response.send("Analytics server v 1.1\n\n")
        
        response.send("Events in memory: \(database.count)\n")
        for (index, event) in database.enumerated() {
            response.send("\t \(index+1). time: \(event.timeReceived), event: \(event.rawEvent)")
        }
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
        database.removeAll()
        
        if array.isEmpty {
            response.statusCode = .noContent
            next()
            return
        } else {
            response.statusCode = .internalServerError
            next()
        }
    }
        
    app.router.post("/api/report/hydra_kit") { request, response, next in
        do {
            let payload = try request.readString()
            array.append(payload ?? "\n")
            
            let event = Event(timeReceived: Date(), rawEvent: payload ?? "")
            database.append(event)
            
            response.statusCode = .OK
            response.send(event)
            next()
            
        } catch {
            Log.error("Could not read string from request: "
                + String(describing: error.localizedDescription)
            )
        }
    }
}

private func getEvents(completion: ([Event]?, RequestError?) -> Void) {
    if database.isEmpty {
        return completion(nil, .noContent)
    } else {
        return completion(database, .ok)
    }
}
