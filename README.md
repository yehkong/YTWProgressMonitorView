## YTWProgressMonitorView
## Using customed alert view to monitor the progress and know the state for task, such as download task,copy files task...

以下为介绍用法的博客地址：[一个简单的自定义监控及显示进度控件YTWProgressMonitorView](https://www.jianshu.com/p/f5f9d48b1d39)

序言：自己简单写了一个自定义UI的控件，适用于监控和显示进度(拷贝数据、下载文件等都可以)；下面直接介绍使用方法。

1.  根据类型(kProgressViewTypeDelete删除文件/kProgressViewTypeCopy复制文件)显示对应的控件
```
+(instancetype)showProgressMonitorViewWithType:(ProgressViewType)type;
```

2.  定义了YTWMonitor监控类，将监控的属性保存到字典progressDic中，从而触发KVO，达到更新数据的目的；
3.  根据progressDic的数据变化，通过KVO，更新控件；
```
+(void)updateProgressViewWith:(NSDictionary *)dic;
```

4.  定义了协议YTWProgressOperationDelegate，用于反应用户的行为：
```
- (void)cancelOperate:(YTWProgressMonitorView *)progressView;//取消操作

- (void)pauseOperate:(YTWProgressMonitorView *)progressView;//暂停操作
- (void)goonOperate:(YTWProgressMonitorView *)progressView;//继续操作
```
5.   任务完成后，显示控件消失；
```
+(void)dismissProgressMonitorView;
```

6.   其中监控的属性可以根据业务需要增删和更改；
```
static NSString * const kProgressDic = @"progressDic";

static NSString * const kFileName = @"fileName";

static NSString * const kDownloadRate = @"downloadRate";
```



