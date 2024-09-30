//
//  NewsNetworkMonitor.swift
//  NewsReaderApp
//
//  Created by sohamp on 30/09/24.
//

import Network
import Combine

class NewsNetworkMonitor: ObservableObject {
    @Published var isConnected: Bool = true
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global(qos: .background)
    
    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}


