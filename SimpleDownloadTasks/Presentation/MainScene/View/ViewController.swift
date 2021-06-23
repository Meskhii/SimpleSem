//
//  ViewController.swift
//  SimpleDownloadTasks
//
//  Created by user200328 on 6/23/21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Variables
    var downloadTasks = [DownloadTask]() {
        didSet {
            downloadsTableView.reloadData()
        }
    }
    var completedTasks = [DownloadTask]() {
        didSet {
            completedTableView.reloadData()
        }
    }
    
    var option: SimulationOption!
    
    // MARK: - IBOutlets
    @IBOutlet weak var downloadsTableView: UITableView!
    @IBOutlet weak var completedTableView: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadsTableView.registerNib(class: ProgressCell.self)
        downloadsTableView.dataSource = self
        completedTableView.registerNib(class: ProgressCell.self)
        completedTableView.dataSource = self
        
        option = SimulationOption(jobCount: 10, maxAsyncTasks: 2, isRandomizedTime: true)
    }
    
    // MARK: - Task Starter
    @IBAction func startTasks(_ sender: UIButton) {
        
        downloadTasks = []
        completedTasks = []
        
        sender.isEnabled = false
        
        let dispatchQueue = DispatchQueue(label: "downloadTasks", qos: .userInitiated, attributes: .concurrent)
        let dispatchGroup = DispatchGroup()
        let dispatchSemaphore = DispatchSemaphore(value: 2)
        
        downloadTasks = (1...10).map({ (i) -> DownloadTask in
            let identifier = "\(i)"
            return DownloadTask(identifier: identifier, stateUpdateHandler: { (task) in
                DispatchQueue.main.async { [unowned self] in
                    
                    guard let index = self.downloadTasks.indexOfTaskWith(identifier: identifier) else {
                        return
                    }
                    
                    switch task.state {
                    case .completed:
                        self.downloadTasks.remove(at: index)
                        self.completedTasks.insert(task, at: 0)
                        
                    case .pending, .inProgess:
                        guard let cell = self.downloadsTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ProgressCell else {
                            return
                        }
                        cell.configure(with: task)
                        self.downloadsTableView.beginUpdates()
                        self.downloadsTableView.endUpdates()
                    }
                }
            })
        })
        
        downloadTasks.forEach {
            $0.startTask(queue: dispatchQueue, group: dispatchGroup, semaphore: dispatchSemaphore)
        }
        
        dispatchGroup.notify(queue: .main) { [unowned self] in
            self.presentAlertWith(title: "Info", message: "Tasks Completed")
            sender.isEnabled = true
        }
        
    }
    
    private func presentAlertWith(title: String , message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true)
    }
    
}

// MARK: - UITableView Data Source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === downloadsTableView {
            return downloadTasks.count
        } else if tableView === completedTableView {
            return completedTasks.count
        } else {
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(ProgressCell.self, for: indexPath)
        let task: DownloadTask
        if tableView === downloadsTableView {
            task = downloadTasks[indexPath.row]
        } else if tableView === completedTableView {
            task = completedTasks[indexPath.row]
        } else {
            fatalError()
        }
        cell.configure(with: task)
        return cell
    }
    
    
}
