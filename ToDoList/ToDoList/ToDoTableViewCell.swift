//
//  ToDoTableViewCell.swift
//  ToDoList
//
//  Created by jun lee on 9/26/17.
//  Copyright © 2017 jun lee. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!

    //@IBOutlet weak var reminderButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
