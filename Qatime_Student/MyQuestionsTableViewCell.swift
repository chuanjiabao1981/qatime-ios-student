//
//  MyQuestionsTableViewCell.swift
//  Qatime_Student
//
//  Created by Shin on 2017/9/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

import UIKit

class MyQuestionsTableViewCell: QuestionsTableViewCell {

    func myQuestionsModel(question:Questions!) {
        self.model = question;
        self.status.isHidden = true
        self.title.text = question.title
       
        self.infos.text = "相关课程: " + question.course_name
        
        if question.status == "pending" {
             self.asker.text = "提问时间: " + NSString.changeTimeStamp(toDateString: question.created_at)
        }else{
             self.asker.text = "回复时间: " + NSString.changeTimeStamp(toDateString: question.created_at)
        }
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
