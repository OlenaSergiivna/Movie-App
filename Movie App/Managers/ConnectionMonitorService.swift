//
//  File.swift
//  Movie App
//
//  Created by user on 17.10.2022.
//

import Foundation
import Network

final class ConnectionMonitor {
    
    static let shared = ConnectionMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    
    public private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellural
        case ethernet
        case unknown
    }
    private init() {
        monitor = NWPathMonitor()
    }
    
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            
            self?.getConnectinType(path: path)
        
        }
    }
    
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    
    private func getConnectinType(path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellural
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
        
    }
    
    
    //        monitor.pathUpdateHandler = { path in
    //            DispatchQueue.main.async {
    //                switch path.status {
    //                case .satisfied:
    //                    print("Intenet connected")
    //
    //                case .unsatisfied:
    //                    print("No Intenet")
    //
    //                case .requiresConnection:
    //                    print("May be activated")
    //
    //                @unknown default:  fatalError()
    //
    //                }
    //            }
    //        }
    //    }
}
