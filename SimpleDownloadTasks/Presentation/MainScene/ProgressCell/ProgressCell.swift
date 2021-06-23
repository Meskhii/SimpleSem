//
//  DownloadCell.swift
//  SimpleDownloadTasks
//
//  Created by user200328 on 6/23/21.
//

import UIKit

class ProgressCell: UITableViewCell {

    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var taskStateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with task: DownloadTask) {
        taskStateLabel?.text = "\(task.state.description) #\(task.identifier)"
        taskImageView.image = UIImage.randomImage(seed: Int(task.identifier) ?? 0)
    }
    
}

fileprivate extension UIImage {
    static func randomImage(seed: Int) -> UIImage {
        let images = (1...10).map { UIImage(named: "\($0)")! }
        return images[seed % images.count]
    }
}
