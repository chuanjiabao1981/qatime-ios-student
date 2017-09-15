//
//  HomeworkManage.h
//  Qatime_Teacher
//
//  Created by Shin on 2017/9/11.
//  Copyright © 2017年 Shin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Homework.h"

@interface HomeworkManage : Homework

@property (nonatomic, strong) NSDictionary *correction ;
@property (nonatomic, strong) Homework *homework ;


//{
//    "id": 6,
//    "title": "hello",
//    "parent_id": 4,
//    "status": "pending",
//    "user_id": 2892,
//    "user_name": "信雅壮",
//    "created_at": 1505114803,
//    "items": [],
//    "model_name": "LiveStudio::StudentHomework",
//    "correction": null,
//    "homework": {
//        "id": 4,
//        "title": "hello",
//        "parent_id": null,
//        "status": null,
//        "user_id": 3102,
//        "user_name": "信",
//        "created_at": 1505114803,
//        "items": [
//                  {
//                      "id": 4,
//                      "body": "第一题",
//                      "parent_id": null
//                  },
//                  {
//                      "id": 5,
//                      "body": "第二题",
//                      "parent_id": null
//                  },
//                  {
//                      "id": 6,
//                      "body": "第三题",
//                      "parent_id": null
//                  },
//                  {
//                      "id": 23,
//                      "body": "第1题",
//                      "parent_id": null
//                  },
//                  {
//                      "id": 24,
//                      "body": "第2题",
//                      "parent_id": null
//                  },
//                  {
//                      "id": 25,
//                      "body": "第3题",
//                      "parent_id": null
//                  }
//                  ],
//        "model_name": "LiveStudio::Homework"
//    }
//}
@end
