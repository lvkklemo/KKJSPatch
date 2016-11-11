//
//  MyAlertView.m
//  cycling
//  继承UIView的自定制alertView
//
//  Created by lkk on 15/8/10.
//  Copyright (c) 2015年 ZQNB. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyAlertviewDelegate<NSObject>
@optional

/**
 选择某个按钮的事件
 */
-(void)didClickButtonAtIndex:(NSUInteger)index;

@end

@interface MyAlertView : UIView
@property (weak,nonatomic) id<MyAlertviewDelegate> delegate;

@property (nonatomic, strong)UIView * myAlertView;
@property (nonatomic, strong)UITextView * textView;
@property (nonatomic, strong)UIImageView *headImageView;//头像
@property (nonatomic, strong)UILabel *nickNameLabel;//昵称

/**
 参数说明：textViewType--文本框类型，phone、normal、headImage或者空
 */
- (instancetype)initWithTitle:(NSString *) title
                   andContent:(NSString *) content
                 CancelButton:(NSString *)cancelButton
                     OkButton:(NSString *)okButton
              andTextViewType:(NSString *)textViewType
               andPlaceHolder:(NSString *)placeHolder;



//- (instancetype)initWithTitle:(NSString *) title
//                andCustomView:(UIView *) customView
//          andCustomViewHeight:(int)customViewHeight
//                 CancelButton:(NSString *)cancelButton
//                     OkButton:(NSString *)okButton;

- (void)show;

@end
