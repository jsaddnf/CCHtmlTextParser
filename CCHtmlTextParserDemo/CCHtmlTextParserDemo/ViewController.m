//
//  ViewController.m
//  CCHtmlTextParserDemo
//
//  Created by Halo on 2018/3/1.
//  Copyright © 2018年 Choice. All rights reserved.
//

#import "ViewController.h"
#import "YYText.h"
#import "CCHtmlTextPaser.h"
#import "NSAttributedString+YYText.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *htmlString = @"<p>1.数学这么难我并不会啊</p> \n<p><img width=\"108\" height=\"44\" src=\"http:\/\/shangchuan.566.com\/exam8uploadpath\/TiKu\/156372959\/1\/f\/79c56c26-bcdc-4e70-bd40-11208e4cace0.png\" align=\"absmiddle\" /> <p>2.数学这么难<img width=\"103\" height=\"37\" src=\"http:\/\/shangchuan.566.com\/exam8uploadpath\/TiKu\/156372959\/1\/f\/79c56c26-bcdc-4e70-bd40-11208e4cace0.png\" align=\"absmiddle\" /><p> 3.<img width=\"108\" height=\"44\" src=\"http:\/\/shangchuan.566.com\/exam8uploadpath\/TiKu\/156372959\/1\/f\/79c56c26-bcdc-4e70-bd40-11208e4cace0.png\" align=\"absmiddle\" />数学这么难</p> \n<p> <p>4.这是一段很长很长的文字这是一段很长很长的文字这是一段很长很长的文字这是一段很长很长的文字这是一段很长很长的文字这是一段很长很长的文字这是一段很长很长的文字 <img width=\"108\" height=\"44\" src=\"http:\/\/shangchuan.566.com\/exam8uploadpath\/TiKu\/156372959\/1\/f\/79c56c26-bcdc-4e70-bd40-11208e4cace0.png\" align=\"absmiddle\" />这是一段很长很长的文字这是一段很长很长的文字这是一段很长很长的文字这是一段很长很长的文字这是一段很长很长的文字这是一段很长很长的文字这是一段很长很长的文字 </p>";
    
    YYLabel *label = [[YYLabel alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height)];
    label.numberOfLines = 0;
    NSMutableAttributedString *att = [CCHtmlTextPaser attributedStringFromHTMLString:htmlString];
    att.yy_font = [UIFont systemFontOfSize:14];
    att.yy_lineSpacing = 5;
    att.yy_color = [UIColor blackColor];
    att.yy_paragraphSpacing = 0;
    YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20,HUGE)];
    label.textLayout = [YYTextLayout layoutWithContainer:container text:att];
    [self.view addSubview:label];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
