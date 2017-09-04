//
//  YTWProgressMonitorView.m
//  yetaiwen
//
//  Created by yetaiwen on 2017/8/8.
//  Copyright © 2017年 yetaiwen. All rights reserved.
//

#import "YTWProgressMonitorView.h"

@implementation YTWMonitor

static YTWMonitor *_monitor = nil;
+ (instancetype)shareMonitor
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_monitor) {
            _monitor = [[YTWMonitor alloc]init];
        }
    });
    return _monitor;
}

@end


@interface YTWProgressMonitorView()

@property (weak, nonatomic) IBOutlet UIView *progressBgView;
@property (weak, nonatomic) IBOutlet UILabel *progressRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIView *deleteBgView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation YTWProgressMonitorView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
static YTWProgressMonitorView *_progressView = nil;
+(instancetype)showProgressMonitorViewWithType:(ProgressViewType)type
{
    @synchronized (self) {
        if (!_progressView) {
            UIWindow *window = (UIWindow *)[UIApplication sharedApplication].windows.firstObject;
            _progressView = [[[NSBundle mainBundle]loadNibNamed:@"YTWProgressMonitorView" owner:nil options:nil]firstObject];
            _progressView.bounds = window.bounds;
            _progressView.mainView.layer.cornerRadius = 15.;
            _progressView.mainView.layer.masksToBounds = YES;
            _progressView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.01];
            if (type == kProgressViewTypeCopy){
                _progressView.deleteBgView.hidden = YES;
                _progressView.backView.hidden = NO;
                [_progressView.cancelBtn setTitle:NSLocalizedString(@"cancel", "delete") forState:UIControlStateNormal];
                [_progressView.pauseBtn setTitle:NSLocalizedString(@"continue", "continue") forState:UIControlStateSelected];
                [_progressView.pauseBtn setTitle:NSLocalizedString(@"pause", "pause") forState:UIControlStateNormal];
            }else if (type == kProgressViewTypeDelete){
                _progressView.deleteBgView.hidden = NO;
                _progressView.backView.hidden = YES;
                [_progressView.deleteBtn setTitle:NSLocalizedString(@"cancel", "delete") forState:UIControlStateNormal];
            }
            [window addSubview:_progressView];
            _progressView.center = window.center;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orientationChangeRespond) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        }
        return _progressView;
    }
}

+(void)updateProgressViewWith:(NSDictionary *)dic
{
    NSParameterAssert(dic);
    if (_progressView) {
        NSString *fileName = [dic objectForKey:kFileName];
        if (fileName) {
            _progressView.fileNameLabel.text = fileName;
        }
        NSString *finishRate = [dic objectForKey:kDownloadRate];
        if (finishRate) {
            _progressView.progressRateLabel.text = finishRate;
        }
    }
}

+(void)dismissProgressMonitorView
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [_progressView removeFromSuperview];
    _progressView = nil;
}

/**
 orientation change notification metrod
 */
+ (void)orientationChangeRespond
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
        _progressView.bounds = [UIScreen mainScreen].bounds;
        _progressView.center = _progressView.superview.center;
    }else{
        _progressView.bounds = [UIScreen mainScreen].bounds;
        _progressView.center = _progressView.superview.center;
    }
}

- (IBAction)cancelDeleteAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(cancelOperate:)]) {
        [_delegate cancelOperate:_progressView];
    }
}

- (IBAction)cancelAction:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(cancelOperate:)]) {
        [_delegate cancelOperate:_progressView];
    }
}


- (IBAction)pauseOrGoonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.isSelected && [_delegate respondsToSelector:@selector(pauseOperate:)]) {
        [_delegate pauseOperate:_progressView];
    }else if(!sender.isSelected && [_delegate respondsToSelector:@selector(goonOperate:)]) {
        [_delegate goonOperate:_progressView];
    }
}

@end

