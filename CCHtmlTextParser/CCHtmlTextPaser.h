//
//  CCHtmlTextPaser.h
//  CCHtmlTextParserDemo
//
//  Created by Halo on 2018/3/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCHtmlTextPaser : NSObject
+(NSMutableAttributedString *)attributedStringFromHTMLString:(NSString *)htmlString;
@end
