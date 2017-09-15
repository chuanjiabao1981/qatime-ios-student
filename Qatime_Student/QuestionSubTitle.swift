//
//  QuestionSubTitle.swift
//  Qatime_Student
//
//  Created by Shin on 2017/8/18.
//  Copyright © 2017年 WWTD. All rights reserved.
//

import UIKit

let TITLEFONTSIZE = UIFont.systemFont(ofSize: 18*ScreenScale)

class QuestionSubTitle: UIView {
    
    /// 标题
    var title = UILabel()
    
    ///添加时间
    var creat_at = UILabel()
    
    ///姓名
    var name = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        //标题
        title = UILabel.init()
        self.addSubview(title)
        title.font = TITLEFONTSIZE
        title.textColor = UIColor.black
        title.sd_layout()
            .leftSpaceToView(self,10*ScrenScale)?
            .topSpaceToView(self,10*ScrenScale)?
            .rightSpaceToView(self,10*ScrenScale)?
            .autoHeightRatio(0)
        
        //添加时间和姓名
        creat_at = UILabel.init()
        self.addSubview(creat_at)
        creat_at.font = TEXT_FONTSIZE_MIN
        creat_at.textColor = TITLECOLOR
        creat_at.sd_layout()
            .leftEqualToView(title)?
            .topSpaceToView(title,10*ScrenScale)?
            .autoHeightRatio(0)
        creat_at.setSingleLineAutoResizeWithMaxWidth(5000)
        
        name = UILabel.init()
        self.addSubview(name)
        name.font = TEXT_FONTSIZE_MIN
        name.textColor = TITLECOLOR
        name.sd_layout()
            .rightSpaceToView(self,10*ScrenScale)?
            .topEqualToView(creat_at)?
            .autoHeightRatio(0)
        name.setSingleLineAutoResizeWithMaxWidth(500)
        
        name.updateLayout()
        self.setupAutoHeight(withBottomView: creat_at, bottomMargin: 10*ScrenScale)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

