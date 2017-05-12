//
//  TeacherPublicClassCollectionViewCell.swift
//  Qatime_Student
//
//  Created by Shin on 2017/3/2.
//  Copyright © 2017年 WWTD. All rights reserved.
//

import UIKit

class TeacherPublicClassCollectionViewCell: UICollectionViewCell {
   
    //属性定义
    
    //课程名
    public var className:UILabel = UILabel()
    //背景图
    public var classImage = UIImageView()
    //年级
    public var grade = UILabel()
    //科目
    public var subjectName = UILabel ()
    //价格
    var priceLabel = UILabel()
    //model
    var model : TutoriumListInfo? {
      
        didSet{
        
            className.text = model?.name
            let url  = NSURL(string: (model?.publicize)!)
            classImage.sd_setImage(with: url as URL!)
            grade.text = model?.grade
            subjectName.text = model?.subject
            
            let price = "¥ +\(model?.price)"
            
            priceLabel.text = price
            
        }
    
    }
    
    //重写初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        //写各种属性方法吧
        self.backgroundColor = UIColor.white
        
        //课程图的布局
        
        contentView.addSubview(classImage)
        
        _ = classImage.sd_layout()
            .topSpaceToView(contentView,0)?
            .leftSpaceToView(contentView,0)?
            .rightSpaceToView(contentView,0)?
            .heightRatioToView(contentView,0.7)
        
        
        //教师姓名
        
        contentView.addSubview(className)
        className.textColor = UIColor.black
        className.text = "课程名称"
        className.textAlignment = .left

        _ = className.sd_layout()
            .leftSpaceToView(contentView,0)?
            .rightSpaceToView(contentView,0)?
            .topSpaceToView(classImage,5)?
            .heightIs(30)
        
        //年级
        
        contentView.addSubview(grade)
        grade.text = "年级"
        grade.textColor = UIColor.gray
        grade.textAlignment = .right
        grade.font = UIFont.systemFont(ofSize: 12)
        
        _ = grade.sd_layout()
            .leftEqualToView(className)?
            .topSpaceToView(className,0)?
            .autoHeightRatio(0)
        grade.setSingleLineAutoResizeWithMaxWidth(80)
        
        
        //科目
        
        contentView.addSubview(subjectName)
        subjectName.text = "科目名称"
        subjectName.textColor = UIColor.gray
        subjectName.textAlignment = .right
        subjectName.font = UIFont.systemFont(ofSize: 12)
        
        _=subjectName.sd_layout()
        .leftSpaceToView(grade,0)?
            .topSpaceToView(className,0)?
            .autoHeightRatio(0)
        subjectName .setSingleLineAutoResizeWithMaxWidth(80)
        
        
        //价格
        
        contentView.addSubview(priceLabel)
        priceLabel.text = "¥0.00"
        priceLabel.textColor = UIColor.red
        priceLabel.textAlignment = .right
        priceLabel.font = UIFont.systemFont(ofSize: 12)
        
        _ = priceLabel.sd_layout()
            .rightSpaceToView(contentView,0)?
            .topEqualToView(grade)?
            .autoHeightRatio(0)
        
        priceLabel.isHidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}
