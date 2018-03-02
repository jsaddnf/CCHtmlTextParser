//
//  CCHtmlTextPaser.m
//  CCHtmlTextParserDemo
//
//  Created by Halo on 2018/3/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "CCHtmlTextPaser.h"
#import "CCTextImageViewAttachment.h"
#import "YYText.h"
#import "NSAttributedString+YYText.h"

@implementation CCHtmlTextPaser
+(NSMutableAttributedString *)attributedStringFromHTMLString:(NSString *)htmlString
{
    if (htmlString.length <= 0) {
        return [[NSMutableAttributedString alloc] init];
    }
    //正则表达式匹配
    NSString* parten = @"<img .*?/>";
    NSError* error = NULL;
    
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray* match = [reg matchesInString:htmlString options:NSMatchingReportCompletion range:NSMakeRange(0, htmlString.length)];
    
    NSMutableString * attr = [[NSMutableString alloc] init];
    
    if (match.count != 0)
    {
        //开头文字
        NSRange frRange = ((NSTextCheckingResult*)[match objectAtIndex:0]).range;
        
        [attr appendString:[htmlString substringWithRange:NSMakeRange(0, frRange.location)]];
        
        for (int i = 0; i<match.count;i++) {
            //替换img标签内容
            NSTextCheckingResult *matc = [match objectAtIndex:i];
            NSRange range = [matc range];
            //NSLog(@"%lu,%lu,%@",(unsigned long)range.location,(unsigned long)range.length,[htmlString substringWithRange:range]);
            
            NSString * subtext = [htmlString substringWithRange:range];
            
            //给img标签加超链接
            NSMutableString * text = [[NSMutableString alloc] initWithString:@"<a href=\""];
            
            NSString *href = [self findInString:subtext fromStartString:@"src=\""];
            [text appendString:href];
            //这里用base64静态图片替换URL链接，防止系统多次加载图片
            [text appendString:@"\"><img src=\"data:image/gif;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQImWNgYGBgAAAABQABh6FO1AAAAABJRU5ErkJggg==\" width=\""];
            float scaleTimes = 1;
            NSString * width = [self findInString:subtext fromStartString:@"width=\""];
            //根据需要对图片进行缩放
//            if (width.intValue > kScreenWidth - 90) {
//                scaleTimes = width.floatValue / @(kScreenWidth - 90).floatValue;
//                width = @(kScreenWidth - 90).stringValue;
//            }
            [text appendString:width];
            
            [text appendString:@"\" height=\""];
            
            NSString * height = [self findInString:subtext fromStartString:@"height=\""];
            height = @(height.floatValue/scaleTimes).stringValue;
            [text appendString:height];
            
            [text appendString:@"\"/></a>"];
            [attr appendString:text];
            
            if (i<match.count-1) {
                
                NSTextCheckingResult *nextMatc = [match objectAtIndex:i+1];
                NSRange nextRange = [nextMatc range];
                NSRange newRange = NSMakeRange(NSMaxRange(range), nextRange.location-NSMaxRange(range));
                NSString * text = [htmlString substringWithRange:newRange];
                [attr appendString:text];
                
            }else
            {
                //结尾文字
                NSRange foRange = ((NSTextCheckingResult*)[match lastObject]).range;
                NSString * text = [htmlString substringWithRange:NSMakeRange(foRange.location+foRange.length, htmlString.length-foRange.location-foRange.length)];
                [attr appendString:text];
            }
        }
        
    }else
    {
        //title
        [attr appendString:htmlString];
    }
    
    NSMutableAttributedString * text = [self outputAttributedString:attr];
    //多段p标签会多生成一个\n，此处删除即可
    if ([text.string hasSuffix:@"\n"]) {
        [text deleteCharactersInRange:NSMakeRange(text.length-1, 1)];
    }
    //循环遍历找到img附件
    NSRange range = NSMakeRange(0, text.length);
    [text enumerateAttribute:NSAttachmentAttributeName inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
        //
        NSTextAttachment * attach = value;
        
        if (attach) {
            //找到超链接，提取到img的URL
            __block NSURL * imageUrl = nil;
            [text enumerateAttribute:NSLinkAttributeName inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
                imageUrl = value;
            }];
            
            //创建自定义Attachment，赋值URL，size
            CCTextImageViewAttachment * imageAttach = [CCTextImageViewAttachment new];
            imageAttach.contentMode = UIViewContentModeScaleAspectFit;
            imageAttach.imageURL = imageUrl;
            imageAttach.size = attach.bounds.size;
            
            //图片下载的代理
            YYTextRunDelegate *delegate = [YYTextRunDelegate new];
            delegate.width = attach.bounds.size.width;
            delegate.ascent = attach.bounds.size.height;
            delegate.descent = 0;
            CTRunDelegateRef delegateRef = delegate.CTRunDelegate;
            [text yy_setRunDelegate:delegateRef range:range];
            if (delegate) CFRelease(delegateRef);
            
            //用自定义的Attachment替换掉旧的
            [text removeAttribute:NSAttachmentAttributeName range:range];
            
            [text yy_setTextAttachment:imageAttach range:range];
        }
    }];
    
    return text;
}
+(NSString *)findInString:(NSString *)str fromStartString:(NSString *)start
{
    if (str && start) {
        
        NSRange range = [str rangeOfString:start];
        
        if (range.location != NSNotFound) {
            
            NSRange searchRange = NSMakeRange(range.location+range.length, str.length-range.location-range.length);
            
            NSRange endRange = [str rangeOfString:@"\"" options:NSLiteralSearch range:searchRange];
            
            if (endRange.location != NSNotFound) {
                
                NSRange resultRange = NSMakeRange(range.location+range.length, endRange.location-range.location-range.length);
                
                NSString * resultStr = [str substringWithRange:resultRange];
                
                return resultStr;
            }
        }
    }
    
    return @"";
}

+ (NSMutableAttributedString *)outputAttributedString:(NSString *)html{
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString * mutAttributedStr = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:NULL error:nil]];
    return mutAttributedStr;
}
@end
