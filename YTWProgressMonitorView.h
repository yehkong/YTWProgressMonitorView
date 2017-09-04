//
//  YTWProgressMonitorView.h
//  yetaiwen
//
//  Created by yetaiwen on 2017/8/8.
//  Copyright © 2017年 yetaiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static NSString * const kProgressDic = @"progressDic";
static NSString * const kFileName = @"fileName";
static NSString * const kDownloadRate = @"downloadRate";
//monitor properties...

@class YTWProgressMonitorView;

@protocol YTWProgressOperationDelegate <NSObject>

- (void)cancelOperate:(YTWProgressMonitorView *)progressView;

- (void)pauseOperate:(YTWProgressMonitorView *)progressView;

- (void)goonOperate:(YTWProgressMonitorView *)progressView;

@end

typedef NS_ENUM(NSUInteger,ProgressViewType){
    kProgressViewTypeDelete = 0,
    kProgressViewTypeCopy,
};

@interface YTWProgressMonitorView : UIView

@property (nonatomic, weak) id<YTWProgressOperationDelegate> delegate;

/**
 show ProgressView,with the type(reference NS_ENUM ProgressViewType)
 */
+(instancetype)showProgressMonitorViewWithType:(ProgressViewType)type;

/**
 update and show the progress from the YTWMonitor
 */
+(void)updateProgressViewWith:(NSDictionary *)dic;

/**
 dismisss ProgressView
 */
+(void)dismissProgressMonitorView;

@end


/**
 monitor instance
 */
@interface YTWMonitor : NSObject
@property(nonatomic, strong) NSDictionary *progressDic; //save the monitoring properties

/**
 monitor singleton
 */
+(instancetype)shareMonitor;
@end
