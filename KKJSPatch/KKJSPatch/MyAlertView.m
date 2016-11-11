//
//  MyAlertView.m
//  cycling
//  继承UIView的自定制alertView
//
//  Created by lkk on 15/8/10.
//  Copyright (c) 2015年 ZQNB. All rights reserved.
//

#import "MyAlertView.h"
//#import "Common.h"
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//屏幕宽度
#define UI_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define UI_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

static const CGFloat alertviewWidth = 270.0;

@interface MyAlertView()<UITextViewDelegate>

@property (strong,nonatomic)UIDynamicAnimator * animator;
@property (strong,nonatomic)UIView * alertview;
@property (strong,nonatomic)UIView * backgroundview;
@property (strong,nonatomic)NSString * title;//标题
@property (strong,nonatomic)NSString * content;//内容
@property (strong,nonatomic)NSString * cancelButtonTitle;
@property (strong,nonatomic)NSString * okButtonTitle;
@property (strong,nonatomic)NSString * textViewType;//文本框类型
@property (strong,nonatomic)NSString * placeHolder;
//@property (strong,nonatomic)UITextView * textView;
@property (strong,nonatomic)UILabel * placeholderLabel;
@property (strong,nonatomic)UILabel *lineLabel;

//@property (strong,nonatomic)UIView *customView;//自定制View

//@property (strong,nonatomic)UIImage * image;


@end


@implementation MyAlertView
{
    CGRect _lastViewFrame;//记录下方灰色框的上一个视图的frame
    //int _customViewHeight;//自定制View的高度
}

#pragma mark - Gesture
//点击屏幕其他地方，alertView消失
-(void)click:(UITapGestureRecognizer *)sender{
    CGPoint tapLocation = [sender locationInView:self.backgroundview];
    CGRect alertFrame = self.alertview.frame;
    if (!CGRectContainsPoint(alertFrame, tapLocation)) {
        [self dismiss];
    }
}

#pragma mark -  private function
-(UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title andButtonIndex:(NSString *)buttonIndex
{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    
    [button.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:14.0]];
    
    if ([buttonIndex isEqualToString:@"0"]) {//取消按钮
        [button setBackgroundImage:[UIImage imageNamed:@"alertView_btn2_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"alertView_btn2_press"] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
        
    }else if([buttonIndex isEqualToString:@"1"]){//确定按钮
        [button setBackgroundImage:[UIImage imageNamed:@"alertView_btn1_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"alertView_btn1_press"] forState:UIControlStateHighlighted];
        
        [button setTitleColor:RGBACOLOR(143, 240, 200, 1)forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    }
    
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //点按钮的时候变高亮
    //[button setShowsTouchWhenHighlighted:YES];
    return button;
}


-(void)clickButton:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(didClickButtonAtIndex:)]) {
        [self.delegate didClickButtonAtIndex:(button.tag -1)];
    }
    //alertView消失
    [self dismiss];
}

//alertView消失
-(void)dismiss{
    
    [self.animator removeAllBehaviors];
    //旋转变小消失掉
    [UIView animateWithDuration:0.7 animations:^{
        self.alpha = 0.0;
        CGAffineTransform rotate = CGAffineTransformMakeRotation(0.9 * M_PI);
        CGAffineTransform scale = CGAffineTransformMakeScale(0.1, 0.1);
        self.alertview.transform = CGAffineTransformConcat(rotate, scale);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
            self.alertview = nil;
    }];
    //没有动画，直接消失
    [self removeFromSuperview];
    
}
-(void)setUp{
    self.backgroundview = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    self.backgroundview.backgroundColor = [UIColor blackColor];
    self.backgroundview.alpha = 0.4;
    [self addSubview:self.backgroundview];
    //点击屏幕其他地方alertView消失
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
//    [self.backgroundview addGestureRecognizer:tap];
    
    self.alertview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertviewWidth, 250)];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    self.alertview.center = CGPointMake(CGRectGetMidX(keywindow.frame), -CGRectGetMidY(keywindow.frame));//让alertView先在屏幕外看不到的地方，以便动画效果出现
    self.alertview.backgroundColor = [UIColor redColor];
    //self.alertview.layer.cornerRadius = 17;//圆角
    //self.alertview.clipsToBounds = YES;//无剪边属性
    
    [self addSubview:self.alertview];
    
    self.myAlertView = self.alertview;
    
    //标题
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(alertviewWidth/2,18,0,16)];
    titleLabel.text = self.title;
    [titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:16.0]];
    
    CGSize titleLabelSize = CGSizeMake(0, 0);//标题尺寸
    //根据内容多少取label尺寸
    titleLabelSize = [titleLabel.text boundingRectWithSize:CGSizeMake(alertviewWidth,16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"STHeitiSC-Light" size:17]} context:nil].size;
    
    titleLabel.frame = CGRectMake(alertviewWidth/2-titleLabelSize.width/2, 18, titleLabelSize.width, 16);
    [self.alertview addSubview:titleLabel];
    
    //标题下得灰色分割线
    self.lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height+7, titleLabel.frame.size.width, 0.3)];
    self.lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self.alertview addSubview:self.lineLabel];
    
    _lastViewFrame = self.lineLabel.frame;
    
    
    if ([self.textViewType isEqualToString:@"normal"]) {//普通TextView，且上方无文字
        
        [self customTextView];
        
    }else if([self.textViewType isEqualToString:@"phone"]){//手机TextView，且上方有文字
        
        [self customContentLabel];
        [self customTextView];
        
    }else if([self.textViewType isEqualToString:@"headImage"]){//带头像，且右侧有文字
        
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, _lastViewFrame.origin.y + _lastViewFrame.size.height + 10, 55, 55)];
        self.headImageView.layer.cornerRadius = 22.5;
        self.headImageView.layer.masksToBounds = YES;
        [self.alertview addSubview:self.headImageView];
        self.nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.headImageView.frame.origin.x + self.headImageView.frame.size.width + 10, _headImageView.frame.origin.y + 20, 100, 15)];
        [self.nickNameLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:15.0]];
        [self.alertview addSubview:self.nickNameLabel];
        _lastViewFrame = self.headImageView.frame;
    }
    else{
        //没有TextView，只有文字内容
        [self customContentLabel];
    }

    //下方灰色区域
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, _lastViewFrame.origin.y+_lastViewFrame.size.height+15, alertviewWidth, 46)];
    downView.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    [self.alertview addSubview:downView];

    
    if (self.cancelButtonTitle.length == 0 || [self.cancelButtonTitle isEqualToString:@""]) {
        //没有取消按钮时
        //确定按钮
        CGRect okButtonFrame = CGRectMake(67, 8, alertviewWidth/2+1, 30);
        UIButton * okButton = [self createButtonWithFrame:okButtonFrame Title:self.okButtonTitle andButtonIndex:@"1"];
        okButton.tag = 2;
        [downView addSubview:okButton];
        
    }else{
        //既有取消按钮也有确定按钮时
        //取消按钮
        CGRect cancelButtonFrame = CGRectMake(5, 8, alertviewWidth/2-7.5, 30);
        UIButton * cancelButton = [self createButtonWithFrame:cancelButtonFrame Title:self.cancelButtonTitle andButtonIndex:@"0"];
        cancelButton.tag = 1;
        [downView addSubview:cancelButton];
        
        //确定按钮
        CGRect okButtonFrame = CGRectMake(cancelButton.frame.origin.x + cancelButton.frame.size.width + 5, 8, alertviewWidth/2-7.5, 30);
        UIButton * okButton = [self createButtonWithFrame:okButtonFrame Title:self.okButtonTitle andButtonIndex:@"1"];
        okButton.tag = 2;
        [downView addSubview:okButton];
    }
    
    //根据内容多少，重新赋给alertView尺寸
    CGRect alertFrame = self.alertview.frame;
    alertFrame.size.height = downView.frame.origin.y+downView.frame.size.height;
    self.alertview.frame = alertFrame;
    
    
}

//创建TextView
- (void)customTextView
{
    if([self.textViewType isEqualToString:@"phone"]){//phone类型的TextView
        
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(20, _lastViewFrame.origin.y + _lastViewFrame.size.height + 10, alertviewWidth-20-20, 30)];
        self.textView.keyboardType = UIKeyboardTypePhonePad;
        
    }else{//normal类型的TextView
        
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(20, _lastViewFrame.origin.y + _lastViewFrame.size.height + 10, alertviewWidth-20-20, 80)];
    }
    
    self.textView.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    self.textView.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    self.textView.layer.borderWidth = 0.5;
    self.textView.delegate = self;
    
    self.textView.font = [UIFont fontWithName:@"Arial" size:13.0]; //设置字体名字和字体大小;
    
    self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 9, 200, 13)];
    self.placeholderLabel.text = self.placeHolder;
    self.placeholderLabel.font = [UIFont fontWithName:@"Arial" size:13.0];
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    [self.textView addSubview:self.placeholderLabel];
    
    [self.alertview addSubview:self.textView];
    
    _lastViewFrame = self.textView.frame;
}

//创建内容label
- (void)customContentLabel
{
    //内容
    UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _lastViewFrame.origin.y + _lastViewFrame.size.height+15, alertviewWidth-20-20, 0)];
    contentLabel.text = self.content;
    contentLabel.numberOfLines = 0;
    [contentLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0]];
    
    //调整label的行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:contentLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentLabel.text length])];
    contentLabel.attributedText = attributedString;
    
    CGSize contentLabelSize = CGSizeMake(0, 0);//内容尺寸
    //根据内容多少取label尺寸
    contentLabelSize = [contentLabel.text boundingRectWithSize:CGSizeMake(alertviewWidth-20-20,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"STHeitiSC-Light" size:16]} context:nil].size;
    
    contentLabel.frame = CGRectMake(20, self.lineLabel.frame.origin.y+self.lineLabel.frame.size.height+15, alertviewWidth-20-20, contentLabelSize.height);
    [self.alertview addSubview:contentLabel];
    
    _lastViewFrame = contentLabel.frame;
}

//开始编辑
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    //编辑状态隐藏提示语label
    self.placeholderLabel.hidden = YES;
    
    return YES;
}

//触摸屏幕
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
    //如果内容为空，就显示提示语label
    if ([self.textView.text isEqualToString:@""]) {
        self.placeholderLabel.hidden = NO;
    }
}

#pragma mark -  API
- (void)show {
    
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    
    //物理重力掉落效果
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    CGPoint centerPoint = CGPointMake(self.center.x, self.center.y-UI_SCREEN_HEIGHT/16);
    UISnapBehavior * sanp = [[UISnapBehavior alloc] initWithItem:self.alertview snapToPoint: centerPoint];
    sanp.damping = 0.5;
    [self.animator addBehavior:sanp];
}

//无View，带内容类型
- (instancetype)initWithTitle:(NSString *)title
                   andContent:(NSString *)content
                 CancelButton:(NSString *)cancelButton
                     OkButton:(NSString *)okButton
              andTextViewType:(NSString *)textViewType
               andPlaceHolder:(NSString *)placeHolder
{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        self.title = title;
        //self.image = image;
        self.content = content;
        self.cancelButtonTitle = cancelButton;
        self.okButtonTitle = okButton;
        self.textViewType = textViewType;
        self.placeHolder = placeHolder;
        self.backgroundColor = [UIColor yellowColor];
        [self setUp];
    }
    return self;
}


@end
