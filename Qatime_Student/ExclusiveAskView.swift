//
//  ExclusiveAskView.swift
//  Qatime_Student
//
//  Created by Shin on 2017/8/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

import UIKit

class ExclusiveAskView: UIView {
    
    var segmentControl = HMSegmentedControl()
    var scrollView =  UIScrollView()
    var allQuestionsList = UITableView()
    var myQuestionsList = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        segmentControl = HMSegmentedControl.segmentControl(withTitles: ["全部","我的"])
        segmentControl.selectionIndicatorLocation = .none
        segmentControl.borderType = HMSegmentedControlBorderType(rawValue: 0)
        self.addSubview(segmentControl)
        segmentControl.sd_layout()
            .topSpaceToView(self, 0)?
            .leftSpaceToView(self, 10)?
            .heightIs(40)?
            .widthIs(100)
        
        scrollView = UIScrollView.init()
        self.addSubview(scrollView)
        scrollView.sd_layout()
            .leftSpaceToView(self,0)?
            .topSpaceToView(segmentControl,0)?
            .bottomSpaceToView(self,0)?
            .rightSpaceToView(self,0)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width:100,height:100)
        
        allQuestionsList = UITableView.init()
        
        allQuestionsList.separatorStyle = .none
        
        scrollView.addSubview(allQuestionsList)
        allQuestionsList.sd_layout()
            .leftSpaceToView(scrollView,0)?
            .topSpaceToView(scrollView,0)?
            .bottomSpaceToView(scrollView,0)?
            .widthRatioToView(scrollView,1.0)
        allQuestionsList.showsHorizontalScrollIndicator = false
        allQuestionsList.showsVerticalScrollIndicator = false
        
        myQuestionsList = UITableView.init()
        
        myQuestionsList.separatorStyle = .none
        scrollView.addSubview(myQuestionsList)
        myQuestionsList.sd_layout()
            .leftSpaceToView(allQuestionsList,0)?
            .topSpaceToView(scrollView,0)?
            .bottomSpaceToView(scrollView,0)?
            .widthRatioToView(allQuestionsList,1.0)
        myQuestionsList.showsHorizontalScrollIndicator = false
        myQuestionsList.showsVerticalScrollIndicator = false
        
        scrollView.setupAutoContentSize(withRightView: myQuestionsList, rightMargin: 0)
        scrollView.setupAutoHeight(withBottomView: allQuestionsList, bottomMargin: 0)
        segmentControl.indexChangeBlock = {(index) -> Void in
            self.scrollViewScrolls(index: index)
        }
        
    }
    
    func scrollViewScrolls(index:NSInteger!) -> Void {
        
        self.scrollView.scrollRectToVisible(CGRect(x:CGFloat(index)*self.scrollView.width_sd,y:0,width:self.scrollView.width_sd,height:self.scrollView.height_sd), animated: true)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
