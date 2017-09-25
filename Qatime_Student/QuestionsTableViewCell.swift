//
//  QuestionsTableViewCell.swift
//  Qatime_Student
//
//  Created by Shin on 2017/8/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

import UIKit

let ScreenScale = UIScreen.main.bounds.width/414.0
let TEXT_FONTSIZE = UIFont.systemFont(ofSize: 16*ScreenScale)
let TEXT_FONTSIZE_MIN = UIFont.systemFont(ofSize: 14*ScreenScale)
let TITLECOLOR = UIColor.init(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)

class QuestionsTableViewCell: UITableViewCell {

    //外框
    var content = UIView()
    //标题
    var title = UILabel()
    //提问人
    var asker = UILabel()
    //其他信息
    var infos = UILabel()
    //状态
    var status = UILabel()
    
    var model = Questions()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        content = UIView.init()
        self.contentView.addSubview(content)
        content.layer.borderColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        content.layer.borderWidth = 0.5
        content.sd_layout()
        .leftSpaceToView(self.contentView,10*ScrenScale)?
        .rightSpaceToView(self.contentView,10*ScrenScale)?
        .topSpaceToView(self.contentView,10*ScrenScale)?
        .bottomSpaceToView(self.contentView,10*ScrenScale)
        
        //标题
        title = UILabel.init()
        content.addSubview(title)
        title.textColor = UIColor.black
        title.font = TEXT_FONTSIZE
        title.sd_layout()
        .leftSpaceToView(content,10*ScreenScale)?
        .topSpaceToView(content,10*ScrenScale)?
        .rightSpaceToView(content,10*ScrenScale)?
        .autoHeightRatio(0)
        title.setMaxNumberOfLinesToShow(1)
        
        asker = UILabel.init()
        content.addSubview(asker)
        asker.textColor = TITLECOLOR
        asker.font = TEXT_FONTSIZE_MIN
        asker.sd_layout()
        .leftEqualToView(title)?
        .centerYEqualToView(content)?
        .autoHeightRatio(0)
        asker.setSingleLineAutoResizeWithMaxWidth(500)
        

        infos = UILabel.init()
        content.addSubview(infos)
        infos.textColor = TITLECOLOR
        infos.font = TEXT_FONTSIZE_MIN
        infos.sd_layout()
            .leftEqualToView(title)?
            .bottomSpaceToView(content,10*ScrenScale)?
            .autoHeightRatio(0)
        infos.setSingleLineAutoResizeWithMaxWidth(2000)
        
        status = UILabel.init()
        content.addSubview(status)
        status.textColor = TITLECOLOR
        status.font = TEXT_FONTSIZE_MIN
        status.sd_layout()
        .rightSpaceToView(content,10*ScrenScale)?
        .bottomEqualToView(infos)?
        .autoHeightRatio(0)
        status.setSingleLineAutoResizeWithMaxWidth(300)
        
    }
    
    public func setModel(question:Questions!) {
        

        model = question;
        
        title.text = question.title
        asker.text = question.user_name
        
        if (question.answer != nil) {
            status.textColor = UIColor.init(hexString: "20ad65")
            status.text = "已回复"
            infos.text = "回复时间: " + NSString.changeTimeStamp(toDateString: question.created_at)
        }else{
            status.textColor = UIColor.red
            status.text = "待回复"
            infos.text = "创建时间: " + NSString.changeTimeStamp(toDateString: question.created_at)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
