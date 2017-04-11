//
//  VideoClassListTableViewCell.swift
//  Qatime_Student
//
//  Created by Shin on 2017/4/11.
//  Copyright © 2017年 WWTD. All rights reserved.
//

import UIKit

class VideoClassListTableViewCell: UITableViewCell {
    
    /// 菱形
    var tips:UIImageView
    
    /// 课程名
    var className:UILabel
    
    
    /// 视频时长
    var duringTime:UILabel
    
    override convenience init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViews()
     
    }
    
    func setupViews() {
        ///菱形
        self.tips = UIImageView.init(image: UIImage.init(named: "back_arow"))
        self.contentView.addSubview(self.tips)
        
        ///课程名
        self.className = UILabel.init()
        self.contentView.addSubview(self.className)
        self.className.font = UIFont.systemFont(ofSize: 18*(UIScreen.main.bounds.size.width/414))
        self.className.textColor = UIColor.black
        ///视频时长
        self.duringTime = UILabel.init()
        self.contentView.addSubview(self.duringTime)
        self.duringTime.font = UIFont.systemFont(ofSize: 13*(UIScreen.main.bounds.size.width/414))
        self.duringTime.textColor = UIColor.init(colorLiteralRed: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        
        ///布局
        self.className.sd_layout()
        .leftSpaceToView(self.contentView,30)?
        .topSpaceToView(self.contentView,10)?
        .rightSpaceToView(self.contentView,10)?
        .autoHeightRatio(0)
        
        self.tips.sd_layout()
        .widthIs(10)?
        .heightIs(10)?
        .centerYEqualToView(self.className)?
        .leftSpaceToView(self.contentView,10)
        
        self.duringTime.sd_layout()
        .topSpaceToView(self.className,10)?
        .leftEqualToView(self.className)?
        
        
        
        
        
        
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
