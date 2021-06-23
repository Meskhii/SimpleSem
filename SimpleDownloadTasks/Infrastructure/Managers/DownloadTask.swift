//
//  DownloadTask.swift
//  SimpleDownloadTasks
//
//  Created by user200328 on 6/23/21.
//

import Foundation


class DownloadTask {
    
    let identifier: String
    let stateUpdateHandler: (DownloadTask) -> ()
    var state = TaskState.pending {
        didSet {
            self.stateUpdateHandler(self)
        }
    }
    
    init(identifier: String, stateUpdateHandler: @escaping (DownloadTask) -> ()) {
        self.identifier = identifier
        self.stateUpdateHandler = stateUpdateHandler
    }
    
    func startTask(queue: DispatchQueue, group: DispatchGroup, semaphore: DispatchSemaphore, randomizeTime: Bool = true) {
        queue.async(group: group) { [weak self] in
                    group.enter()
                    semaphore.wait()
                    self?.state = .inProgess
                    self?.startSleep(randomizeTime: randomizeTime)
                    self?.state = .inProgess
                    self?.startSleep(randomizeTime: randomizeTime)
                    self?.state = .inProgess
                    self?.startSleep(randomizeTime: randomizeTime)
                    self?.state = .completed
                    group.leave()
                    semaphore.signal()
                }
    }
    
    private func startSleep(randomizeTime: Bool = true) {
        Thread.sleep(forTimeInterval: randomizeTime ? Double(Int.random(in: 1...3)) : 1.0)
    }
}

enum TaskState {
    
    case pending
    case inProgess
    case completed
    
    var description: String {
        switch self {
        case .pending:
            return "Pending"
            
        case .inProgess:
            return "Downloading"
            
        case .completed:
            return "Completed"
            
        }
    
    }
}

extension Array where Element == DownloadTask {
    
    func downloadTaskWith(identifier: String) -> DownloadTask? {
        return self.first { $0.identifier == identifier }
    }
    
    func indexOfTaskWith(identifier: String) -> Int? {
        return self.firstIndex { $0.identifier == identifier }
    }
}
