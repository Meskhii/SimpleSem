//
//  UITableViewCell+Extension.swift
//  SimpleDownloadTasks
//
//  Created by user200328 on 6/23/21.
//

import UIKit

extension UITableViewCell {
    
    static var identifier: String { String(describing: self) }
    
    static var nib: UINib { UINib(nibName: identifier, bundle: Bundle.main) }
}
