//
//  QuestionInfoView.swift
//  Qatime_Student
//
//  Created by Shin on 2017/8/18.
//  Copyright © 2017年 WWTD. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.size.width

class QuestionInfoView: UIView {
    ///副标题
    var subTitle  = QuestionSubTitle()
    
    ///内容
    var questionContent = UILabel()
    
    ///图片
//    var photosView = UICollectionView()
    
    //音频
//    var recorder = YZPlayerRecorder()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //副标题
        subTitle = QuestionSubTitle.init(frame: CGRect(x:0,y:0,width:self.width_sd,height:100))
        self.addSubview(subTitle)
        subTitle.sd_layout()
        .topSpaceToView(self,0)?
        .leftSpaceToView(self,0)?
        .rightSpaceToView(self,0)?
        .heightIs(100)
        
        //内容
        questionContent = UILabel.init()
        self.addSubview(questionContent)
        questionContent.font = TEXT_FONTSIZE_MIN
        questionContent.textColor = UIColor.black
        questionContent.sd_layout()
        .topSpaceToView(subTitle,20*ScrenScale)?
        .leftSpaceToView(self,10*ScrenScale)?
        .rightSpaceToView(self,10*ScrenScale)?
        .autoHeightRatio(0)
        
//        //图片
//        let layout = UICollectionViewFlowLayout.init()
//        layout.itemSize = CGSize(width:(ScreenWidth-20*ScrenScale-10)*0.5,height:(ScreenWidth-20*ScrenScale-10)*0.5)
//        layout.minimumInteritemSpacing = 10
//        layout.minimumLineSpacing = 10
//        photosView = UICollectionView.init(frame: CGRect(x:0,y:0,width:0,height:0), collectionViewLayout: layout)
//        self.addSubview(photosView)
//        photosView.sd_layout()
//        .topSpaceToView(questionContent,10*ScrenScale)?
//        .leftSpaceToView(self,10*ScrenScale)?
//        .rightSpaceToView(self,10*ScrenScale)?
//        .heightIs((ScreenWidth-20*ScrenScale-10)*0.5*3+20)
//    
//        //录音机
//        recorder = YZPlayerRecorder.init()
//        self.addSubview(recorder.view)
//        recorder.view.sd_layout()
//        .leftSpaceToView(self,10*ScrenScale)?
//        .rightSpaceToView(self,10*ScrenScale)?
//        .topSpaceToView(photosView,10*ScrenScale)?
//        .heightIs(40)
//        
//        ///该隐藏的都隐藏
//        photosView.isHidden = true
//        recorder.view.isHidden = true
        
        self.setupAutoHeight(withBottomView: questionContent, bottomMargin: 20*ScrenScale)
        
    }
    
    func setQuestionMod(model:Questions!) {
        subTitle.title.text = model.title
        subTitle.creat_at.text = "创建时间: " + NSString.changeTimeStamp(toDateString: model.created_at)
        subTitle.name.text = model.user_name
        questionContent.text = model.body
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
