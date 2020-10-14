//
//  MemoTableViewCell.swift
//  ComposeMemo
//
//  Created by Shinya  on 2020/10/14.
//  Copyright © 2020 Shinya . All rights reserved.
//

import UIKit

class MemoTableViewCell: UITableViewCell {

    @IBOutlet var memoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func initNib() -> MemoTableViewCell {
        //xibファイルのオブジェクトをインスタンス
        let memoClass: String = String(describing: MemoTableViewCell.self)
        return Bundle.main.loadNibNamed(memoClass, owner: self, options: nil)?.first as! MemoTableViewCell
    }
}
