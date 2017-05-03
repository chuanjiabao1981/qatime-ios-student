//
//  OneOnOneWorkFlowView.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/31.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "OneOnOneWorkFlowView.h"

@implementation OneOnOneWorkFlowView


- (void)drawRect:(CGRect)rect{
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.804 green: 0.996 blue: 0.808 alpha: 1];
    UIColor* color3 = [UIColor colorWithRed: 0.416 green: 0.992 blue: 0.663 alpha: 1];
    UIColor* color5 = [UIColor colorWithRed: 0.953 green: 0.953 blue: 0.953 alpha: 1];
    UIColor* color6 = [UIColor colorWithRed: 0.953 green: 0.953 blue: 0.953 alpha: 1];
    UIColor* color7 = [UIColor colorWithRed: 0.953 green: 0.953 blue: 0.953 alpha: 1];
    
    //// Rectangle Drawing
    CGRect rectangleRect = CGRectMake(20*ScrenScale, 20*ScrenScale, 374*ScrenScale, 30*ScrenScale);
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: rectangleRect byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: CGSizeMake(10*ScrenScale, 10*ScrenScale)];
    [rectanglePath closePath];
    [color setFill];
    [rectanglePath fill];
    {
        NSString* textContent = @"购买课程";
        NSMutableParagraphStyle* rectangleStyle = [NSMutableParagraphStyle new];
        rectangleStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary* rectangleFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 15*ScrenScale], NSForegroundColorAttributeName: UIColor.grayColor, NSParagraphStyleAttributeName: rectangleStyle};
        
        CGFloat rectangleTextHeight = [textContent boundingRectWithSize: CGSizeMake(rectangleRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: rectangleFontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, rectangleRect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(rectangleRect), CGRectGetMinY(rectangleRect) + (CGRectGetHeight(rectangleRect) - rectangleTextHeight) / 2, CGRectGetWidth(rectangleRect), rectangleTextHeight) withAttributes: rectangleFontAttributes];
        CGContextRestoreGState(context);
    }
    
    
    //// Rectangle 2 Drawing
    CGRect rectangle2Rect = CGRectMake(20*ScrenScale, 50*ScrenScale, 374*ScrenScale, 20*ScrenScale);
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRoundedRect: rectangle2Rect byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: CGSizeMake(10*ScrenScale, 10*ScrenScale)];
    [rectangle2Path closePath];
    [color3 setStroke];
    rectangle2Path.lineWidth = 0.5;
    [rectangle2Path stroke];
    {
        NSString* textContent = @"支持退款，放心购买";
        NSMutableParagraphStyle* rectangle2Style = [NSMutableParagraphStyle new];
        rectangle2Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* rectangle2FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue" size: 12*ScrenScale], NSForegroundColorAttributeName: UIColor.lightGrayColor, NSParagraphStyleAttributeName: rectangle2Style};
        
        CGFloat rectangle2TextHeight = [textContent boundingRectWithSize: CGSizeMake(rectangle2Rect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: rectangle2FontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, rectangle2Rect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(rectangle2Rect), CGRectGetMinY(rectangle2Rect) + (CGRectGetHeight(rectangle2Rect) - rectangle2TextHeight) / 2, CGRectGetWidth(rectangle2Rect), rectangle2TextHeight) withAttributes: rectangle2FontAttributes];
        CGContextRestoreGState(context);
    }
    
    
    //// Rectangle 3 Drawing
    CGRect rectangle3Rect = CGRectMake(20*ScrenScale, 100*ScrenScale, 374*ScrenScale, 30*ScrenScale);
    UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRoundedRect: rectangle3Rect byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: CGSizeMake(10*ScrenScale, 10*ScrenScale)];
    [rectangle3Path closePath];
    [color setFill];
    [rectangle3Path fill];
    {
        NSString* textContent = @"准时上课";
        NSMutableParagraphStyle* rectangle3Style = [NSMutableParagraphStyle new];
        rectangle3Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* rectangle3FontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 15*ScrenScale], NSForegroundColorAttributeName: UIColor.grayColor, NSParagraphStyleAttributeName: rectangle3Style};
        
        CGFloat rectangle3TextHeight = [textContent boundingRectWithSize: CGSizeMake(rectangle3Rect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: rectangle3FontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, rectangle3Rect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(rectangle3Rect), CGRectGetMinY(rectangle3Rect) + (CGRectGetHeight(rectangle3Rect) - rectangle3TextHeight) / 2, CGRectGetWidth(rectangle3Rect), rectangle3TextHeight) withAttributes: rectangle3FontAttributes];
        CGContextRestoreGState(context);
    }
    
    
    //// Rectangle 4 Drawing
    CGRect rectangle4Rect = CGRectMake(20*ScrenScale, 130*ScrenScale, 374*ScrenScale, 20*ScrenScale);
    UIBezierPath* rectangle4Path = [UIBezierPath bezierPathWithRoundedRect: rectangle4Rect byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: CGSizeMake(10*ScrenScale, 10*ScrenScale)];
    [rectangle4Path closePath];
    [color3 setStroke];
    rectangle4Path.lineWidth = 0.5*ScrenScale;
    [rectangle4Path stroke];
    {
        NSString* textContent = @"无需预约，按时上课";
        NSMutableParagraphStyle* rectangle4Style = [NSMutableParagraphStyle new];
        rectangle4Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* rectangle4FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue" size: 12*ScrenScale], NSForegroundColorAttributeName: UIColor.lightGrayColor, NSParagraphStyleAttributeName: rectangle4Style};
        
        CGFloat rectangle4TextHeight = [textContent boundingRectWithSize: CGSizeMake(rectangle4Rect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: rectangle4FontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, rectangle4Rect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(rectangle4Rect), CGRectGetMinY(rectangle4Rect) + (CGRectGetHeight(rectangle4Rect) - rectangle4TextHeight) / 2, CGRectGetWidth(rectangle4Rect), rectangle4TextHeight) withAttributes: rectangle4FontAttributes];
        CGContextRestoreGState(context);
    }
    
    
    //// Rectangle 5 Drawing
    CGRect rectangle5Rect = CGRectMake(20*ScrenScale, 180*ScrenScale, 374*ScrenScale, 30*ScrenScale);
    UIBezierPath* rectangle5Path = [UIBezierPath bezierPathWithRoundedRect: rectangle5Rect byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: CGSizeMake(10*ScrenScale, 10*ScrenScale)];
    [rectangle5Path closePath];
    [color setFill];
    [rectangle5Path fill];
    {
        NSString* textContent = @"在线授课";
        NSMutableParagraphStyle* rectangle5Style = [NSMutableParagraphStyle new];
        rectangle5Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* rectangle5FontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 15*ScrenScale], NSForegroundColorAttributeName: UIColor.grayColor, NSParagraphStyleAttributeName: rectangle5Style};
        
        CGFloat rectangle5TextHeight = [textContent boundingRectWithSize: CGSizeMake(rectangle5Rect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: rectangle5FontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, rectangle5Rect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(rectangle5Rect), CGRectGetMinY(rectangle5Rect) + (CGRectGetHeight(rectangle5Rect) - rectangle5TextHeight) / 2, CGRectGetWidth(rectangle5Rect), rectangle5TextHeight) withAttributes: rectangle5FontAttributes];
        CGContextRestoreGState(context);
    }
    
    
    //// Rectangle 6 Drawing
    CGRect rectangle6Rect = CGRectMake(20*ScrenScale, 210*ScrenScale, 374*ScrenScale, 20*ScrenScale);
    UIBezierPath* rectangle6Path = [UIBezierPath bezierPathWithRoundedRect: rectangle6Rect byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: CGSizeMake(10*ScrenScale, 10*ScrenScale)];
    [rectangle6Path closePath];
    [color3 setStroke];
    rectangle6Path.lineWidth = 0.5*ScrenScale;
    [rectangle6Path stroke];
    {
        NSString* textContent = @"视频直播，白板互动";
        NSMutableParagraphStyle* rectangle6Style = [NSMutableParagraphStyle new];
        rectangle6Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* rectangle6FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue" size: 12*ScrenScale], NSForegroundColorAttributeName: UIColor.lightGrayColor, NSParagraphStyleAttributeName: rectangle6Style};
        
        CGFloat rectangle6TextHeight = [textContent boundingRectWithSize: CGSizeMake(rectangle6Rect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: rectangle6FontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, rectangle6Rect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(rectangle6Rect), CGRectGetMinY(rectangle6Rect) + (CGRectGetHeight(rectangle6Rect) - rectangle6TextHeight) / 2, CGRectGetWidth(rectangle6Rect), rectangle6TextHeight) withAttributes: rectangle6FontAttributes];
        CGContextRestoreGState(context);
    }
    
    
    //// Polygon Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 232.5*ScrenScale, 90*ScrenScale);
    CGContextRotateCTM(context, -180 * M_PI / 180);
    
    UIBezierPath* polygonPath = [UIBezierPath bezierPath];
    [polygonPath moveToPoint: CGPointMake(25*ScrenScale, 0*ScrenScale)];
    [polygonPath addLineToPoint: CGPointMake(46.65*ScrenScale, 11.25*ScrenScale)];
    [polygonPath addLineToPoint: CGPointMake(3.35*ScrenScale, 11.25*ScrenScale)];
    [polygonPath closePath];
    [color5 setStroke];
    polygonPath.lineWidth = 1;
    [polygonPath stroke];
    
    CGContextRestoreGState(context);
    
    
    //// Polygon 2 Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 232.5*ScrenScale, 169*ScrenScale);
    CGContextRotateCTM(context, -180 * M_PI / 180);
    
    UIBezierPath* polygon2Path = [UIBezierPath bezierPath];
    [polygon2Path moveToPoint: CGPointMake(25*ScrenScale, 0*ScrenScale)];
    [polygon2Path addLineToPoint: CGPointMake(46.65*ScrenScale, 11.25*ScrenScale)];
    [polygon2Path addLineToPoint: CGPointMake(3.35*ScrenScale, 11.25*ScrenScale)];
    [polygon2Path closePath];
    [color6 setStroke];
    polygon2Path.lineWidth = 1;
    [polygon2Path stroke];
    
    CGContextRestoreGState(context);
    
    
    //// Rectangle 7 Drawing
    CGRect rectangle7Rect = CGRectMake(20*ScrenScale, 260*ScrenScale, 374*ScrenScale, 30*ScrenScale);
    UIBezierPath* rectangle7Path = [UIBezierPath bezierPathWithRoundedRect: rectangle7Rect byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: CGSizeMake(10*ScrenScale, 10*ScrenScale)];
    [rectangle7Path closePath];
    [color setFill];
    [rectangle7Path fill];
    {
        NSString* textContent = @"上课结束";
        NSMutableParagraphStyle* rectangle7Style = [NSMutableParagraphStyle new];
        rectangle7Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* rectangle7FontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 15*ScrenScale], NSForegroundColorAttributeName: UIColor.grayColor, NSParagraphStyleAttributeName: rectangle7Style};
        
        CGFloat rectangle7TextHeight = [textContent boundingRectWithSize: CGSizeMake(rectangle7Rect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: rectangle7FontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, rectangle7Rect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(rectangle7Rect), CGRectGetMinY(rectangle7Rect) + (CGRectGetHeight(rectangle7Rect) - rectangle7TextHeight) / 2, CGRectGetWidth(rectangle7Rect), rectangle7TextHeight) withAttributes: rectangle7FontAttributes];
        CGContextRestoreGState(context);
    }
    
    
    //// Polygon 3 Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 232.5*ScrenScale, 250*ScrenScale);
    CGContextRotateCTM(context, -180 * M_PI / 180);
    
    UIBezierPath* polygon3Path = [UIBezierPath bezierPath];
    [polygon3Path moveToPoint: CGPointMake(25*ScrenScale, 0*ScrenScale)];
    [polygon3Path addLineToPoint: CGPointMake(46.65*ScrenScale, 11.25*ScrenScale)];
    [polygon3Path addLineToPoint: CGPointMake(3.35*ScrenScale, 11.25*ScrenScale)];
    [polygon3Path closePath];
    [color7 setStroke];
    polygon3Path.lineWidth = 1;
    [polygon3Path stroke];
    
    CGContextRestoreGState(context);
    
    
    //// Rectangle 8 Drawing
    CGRect rectangle8Rect = CGRectMake(20*ScrenScale, 290*ScrenScale, 374*ScrenScale, 20*ScrenScale);
    UIBezierPath* rectangle8Path = [UIBezierPath bezierPathWithRoundedRect: rectangle8Rect byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: CGSizeMake(10*ScrenScale, 10*ScrenScale)];
    [rectangle8Path closePath];
    [color3 setStroke];
    rectangle8Path.lineWidth = 0.5*ScrenScale;
    [rectangle8Path stroke];
    {
        NSString* textContent = @"音图并茂，随时解答";
        NSMutableParagraphStyle* rectangle8Style = [NSMutableParagraphStyle new];
        rectangle8Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* rectangle8FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue" size: 12*ScrenScale], NSForegroundColorAttributeName: UIColor.lightGrayColor, NSParagraphStyleAttributeName: rectangle8Style};
        
        CGFloat rectangle8TextHeight = [textContent boundingRectWithSize: CGSizeMake(rectangle8Rect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: rectangle8FontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, rectangle8Rect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(rectangle8Rect), CGRectGetMinY(rectangle8Rect) + (CGRectGetHeight(rectangle8Rect) - rectangle8TextHeight) / 2, CGRectGetWidth(rectangle8Rect), rectangle8TextHeight) withAttributes: rectangle8FontAttributes];
        CGContextRestoreGState(context);
    }

    _line = [[UIView alloc]init];
    [self addSubview:_line];
    _line.frame = CGRectMake(0*ScrenScale, 320*ScrenScale, self.width_sd*ScrenScale, 0*ScrenScale);
    
    
}

@end
