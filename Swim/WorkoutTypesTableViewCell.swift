//
//  WorkoutTypesTableViewCell.swift
//  Swim
//
//  Created by StephenGrinich on 4/1/17.
//  Copyright © 2017 StephenGrinich. All rights reserved.
//

import UIKit

class WorkoutTypesTableViewCell: UITableViewCell {
    @IBOutlet var workoutTypeLabel: UILabel!

    @IBOutlet var workoutTypeDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
