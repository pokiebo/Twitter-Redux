//
//  HBMenuProfileCell.swift
//  Twitter
//
//  Created by Sudipta Bhowmik on 10/10/15.
//  Copyright © 2015 Sudipta Bhowmik. All rights reserved.
//

import UIKit

class HBMenuProfileCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var screenName: UILabel!
    
    var _user : User!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var user : User {
        get { return _user }
        set(user) {
            
            self.profileImage.setImageWithURL(user.profileImageUrl)
            self.userName.text = user.name
            self.screenName.text = user.screenname
        
            _user = user
        }
    }


}
