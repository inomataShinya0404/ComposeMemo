//
//  SongTableViewCell.swift
//  ComposeMemo
//
//  Created by Shinya  on 2020/10/01.
//  Copyright © 2020 Shinya . All rights reserved.
//

import UIKit

protocol SongTableViewCellDelegate {
    func cellTapped()
}

class SongTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var artworkIV: UIImageView!
    
//    var songTableViewCellDelegate: SongTableViewCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func initNib() -> SongTableViewCell {
        //xibファイルのオブジェクトをインスタンス
        let className: String = String(describing: SongTableViewCell.self)
        return Bundle.main.loadNibNamed(className, owner: self, options: nil)?.first as! SongTableViewCell
    }

}
