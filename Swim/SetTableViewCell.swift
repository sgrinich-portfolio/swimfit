//
//  SetTableViewCell
//  Swim
//
//  Created by StephenGrinich on 1/29/17.
//  Copyright © 2017 StephenGrinich. All rights reserved.
//

import UIKit

class SetTableViewCell: CardTableViewCell {
    
    var set: SwimSet!;

    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var distanceUnitStrokeLabel: UILabel!
    @IBOutlet var intervalLabel: UILabel!
    @IBOutlet var noteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
