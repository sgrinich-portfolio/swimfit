//
//  WorkoutChoicesTableViewCell.swift
//  Swim
//
//  Created by StephenGrinich on 1/29/17.
//  Copyright © 2017 StephenGrinich. All rights reserved.
//

import UIKit

class WorkoutCollectionTableViewCell: UITableViewCell {

    @IBOutlet var workoutNameLabel: UILabel!
    @IBOutlet var totalDistanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
