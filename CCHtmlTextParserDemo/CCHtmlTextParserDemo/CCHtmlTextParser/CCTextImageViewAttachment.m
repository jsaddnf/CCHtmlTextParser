//
//  CCTextImageViewAttachment.m
//  CCHtmlTextParserDemo
//
//  Created by Halo on 2018/3/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "CCTextImageViewAttachment.h"
#import <pthread.h>
@implementation CCTextImageViewAttachment
{
    UIImageView *_imageView;
}

- (void)setContent:(id)content {
    _imageView = content;
}

- (id)content {
    /// UIImageView 只能在主线程访问
    if (pthread_main_np() == 0) return nil;
    if (_imageView) return _imageView;
    /// 第一次获取时 (应该是在文本渲染完成，需要添加附件视图时)，初始化图片视图，并下载图片
    _imageView = [UIImageView new];
    _imageView.backgroundColor = [UIColor whiteColor];
    CGRect imageFrame = CGRectZero;
    imageFrame.size = _size;
    _imageView.frame = imageFrame;
    _imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:_imageURL]];
    ///通过SDWebImage缓存图片
//    [_imageView sd_setImageWithURL:_imageURL placeholderImage:nil options:SDWebImageHandleCookies];
    
//    //可添加点击事件
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(picClicked)];
//    _imageView.userInteractionEnabled = YES;
//    [_imageView addGestureRecognizer:tap];
    
    return _imageView;
}

////图片点击事件
//- (void)picClicked{
//
//}
@end
