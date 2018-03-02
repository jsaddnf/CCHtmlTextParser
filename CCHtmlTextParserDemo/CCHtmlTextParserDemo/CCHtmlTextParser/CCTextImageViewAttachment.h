//
//  CCTextImageViewAttachment.h
//  CCHtmlTextParserDemo
//
//  Created by Halo on 2018/3/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "YYTextAttribute.h"

@interface CCTextImageViewAttachment : YYTextAttachment
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, assign) CGSize size;
@end
