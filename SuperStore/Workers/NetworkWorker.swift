//
//  NetworkWorker.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 19/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import Foundation
import Network

class NetworkWorker {
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    init() {
        startMonitoring()
    }
    
    private func startMonitoring(){
        monitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .satisfied {
                UserSessionWorker.online = true
            } else {
                UserSessionWorker.online = false
            }
        }

        monitor.start(queue: queue)
    }
}
