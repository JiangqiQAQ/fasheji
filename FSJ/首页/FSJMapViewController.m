//
//  FSJMapViewController.m
//  FSJ
//
//  Created by Monstar on 16/4/13.
//  Copyright © 2016年 Monstar. All rights reserved.
//
#import "AppDelegate.h"
#import "FSJMapViewController.h"
#import "MyAnimatedAnnotationView.h"
#import "FSJMeViewController.h"
#import "FSJAllFSJ.h"
#import "FSJOneFSJ.h"
#import "FSJOneFSJTableViewCell.h"
#import "FSJMoreInfomationViewController.h"
#import "FSJPeopleManagerDetailViewController.h"
#import "FSJOneCity.h"
#import "FSJPeopleManagimentviewController.h"
#import "FSJTongjiViewController.h"
#import "FSJTransPoint.h"
#import "FSJPopHeadview.h"
#import "FSJNoDataTableViewCell.h"
#define tableviewHeight self.view.bounds.size.height/4+50
#define tableviewY      self.view.bounds.size.height/4*3 -50
#define moveDistance    self.view.bounds.size.height/4
NSString *keyCityError      = @"kCityError";
NSString *keyCityNor        = @"kCityNor";
NSString *keyCityNorID      = @"kCityNorID";
NSString *keyCityErrorID    = @"kCityErrorID";
NSString *keyCityErrorCount = @"kCityErrorCount";
NSString *keyCityNorCount   = @"kCityNorCount";
@interface FSJMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKDistrictSearchDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    UIPanGestureRecognizer *cellpan;
    UISwipeGestureRecognizer *swipdown;
    UISwipeGestureRecognizer *swipup;
    NSMutableArray *imageViewArr;
    NSMutableArray *btnArr;
    UINavigationController *nav;
   // BMKLocationService* locService;
    NSMutableArray    *listNormal;
    NSMutableArray    *listidNormal;
    NSMutableArray    *listError;
    NSMutableArray    *namelist;
    NSMutableArray    *listidError;
    NSMutableArray    *searchList;
    NSMutableArray    *nameIdDic;
    NSMutableArray    *stationArr;
    NSMutableArray    *stationNormal;
    NSMutableArray    *stationError;
    NSMutableArray    *overlayNor;
    NSMutableArray    *overlayEor;
    NSMutableArray    *quanjuArr;

    NSMutableArray    *cityNormal;
    NSMutableArray    *cityError;
    NSMutableArray    *cityidNormal;
    NSMutableArray    *cityidError;
    NSMutableArray    *allcityName;
    NSMutableArray    *allcityModel;
    NSMutableArray    *cityoverlayErr;
    NSMutableArray    *cityoverlayNor;
    NSMutableArray    *allsite;
    NSMutableArray    *allname;
    BMKDistrictSearch *_NormalSearch;
    BMKDistrictSearch *_ErrorSearch;
    BMKPolyline       *normalArea;
    BMKPolygon        *errorArea;
    BMKGeoCodeSearch* _geocodesearch;
    BMKGeoCodeSearch* _geocodesearchCity;
    NSString * staticAreaname;
    NSString * staticJwt;
    NSString * staticareaType;
    NSString * staticareaId;
    NSString * staticuserId;
    NSString * statitopic;
    NSString * staticName;
    NSInteger *sizeNo;
    NSInteger *pageNo;
    NSInteger *warnNumber;
    BOOL showWarn;
    BOOL showCity;
    BOOL showProvince;
    BOOL districtSearch;
    BOOL full;
    BOOL showPop;
    UIColor* WarnStokeColor;
    UIColor* WarnFillColor;
    UIColor* NorStokeColor;
    UIColor* NorFillColor;
   // BMKMapView *self.mapView;
    UIView *BackgroundVIew;
    UISearchBar *mainSearchbar;
    UIButton *userBtn;
    UIView *tabbarBg;
    
    NSArray *gaojingArr;
    NSArray *shebeiArr;
    
    NSArray *gaojingimgArr;
    NSArray *shebeiimgArr;
    
    
    NSArray *shebeiTypeArr;
    NSArray *gaojingTypeArr;
    UIView *maskview;
    NSString *tableViewTitle;
    AppDelegate *appDelegate;
    CLLocationCoordinate2D startpoint;
    NSString * versionStr;
}

@property (nonatomic, strong)UITableView *mytableView;
@property (nonatomic, strong)BMKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *lenovoTableArray;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (nonatomic, strong)UITableView *LenovoTableView;
#define FirstLevel  6.0f
#define SecondLevel 8.0f
#define ThirdtLevel 11.0f
#define ForthLevel  12.50f
@end

@implementation FSJMapViewController
- (NSMutableArray *)lenovoTableArray{
    if (_lenovoTableArray == nil) {
        _lenovoTableArray = @[].mutableCopy;
    }
    return _lenovoTableArray;
}
- (UITableView *)LenovoTableView{
    if (_LenovoTableView == nil) {
        _LenovoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, HEIGH *0.08, WIDTH, HEIGH) style:UITableViewStylePlain];
        _LenovoTableView.dataSource = self;
        _LenovoTableView.delegate   = self;
    }
    return _LenovoTableView;
}
#pragma mark -- 视图周期
- (BMKMapView *)mapView{
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, HEIGH)];
    }
    return _mapView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;// 此处记得不用的时候需要置nil，否则影响内存的释放
   // locService.delegate = self;
    _geocodesearchCity.delegate = self;
    _geocodesearch.delegate = self;
}
- (void)dealloc {
    if (self.mapView) {
        self.mapView.delegate = nil;
        self.mapView = nil;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    //locService.delegate = nil;
    _geocodesearch.delegate = nil;
    _geocodesearchCity.delegate = nil;
    
    for (BMKDistrictSearch *search in searchList) {
        search.delegate = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self receiveWarnNoti];
    });
        [self customUI];
    [self addCustomGestures];//添加自定义的手势
    staticJwt      = [[EGOCache globalCache]stringForKey:@"jwt"];
    staticareaType = [[EGOCache globalCache]stringForKey:@"areaType"];
    staticareaId   = [[EGOCache globalCache]stringForKey:@"areaId"];
    staticuserId   = [[EGOCache globalCache]stringForKey:@"userId"];
    staticName     = [[EGOCache globalCache]stringForKey:@"areaname"];
    statitopic     = [NSString stringWithFormat:@"%@/#",[[EGOCache globalCache]stringForKey:@"topic"]];
    NSDictionary *dic = @{@"areaId":staticareaId,@"areaType":staticareaType,@"userId":staticuserId,@"jwt":staticJwt};
    
    [self getallstationInfoWith:@"" andtype:Allstationquery anddicparameter:@"keyword" andShowAnno:NO andFirst:YES];
    if ([staticareaType isEqualToString:@"1"]) {
        startpoint = self.mapView.centerCoordinate;
        [UIView animateWithDuration:1.0 animations:^{
            self.mapView.zoomLevel = FirstLevel;
        }];
        [self searchWithModelwith:dic];
    }
    if ([staticareaType isEqualToString:@"2"]) {
        [self getCtiyWithID:@[staticareaId] andName:@[staticName]];
        [UIView animateWithDuration:1.0 animations:^{
            self.mapView.zoomLevel = SecondLevel;
        }];
    }
    if ([staticareaType isEqualToString:@"3"]) {
        [self getCityStationWith:dic and:YES];
    }
   //[self checkUpdate];
}
#pragma mark --检查更新
- (void)checkUpdate{
    NSString *jwtStr = [[EGOCache globalCache]stringForKey:@"jwt"];
    NSDictionary *verdic = @{@"jwt":jwtStr};
    [FSJNetworking networkingGETWithActionType:GetVerisonInfo requestDictionary:verdic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        versionStr   = [[responseObject objectForKey:@"version"]substringFromIndex:1];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        // app build版本
        
        if ([app_Version isEqualToString:versionStr]) {
            // [SVProgressHUD showInfoWithStatus:@"当前已经是最新版本"];
        }
        else{
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"新版本可以更新" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *no = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *yes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.pgyer.com/oSSb"]];
            }];
            [ac addAction:no];
            [ac addAction:yes];
            [self presentViewController:ac animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark -- 警告通知
- (void)receiveWarnNoti{
    NSLog(@"开始订阅");
    appDelegate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.client = [[MQTTClient alloc]initWithClientId:@"ios0423" withAppName:@"fsj"];
    THWeakSelf(weakself);
    [appDelegate.client setMessageHandler:^(MQTTMessage *message){
        NSLog(@"received");
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself changeStatusWith:[message payloadString]];
        });
    }];
    [appDelegate.client connectToHost:@"119.6.203.24" completionHandler:^(MQTTConnectionReturnCode code) {
        if (code == ConnectionAccepted) {
            [appDelegate.client subscribe:statitopic withCompletionHandler:nil];
        }
    }];
}
- (void)changeStatusWith:(NSString *)jsonString{
            NSData  *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *resultsDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            NSString *contentStr = resultsDic[@"content"];
            NSString *statusStr  = resultsDic[@"status"];
    NSArray  *arr = [contentStr componentsSeparatedByString:@"/"];
    //{"content":"1/11/12/10000","status":"0"}
    if ([statusStr isEqualToString:@"0"]) {
        NSInteger num = [[EGOCache globalCache]stringForKey:arr[2]].integerValue;
        num -= 1;
        for (BMKPointAnnotation *annoatation in stationError) {
            if ([annoatation.subtitle isEqualToString:arr.lastObject]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView removeAnnotation:annoatation];
                    annoatation.title = @"zc";
                    if (self.mapView.zoomLevel >ThirdtLevel) {
                        [self.mapView addAnnotation:annoatation];
                    }
                    [stationError  removeObject:annoatation];
                    [stationNormal addObject:annoatation];
                });
                NSLog(@"去掉前错误数量%lu",(unsigned long)stationError.count);
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [[EGOCache globalCache]setString:[NSString stringWithFormat:@"%ld",(long)num] forKey:arr[2]];
        });
        if ([[NSString stringWithFormat:@"%ld",(long)num] isEqualToString:@"0"]) {
            for (BMKPolygon * polygon in cityoverlayErr) {
                if ([polygon.subtitle isEqualToString:arr[2]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [cityoverlayErr removeObject:polygon];
                        [cityoverlayNor addObject:polygon];
                        polygon.title = @"0";
                        if (self.mapView.zoomLevel < ThirdtLevel && self.mapView.zoomLevel >= SecondLevel) {
                            [self.mapView removeOverlay:polygon];
                            [self.mapView addOverlay:polygon];
                        }
                    });
                }
            }
            NSInteger sheng = [[EGOCache globalCache]stringForKey:arr[1]].integerValue;
            sheng -=1;
            NSLog(@"%ld",sheng);
            //dispatch_async(dispatch_get_main_queue(), ^{
            [[EGOCache globalCache]setString:[NSString stringWithFormat:@"%ld",(long)sheng] forKey:arr[1]];
            if ([[NSString stringWithFormat:@"%ld",(long)sheng] isEqualToString:@"0"]) {
                for (BMKPolygon * polygon in overlayEor) {
                    if ([polygon.subtitle isEqualToString:arr[1]]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.mapView removeOverlay:polygon];
                            polygon.title = @"0";
                            if (self.mapView.zoomLevel <SecondLevel) {
                                [self.mapView addOverlay:polygon];
                            }
                            [overlayEor removeObject:polygon];
                            [overlayNor addObject:polygon];
                        });
                    }
                }
            }
        }
    }
    if ([statusStr isEqualToString:@"1"]){
        NSInteger num = [[EGOCache globalCache]stringForKey:arr[2]].integerValue;
        num += 1;
        for (BMKPointAnnotation *annoatation in stationNormal) {
            if ([annoatation.subtitle isEqualToString:arr.lastObject]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView removeAnnotation:annoatation];
                    annoatation.title = @"gj";
                    if (self.mapView.zoomLevel > ThirdtLevel) {
                        [self.mapView addAnnotation:annoatation];
                    }
                    [stationNormal  removeObject:annoatation];
                    [stationError   addObject:annoatation];
                });
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[EGOCache globalCache]setString:[NSString stringWithFormat:@"%ld",(long)num] forKey:arr[2]];
        });
        if (num < 0) {
            return;
        }
        if ([[NSString stringWithFormat:@"%ld",(long)num] isEqualToString:@"1"]) {
            for (BMKPolygon * polygon in cityoverlayNor) {
                if ([polygon.subtitle isEqualToString:arr[2]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mapView removeOverlay:polygon];
                        polygon.title = @"1";
                        if (self.mapView.zoomLevel < ThirdtLevel && self.mapView.zoomLevel >= SecondLevel) {
                            [self.mapView addOverlay:polygon];
                        }
                        [cityoverlayNor removeObject:polygon];
                        [cityoverlayErr addObject:polygon];
                    });
                    break;
                }
            }
            NSInteger sheng = [[EGOCache globalCache]stringForKey:arr[1]].integerValue;
            sheng +=1;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[EGOCache globalCache]setString:[NSString stringWithFormat:@"%ld",(long)sheng] forKey:arr[1]];
            });
            if (sheng <0) {
                return;
            }
            if ([[NSString stringWithFormat:@"%ld",(long)sheng] isEqualToString:@"1"]) {
                for (BMKPolygon * polygon in overlayNor) {
                    if ([polygon.subtitle isEqualToString:arr[1]]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.mapView removeOverlay:polygon];
                            polygon.title = @"1";
                            if (self.mapView.zoomLevel <SecondLevel) {
                                [self.mapView addOverlay:polygon];
                            }
                            [overlayNor removeObject:polygon];
                            [overlayEor addObject:polygon];
                        });
                        break;
                    }
                }
            }
        }
    }
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
#pragma mark -- 控件和事件
- (void)customUI{
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    statusView.backgroundColor = SystemBlueColor;
    [self.view addSubview:statusView];
    // self.view.backgroundColor = SystemBlueColor;
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
    shebeiArr       = @[@"人员信息管理",@"发射站管理",@"发射机管理"];
    shebeiimgArr    = @[@"tbrenyuan.png",@"tbfashezhan.png",@"tbfasheji.png"];
    gaojingArr      = @[@"统计",@"警告查询"];
    gaojingimgArr   = @[@"tbtongji.png",@"tbchaxun.png"];
    
    WarnStokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    NorStokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    WarnFillColor  = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.1];
    NorFillColor   = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.1];
    sizeNo = 0;
    pageNo = 0;
    warnNumber = 0;
    allname        = @[].mutableCopy;
    imageViewArr   = @[].mutableCopy;
    btnArr         = @[].mutableCopy;
    cityoverlayErr = @[].mutableCopy;
    cityoverlayNor = @[].mutableCopy;
    cityError      = @[].mutableCopy;
    cityNormal     = @[].mutableCopy;
    cityidError    = @[].mutableCopy;
    cityidNormal   = @[].mutableCopy;
    allcityName    = @[].mutableCopy;
    allcityModel   = @[].mutableCopy;
    quanjuArr      = @[].mutableCopy;
    nameIdDic      = @[].mutableCopy;
    namelist       = @[].mutableCopy;
    listNormal     = @[].mutableCopy;
    listidNormal   = @[].mutableCopy;
    listError      = @[].mutableCopy;
    listidError    = @[].mutableCopy;
    stationArr     = @[].mutableCopy;
    stationNormal  = @[].mutableCopy;
    stationError   = @[].mutableCopy;
    overlayEor     = @[].mutableCopy;
    overlayNor     = @[].mutableCopy;
    allsite        = @[].mutableCopy;
    self.mapView.gesturesEnabled    = YES;
    self.mapView.zoomEnabledWithTap = YES;
    self.mapView.zoomEnabled        = YES;
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearchCity = [[BMKGeoCodeSearch alloc]init];
    //self.mapView =[[BMKMapView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, HEIGH)];
    [self.view addSubview:self.mapView];
    BackgroundVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGH*0.08)];
    BackgroundVIew.backgroundColor = SystemBlueColor;
    userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userBtn.frame = CGRectMake(WIDTH *0.015,HEIGH * 0.015, HEIGH * 0.05, HEIGH * 0.05);
    [userBtn setBackgroundImage:[UIImage imageNamed:@"geren"] forState:UIControlStateNormal];
    [userBtn addTarget:self action:@selector(UserInfo:) forControlEvents:UIControlEventTouchUpInside];
    [BackgroundVIew addSubview:userBtn];
    mainSearchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(WIDTH *0.13,HEIGH * 0.01, WIDTH* 0.86, HEIGH *0.06)];
    mainSearchbar.placeholder = @"查找发射站";
    mainSearchbar.delegate = self;
    mainSearchbar.backgroundColor = [UIColor clearColor];
    mainSearchbar.searchBarStyle =UISearchBarStyleDefault;
    mainSearchbar.barTintColor = [UIColor whiteColor];
    [mainSearchbar setBackgroundImage:[UIImage imageWithColor:SystemWhiteColor]];
    mainSearchbar.layer.borderColor = SystemBlueColor.CGColor;
    mainSearchbar.layer.borderWidth = 0;
    mainSearchbar.layer.cornerRadius = HEIGH *0.03;
    mainSearchbar.layer.masksToBounds = YES;
    mainSearchbar.barStyle =UIBarStyleBlack;
    mainSearchbar.showsCancelButton = YES;
    for (UIView* view in mainSearchbar.subviews)
    {
        for (UIView *v in view.subviews) {
            if ( [v isKindOfClass: [UITextField class]] )
            {
                UITextField *tf = (UITextField *)v;
                tf.clearButtonMode = UITextFieldViewModeNever;
            }
        }
    }
    [BackgroundVIew addSubview:mainSearchbar];
    [self.mapView addSubview:BackgroundVIew];
    //[self.view insertSubview:BackgroundVIew atIndex:0];
    tabbarBg = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGH *0.93, WIDTH,  HEIGH *0.07)];
    //tabbarBg.userInteractionEnabled = NO;
    tabbarBg.backgroundColor = SystemLightGrayColor;
    self.view.backgroundColor = SystemWhiteColor;
    NSArray *norimg = @[@"ditu",@"jiankong",@"shebei",@"tbgaojing"];
    NSArray *seletedimg = @[@"ditu1",@"jiankong1",@"shebei1",@"tbgaojing1"];
    NSArray *titleArr  = @[@"地图",@"监控",@"设备",@"告警"];
    for (int i = 0; i<4; i ++) {
        FSJTabbarBtn * btn = [FSJTabbarBtn buttonWithType:UIButtonTypeCustom];
         btn.frame = CGRectMake(i * WIDTH/4 , 0, WIDTH/4, HEIGH *0.07);
         btn.enabled = YES;
         UIImage *btnImg = [UIImage imageNamed:norimg[i]];
         UIImage *sebtnImg = [UIImage imageNamed:seletedimg[i]];
        [btn setImage:btnImg forState:UIControlStateNormal];
        [btn setImage:sebtnImg forState:UIControlStateSelected];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        if (iPhone6plus || iPhone6) {
            [btn setFont:[UIFont systemFontOfSize: 13.0]];
        }
        else if(iPhone5){
            [btn setFont:[UIFont systemFontOfSize: 8.0]];
        }
        else if(iPhone4){
            [btn setFont:[UIFont systemFontOfSize: 10.0]];
        }
         btn.imageView.backgroundColor = [UIColor clearColor];
        //[btn setTitleEdgeInsets:UIEdgeInsetsMake(HEIGH *0.035,-20, 0, 20)];
        [btn setTitleColor:SystemGrayColor forState:UIControlStateNormal];
        [btn setTitleColor:SystemBlueColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
         btn.tag = 600 + i;
        [btnArr addObject:btn];
        [tabbarBg addSubview:btn];
    }
    for (UIButton *btn in btnArr) {
        if (btn.tag == 600) {
            btn.selected = YES;
        }
    }
    [self.view addSubview:tabbarBg];
}
- (void)btnClicked:(UIButton *)sender{
    NSLog(@"clicked");
    if (sender.selected == YES && sender.tag == 600 ) {
        //再次点击 tableview消失
        if (self.mytableView) {
            self.mytableView.hidden = YES;
            [self.mytableView removeFromSuperview];
            self.mytableView = nil;
        }
        if ([staticareaType isEqualToString:@"1"]) {
            self.mapView.centerCoordinate = startpoint;
            [UIView animateWithDuration:0.618 animations:^{
                self.mapView.zoomLevel = FirstLevel;
            }];
           
            
        }
        if ([staticareaType isEqualToString:@"2"]) {
            self.mapView.centerCoordinate = startpoint;
            [UIView animateWithDuration:0.618 animations:^{
                self.mapView.zoomLevel = SecondLevel;
                           }];
        }
        if ([staticareaType isEqualToString:@"3"]) {
             self.mapView.centerCoordinate = startpoint;
            [UIView animateWithDuration:0.618 animations:^{
                self.mapView.zoomLevel = ThirdtLevel;
            }];
        }
    }
    else if (sender.selected == YES && (sender.tag == 601||sender.tag == 602||sender.tag == 603)){
        return;
    }
    else{
        for (UIButton *btn in btnArr) {
            btn.selected =NO;
            sender.selected = YES;
        }
        //if (sender.tag == 602 || sender.tag == 603 || sender.tag == 601) {
        if (sender.tag == 602 || sender.tag == 603 ) {
            if(maskview) {
                [maskview removeFromSuperview];
                maskview =nil;
            }
            maskview = [[UIView alloc]initWithFrame:CGRectMake(0, Popviewheight * 0.08 , Popviewwidth, Popviewheight * 0.87 -20)];
            maskview.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.9];
            [self.mapView addSubview:maskview];
             maskview.hidden = NO;
        }
        else{
            [maskview removeFromSuperview];
             maskview.hidden = YES;
             maskview = nil;
            if (sender.tag ==601) {
                 FSJPeopleManagimentviewController* people = [[FSJPeopleManagimentviewController alloc]init];
                people.InfoType = FSJManage;
                people.showPop = YES;
               [self.navigationController pushViewController:people animated:YES];
                for (UIButton *btn in btnArr) {
                    btn.selected =NO;
                    if (btn.tag == 600) {
                        btn.selected = YES;
                    }
                }
            }
        }
       [[WBPopMenuSingleton shareManager]hideMenu];
//        if (sender.tag == 601 && sender.selected == YES) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self createPopwithName:jiankongArr andImg:jiankongimgArr andtag:601];
//             });
//        }
        if (sender.tag == 602 && sender.selected == YES) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self createPopwithName:shebeiArr andImg:shebeiimgArr andtag:602];
            });
        }
        if (sender.tag == 603 && sender.selected == YES) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self createPopwithName:gaojingArr andImg:gaojingimgArr andtag: 603];
            });
        }
        if (sender.tag == 600 ) {
        }
    }
}
- (void)createPopwithName:(NSArray *)nameArr andImg:(NSArray *)imgArr andtag:(NSInteger) btntag{
    NSMutableArray *obj = [NSMutableArray array];
    for (NSInteger i = 0; i < nameArr.count; i++) {
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.image = imgArr[i];
        info.title = nameArr[i];
        [obj addObject:info];
    };
    [[WBPopMenuSingleton shareManager]showPopMenuSelecteWithFrame:200
                                                             item:obj
                                                           action:^(NSInteger index) {
         if ([nameArr[index] isEqualToString:@"统计"]) {
             FSJTongjiViewController * tongji = [[FSJTongjiViewController alloc]init];
           [self.navigationController pushViewController:tongji animated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                for (UIButton *btn in btnArr) {
                    if (btn.tag == btntag) {
                        btn.selected = NO;
                        [self btnClicked:btn];
                    }
                }
            
            });
         }
         else{
              FSJPeopleManagimentviewController* people = [[FSJPeopleManagimentviewController alloc]init];
         if ([nameArr[index] isEqualToString:@"人员信息管理"]) {
                    people.InfoType = PeopleManage;
           };
            if ([nameArr[index] isEqualToString:@"发射站管理"]) {
                     people.InfoType = StationManage;
            };
             if ([nameArr[index] isEqualToString:@"发射机管理"]) {
                     people.InfoType = FSJManage;
            };
            if ([nameArr[index] isEqualToString:@"警告查询"]) {
                     people.InfoType = Warned;
            };
            if (btntag == 601) {
                        return;
                  }
            [self.navigationController pushViewController:people animated:YES];
             for (UIButton *btn in btnArr) {
                 if (btn.tag == btntag) {
                     btn.selected = NO;
                     [self btnClicked:btn];
                 }
             }
         }
    }TopView:self.mapView alpha:0];
}
#pragma mark --搜索栏
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (self.mytableView) {
        self.mytableView.hidden = YES;
        [self.mytableView removeFromSuperview];
        self.mytableView = nil;
    }
    showWarn = NO;
    [self.mapView removeAnnotations:stationError];
    [self.mapView removeAnnotations:stationNormal];
    if ([mainSearchbar.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入查询内容"];
        return;
    }
    else{
        //[self removeLayer];
        //[self getallstationInfoWith:mainSearchbar.text andtype:Allstationquery anddicparameter:@"keyword"andShowAnno:YES andFirst:NO];
    }
    [self.view endEditing:YES];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    mainSearchbar.text = @"";
    self.LenovoTableView.hidden = YES;
    self.LenovoTableView = nil;
    [self removeAnno];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"change");
         [self.mapView removeAnnotations:quanjuArr];
    if (quanjuArr.count >0) {
        [quanjuArr removeAllObjects];
    }
    if (self.lenovoTableArray.count >0) {
        [self.lenovoTableArray removeAllObjects];
    }
    if (self.LenovoTableView) {
        [self.LenovoTableView removeFromSuperview];
        self.LenovoTableView = nil;
    }
    if (self.mytableView) {
        self.mytableView.hidden = YES;
        [self.mytableView removeFromSuperview];
        self.mytableView = nil;
    }
    showWarn = NO;
    [self.mapView removeAnnotations:stationError];
    [self.mapView removeAnnotations:stationNormal];
    
    for (FSJOneFSJ *model in allname) {
        if ([model.name containsString:searchText]) {
            NSLog(@"%@",model.name);
            [self.lenovoTableArray addObject:model.name];
        }
    }
    if (self.lenovoTableArray.count > 0) {
        //self.LenovoTableView.hidden = NO;
        [self removeLayer];
    }
    else{
        NSString *str = @"没有搜索到相关内容";
        [self.lenovoTableArray addObject:str];
        //self.LenovoTableView.hidden = YES;
    }
    [self.view bringSubviewToFront:self.LenovoTableView];
    [self.LenovoTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.0];
    [self.mapView addSubview:self.LenovoTableView];
}
- (void)removeAnno{
    showPop = NO;
    if (self.mytableView) {
        self.mytableView.hidden = YES;
        [self.mytableView removeFromSuperview];
        self.mytableView = nil;
    }
    showWarn = YES;
    showCity = YES;
    showProvince = YES;
    if ([staticareaType isEqualToString:@"1"]) {
        if (self.mapView.zoomLevel >=SecondLevel && self.mapView.zoomLevel < ThirdtLevel ) {
            [self.mapView addOverlays:cityoverlayNor];
            [self.mapView addOverlays:cityoverlayErr];
        }
        if ( self.mapView.zoomLevel >= ThirdtLevel) {
            
            [self.mapView addAnnotations:stationNormal];
            [self.mapView addAnnotations:stationError];
            
        }
        if(self.mapView.zoomLevel < SecondLevel) {
            
            [self.mapView addOverlays:overlayNor];
            [self.mapView addOverlays:overlayEor];
        }
    }
    if ([staticareaType isEqualToString:@"2"]) {
        showCity = NO;
        if ( self.mapView.zoomLevel >= ThirdtLevel) {
            [self.mapView addAnnotations:stationNormal];
            [self.mapView addAnnotations:stationError];
        }
        else{
            [self.mapView addOverlays:cityoverlayNor];
            [self.mapView addOverlays:cityoverlayErr];
        }
    }
    if ([staticareaType isEqualToString:@"3"]) {
        [self.mapView addAnnotations:stationNormal];
        [self.mapView addAnnotations:stationError];
    }
    [self.mapView removeAnnotations:quanjuArr];
    [self.view endEditing:YES];
}
- (void)removeLayer{
    showPop = YES;
    // if (self.mapView.zoomLevel >=SecondLevel && self.mapView.zoomLevel < ThirdtLevel) {
    [self.mapView removeOverlays:cityoverlayNor];
    [self.mapView removeOverlays:cityoverlayErr];
    // }
    // if ( self.mapView.zoomLevel >= ThirdtLevel) {
    [self.mapView removeAnnotations:stationNormal];
    [self.mapView removeAnnotations:stationError];
    // }
    // if(self.mapView.zoomLevel < SecondLevel) {
    [self.mapView removeOverlays:overlayNor];
    [self.mapView removeOverlays:overlayEor];
    // }
    //     showWarn = NO;
    //     showCity = NO;
    //     showProvince = NO;
}
#pragma mark --行政区搜索
- (void)searchWithModelwith:(NSDictionary *)dic{

    showProvince = YES;
    [FSJNetworking networkingGETWithActionType:NationalarmStatus requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJUserInfo *model = [FSJUserInfo initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"]) {
            for (NSDictionary *dic in model.list) {
                FSJResultList *listmodel = [FSJResultList initWithDictionary:dic];
                [nameIdDic addObject:listmodel];
                [namelist addObject:listmodel.name];
               //[[EGOCache globalCache]setString:listmodel.alarmTotal forKey:listmodel.areaId];
                if ([listmodel.alarmTotal isEqualToString:@"0"]) {
                    [listNormal addObject:listmodel.name];
                    [listidNormal addObject:listmodel.areaId];
                    NSLog(@"正常 == %@",listmodel.name);
                }
                else{
                    [listError   addObject:listmodel.name];
                    [listidError addObject:listmodel.areaId];
                    NSLog(@"警告 == %@",listmodel.name);
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self searchWithArr:listError];
                [self searchWithArr:listNormal];
            });
            //获取各个城市信息
            [self getCtiyWithID:listidError andName:listError];
            [self getCtiyWithID:listidNormal andName:listNormal];
            NSLog(@"查询成功 ==== %@",model.status);
        }
      
        else{
            [SVProgressHUD showErrorWithStatus:model.message];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error);
        NSArray *array = error.userInfo.allValues;
        NSHTTPURLResponse *response = array[0];
        if (response.statusCode ==401 ) {
            [SVProgressHUD showInfoWithStatus:AccountChanged];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.618 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[EGOCache globalCache]clearCache];
                [[EGOCache globalCache]setObject:[NSNumber numberWithBool:NO] forKey:@"Login" withTimeoutInterval:0];
            });
        }
    }];
}
#pragma mark --获取地级市信息
- (void)getCtiyWithID:(NSArray *)arrID andName:(NSArray *)arrName{
    if (allcityModel.count >0) {
         [allcityModel removeAllObjects];
    }
    for (int i = 0; i < arrID.count; i++) {
        NSMutableArray *modelArr = @[].mutableCopy;
        NSDictionary *requestdic = @{@"areaId":arrID[i],@"areaType":@"2",@"userId":staticuserId,@"jwt":staticJwt};
        [FSJNetworking networkingGETWithActionType:AreaalarmStatus requestDictionary:requestdic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
            FSJUserInfo *model = [FSJUserInfo initWithDictionary:responseObject];
            if ([model.status isEqualToString:@"200"]) {
//                [cityNormal   removeAllObjects];
//                [cityError    removeAllObjects];
//                [cityidError  removeAllObjects];
//                [cityidNormal removeAllObjects];
                 NSMutableArray *tcityNor = @[].mutableCopy;
                 NSMutableArray *tcityEor = @[].mutableCopy;
                 NSMutableArray *tcityidNor = @[].mutableCopy;
                 NSMutableArray *tcityidEor = @[].mutableCopy;
                for (NSDictionary *dic in model.list) {
                    FSJOneCity *cityModel = [FSJOneCity initWithDictionary:dic];
                    [allcityName  addObject:cityModel.name];
                    [allcityModel addObject:cityModel];
                    //if([cityModel.name isEqualToString:result.address]) {
                        NSDictionary *requestdic = @{@"areaId":cityModel.areaId,@"areaType":@"3",@"userId":staticuserId,@"jwt":staticJwt};
                        [self getCityStationWith:requestdic and:NO];
                    //}
                    //[modelArr addObject:cityModel];
                    [[EGOCache globalCache]setString:cityModel.alarmTotal forKey:cityModel.areaId];
                    
                    if ([cityModel.alarmTotal isEqualToString:@"0"]) {
                        [tcityNor   addObject:cityModel.name];
                        [tcityidNor addObject:cityModel.areaId];
                    }
                    else{
                        [tcityEor   addObject:cityModel.name];
                        [tcityidEor addObject:cityModel.areaId];
                    }
                }
                [cityNormal   addObjectsFromArray:tcityNor];
                [cityError    addObjectsFromArray:tcityEor];
                [cityidError  addObjectsFromArray:tcityidEor];
                [cityidNormal addObjectsFromArray:tcityidNor];
                //[[EGOCache globalCache]setObject:modelArr forKey:arrName[i]];
                [modelArr removeAllObjects];
                //保持每个省级下面城市错误数
                [[EGOCache globalCache]setString:[NSString stringWithFormat:@"%ld",cityError.count] forKey:arrID[i]];
                NSDictionary *dictname = @{keyCityNor:tcityNor,keyCityError:tcityNor,keyCityNorID:tcityidNor,keyCityErrorID:tcityidEor};
                [self searchWithArr:tcityNor];
                [self searchWithArr:tcityEor];
                [[EGOCache globalCache]setObject:dictname forKey:arrName[i]];
//                if ([staticareaType isEqualToString:@"2"]) {
//                    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//                    geocodeSearchOption.address = staticName;
//                    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
//                    if(flag)
//                    {
//                        NSLog(@"geo检索发送成功");
//                    }
//                    else
//                    {
//                        NSLog(@"geo检索发送失败");
//                    }
//                }
            }
          
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            NSArray *array = error.userInfo.allValues;
            NSHTTPURLResponse *response = array[0];
            if (response.statusCode ==401 ) {
                [SVProgressHUD showInfoWithStatus:AccountChanged];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.618 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [[EGOCache globalCache]clearCache];
                    [[EGOCache globalCache]setObject:[NSNumber numberWithBool:NO] forKey:@"Login" withTimeoutInterval:0];
                });
            }
        }];
    }
    
    
}
- (void)searchWithArr:(NSMutableArray *)array{
    for (int i = 0 ; i < array.count; i ++) {
        BMKDistrictSearchOption *option = [[BMKDistrictSearchOption alloc] init];
        option.city = array[i];
        BMKDistrictSearch *search = [[BMKDistrictSearch alloc]init];
        search.delegate = self;
        [searchList addObject:search];
        districtSearch = [search districtSearch:option];
        //BOOL districtSearch;
        if (districtSearch) {
            NSLog(@"district检索发送成功");
        } else  {
            NSLog(@"district检索发送失败");
            break;
        }
        option = nil;
        search = nil;
    }
}
#pragma mark - 行政区搜索结果
- (void)onGetDistrictResult:(BMKDistrictSearch *)searcher result:(BMKDistrictResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"onGetDistrictResult error: %d", error);
    if (error == BMK_SEARCH_NO_ERROR) {
        [overlayEor  addObjectsFromArray:[self createPolgonWith:listError andId:listidError and:result and:@"1" and:YES]];
        [overlayNor  addObjectsFromArray:[self createPolgonWith:listNormal andId:listidNormal and:result and:@"0" and:YES]];
        //NSDictionary *dic = (NSDictionary *)[[EGOCache globalCache]objectForKey:staticAreaname];
        if ([staticareaType isEqualToString:@"1"]) {
            showCity = YES;
            [cityoverlayErr  addObjectsFromArray:[self createPolgonWith:cityError andId:cityidError and:result and:@"1" and:NO]];
            [cityoverlayNor  addObjectsFromArray:[self createPolgonWith:cityNormal andId:cityNormal and:result and:@"0" and:NO]];
        }
        if ([staticareaType isEqualToString:@"2"]) {
            self.mapView.centerCoordinate = result.center;
            startpoint = result.center;
            [cityoverlayErr  addObjectsFromArray:[self createPolgonWith:cityError andId:cityidError and:result and:@"1" and:YES]];
            [cityoverlayNor  addObjectsFromArray:[self createPolgonWith:cityNormal andId:cityNormal and:result and:@"0" and:YES]];
//            [cityoverlayErr addObjectsFromArray:[self createPolgonWith:[dic objectForKey:keyCityError] andId:[dic objectForKey:keyCityErrorID] and:result and:@"1" and:[staticareaType isEqualToString:@"2"]]];
//            
//            [cityoverlayNor addObjectsFromArray:[self createPolgonWith:[dic objectForKey:keyCityNor   ] andId:[dic objectForKey:keyCityNorID] and:result and:@"0" and:[staticareaType isEqualToString:@"2"]]];
//            
        }
   
    }
    
}
- (NSMutableArray *)createPolgonWith:(NSArray *)array andId:(NSArray *)arrid and:(BMKDistrictResult *)result and:(NSString *)status and:(BOOL)bol{
    NSMutableArray *arr = @[].mutableCopy;
    
    for (int i = 0; i < array.count; i ++) {
        if ([result.name isEqualToString:array[i]]) {
            BMKPolygon * tempPolgon ;
            tempPolgon = [FSJTransPoint transferPathStringToPolygon:result.paths];
            tempPolgon.title = status;
            tempPolgon.subtitle = arrid[i];
            [arr addObject:tempPolgon];
            if (bol == YES ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView addOverlay:tempPolgon];
                });
            }
        }
    }
    return arr;
}
#pragma mark --警告区域图层
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolygon class]]) {
        BMKPolygonView *polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        if ([overlay.title isEqualToString:@"1"]) {
            polygonView.strokeColor = WarnStokeColor;
            polygonView.fillColor = WarnFillColor;
        }
        else{
            polygonView.strokeColor = NorStokeColor;
            polygonView.fillColor = NorFillColor;
        }
        polygonView.lineWidth = 1;
        polygonView.lineDash = NO;
        return polygonView;
    }
    return nil;
}
#pragma mark - BMKMapViewDelegate
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"BMKMapView控件初始化完成" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    //[alert show];
    //alert = nil;
    self.mapView.compassPosition = CGPointMake(15, 90);
}
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"地图缩放等级 == %lf",self.mapView.zoomLevel);
    if (self.mapView.zoomLevel >=SecondLevel) {
        
        showProvince = NO;
        [self.mapView removeOverlays:overlayNor];
        [self.mapView removeOverlays:overlayEor];
        if (showCity == YES &&!showPop ) {
            [self.mapView addOverlays:cityoverlayNor];
            [self.mapView addOverlays:cityoverlayErr];
          
            showCity = NO;
        }
        if ( self.mapView.zoomLevel >= ThirdtLevel) {
            //self.mytableView.hidden = NO;
            showCity =YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mapView removeOverlays:cityoverlayNor];
                [self.mapView removeOverlays:cityoverlayErr];
            });
            if (showWarn == YES) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView addAnnotations:stationNormal];
                    [self.mapView addAnnotations:stationError];
                });
                //showWarn = NO;
            }
        }
        else{
           // [self.mytableView removeFromSuperview];
           // self.mytableView = nil;
            if ([staticareaType isEqualToString:@"1"] || [staticareaType isEqualToString:@"2"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
              //   self.mytableView.hidden = YES;
                [self.mapView removeAnnotations:stationError];
                [self.mapView removeAnnotations:stationNormal];
            });
                }
        }
    }
    else{
        if ([staticareaType isEqualToString:@"1"]) {
             showCity = YES;
        }
        //showCity = YES
        if ([staticareaType isEqualToString:@"1"]) {
            [self.mapView removeOverlays:cityoverlayErr];
            [self.mapView removeOverlays:cityoverlayNor];
            [self.mapView removeAnnotations:stationError];
            [self.mapView removeAnnotations:stationNormal];
        }
        if ([staticareaType isEqualToString:@"2"]) {
            [self.mapView removeAnnotations:stationError];
            [self.mapView removeAnnotations:stationNormal];
        }
        
        if (!showProvince &&!showPop) {
            [self.mapView addOverlays:overlayEor];
            [self.mapView addOverlays:overlayNor];
            showProvince = YES;
        }
    }
}
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{

    
}
- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
//    if (showPop) {
//        return;
//    }
//    else{
//    if (self.mapView.zoomLevel < SecondLevel) {
//        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
//        reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
//        [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
//        showProvince = NO;
//    }
//    if (self.mapView.zoomLevel  < ThirdtLevel && self.mapView.zoomLevel >= SecondLevel) {
//        BMKReverseGeoCodeOption *reverseGeocodeSearchOptionCity = [[BMKReverseGeoCodeOption alloc]init];
//        reverseGeocodeSearchOptionCity.reverseGeoPoint = coordinate;
//        [_geocodesearchCity reverseGeoCode:reverseGeocodeSearchOptionCity];
//        }
//    }
}
#pragma mark -- 反向地理编码 获得点击地区坐标
- (void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
//    if (searcher == _geocodesearchCity){
//        if (error == 0) {
//            NSLog(@"%@",result.address);
//            for (NSString *str in allcityName) {
//                if ([result.address containsString:str]) {
//                    NSLog(@"%@",str);
//                    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//                    geocodeSearchOption.address = str;
//                    BOOL flag = [_geocodesearchCity geoCode:geocodeSearchOption];
//                    if(flag)
//                    {
//                        NSLog(@"geocity检索发送成功");
//                    }
//                    else
//                    {
//                        NSLog(@"geocity检索发送失败");
//                    }
//                }
//                else{
//                }
//            }
//        }
//        else{
//            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%u",error]];
//            NSLog(@"错误代码 == %u",error);
//        }
//    }
//    if (searcher == _geocodesearch) {
//        if (error == 0) {
//            NSLog(@"%@",result.address);
//            for (NSString *str in namelist) {
//                if ([result.address hasPrefix:str]) {
//                    self.mapView.centerCoordinate = result.location;
//                    NSLog(@"%@",str);
//                    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//                    geocodeSearchOption.address = str;
//                    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
//                    if(flag)
//                    {
//                        NSLog(@"geo检索发送成功");
//                    }
//                    else
//                    {
//                        NSLog(@"geo检索发送失败");
//                    }
//                }
//                else {
//                }
//            }
//        }else{
//            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%u",error]];
//            NSLog(@"错误代码 == %u",error);
//        }
//    }
}
#pragma mark -- 正向地理编码
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
//    for (FSJResultList *tempModle in nameIdDic) {
//        if ([tempModle.name isEqualToString:result.address]) {
//            [self getCtiyWithID:@[tempModle.areaId] andName:@[tempModle.name]];
//            
//        }
//    }
//    if (searcher == _geocodesearch) {
//        if (stationArr.count >0 || stationError.count>0 || stationNormal.count>0 || cityoverlayErr.count || cityoverlayNor.count > 0 || cityError.count > 0 || cityNormal.count > 0) {
//            [stationArr     removeAllObjects];
//            [stationError   removeAllObjects];
//            [stationNormal  removeAllObjects];
//            [cityoverlayNor removeAllObjects];
//            [cityoverlayErr removeAllObjects];
//            [cityNormal     removeAllObjects];
//            [cityError      removeAllObjects];
//        }
//        NSDictionary *dict = (NSDictionary *)[[EGOCache globalCache]objectForKey:result.address];
//        staticAreaname = result.address;
//        _mapView.centerCoordinate = result.location;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.mapView.zoomLevel = SecondLevel;
//            [self.mapView removeOverlays:overlayNor];
//            [self.mapView removeOverlays:overlayEor];
//        });
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self searchWithArr:[dict objectForKey:keyCityError]];
//            [self searchWithArr:[dict objectForKey:keyCityNor]];
//        });
//        showCity = YES;
//    }
//    if (searcher == _geocodesearchCity) {
//       // self.mapView.centerCoordinate = result.location;
//        for (FSJOneCity *cityModel in allcityModel) {
//            
//            if ([cityModel.name isEqualToString:result.address]) {
//                
//                NSDictionary *requestdic = @{@"areaId":cityModel.areaId,@"areaType":@"3",@"userId":staticuserId,@"jwt":staticJwt};
//                [self getCityStationWith:requestdic and:YES];
//            }
//        }
//        NSLog(@"address = %@, 坐标 = %lf %lf",result.address,result.location.longitude,result.location.latitude);
//    }
}
#pragma mark -- 获得发射站数据
- (void)getCityStationWith:(NSDictionary *)dic and:(BOOL)show{
        showWarn = YES;

    [FSJNetworking networkingGETWithActionType:AreaalarmStatus requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        if (responseObject) {
            FSJUserInfo *user = [FSJUserInfo initWithDictionary:responseObject];
            //获取警告数量
            //warnNumber = (int)[user.alarmTotal integerValue];
            NSMutableArray *tstationArr = @[].mutableCopy;
            
            if ([user.status isEqualToString:@"200"]) {
                for (NSDictionary *dic in user.list) {
                    FSJResultList *listmodel = [FSJResultList initWithDictionary:dic];
                    [tstationArr addObject:listmodel];
                }
                [self.mapView removeAnnotations:quanjuArr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView removeOverlays:cityoverlayErr];
                    [self.mapView removeOverlays:cityoverlayNor];
                    [self addAnimatedAnnotationWith:tstationArr and:show];
                    if (show) {
                        CLLocationCoordinate2D coor;
                        FSJResultList *model =  stationArr.firstObject;
                        coor.latitude = model.lat.floatValue;
                        coor.longitude = model.lon.floatValue;
                        self.mapView.centerCoordinate = coor;
                        static dispatch_once_t onceToken;
                        dispatch_once(&onceToken, ^{
                            startpoint = coor;
                        });
                        
                    }
                });
                
                [stationArr addObjectsFromArray:tstationArr];
                [tstationArr removeAllObjects];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    if (show) {
//                        self.mapView.zoomLevel = ForthLevel ;
//                    }
//                });
            }
            else{
                NSLog(@"%@",user.message);
            }
        }
        else{
            NSLog(@"%@",responseObject);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        NSArray *array = error.userInfo.allValues;
        NSHTTPURLResponse *response = array[0];
        if (response.statusCode ==401 ) {
            [SVProgressHUD showInfoWithStatus:AccountChanged];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.618 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[EGOCache globalCache]clearCache];
                [[EGOCache globalCache]setObject:[NSNumber numberWithBool:NO] forKey:@"Login" withTimeoutInterval:0];
            });
        }
    }];
}
#pragma mark -- 添加标注 Annotation
- (void)addAnimatedAnnotationWith:(NSArray *)array and:(BOOL)show{
    for (FSJResultList *model in stationArr) {
        if ([model.status isEqualToString:@"0"]) {
            BMKPointAnnotation *annotataion = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            annotataion.title = @"zc";
            annotataion.subtitle = model.stationId;
            coor.latitude = model.lat.floatValue;
            coor.longitude = model.lon.floatValue;
            annotataion.coordinate = coor;
            if (show) {
                [self.mapView addAnnotation:annotataion];
            }
            [stationNormal addObject:annotataion];
        }
        if([model.status isEqualToString:@"1"]){
            BMKPointAnnotation *annotataion = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = model.lat.floatValue;
            coor.longitude = model.lon.floatValue;
            annotataion.coordinate = coor;
            annotataion.title = @"gj";
            annotataion.subtitle = model.stationId;
            if (show) {
                 [self.mapView addAnnotation:annotataion];
            }
            [stationError addObject:annotataion];
        }
    }
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation.title isEqualToString:@"zc"]) {
        for (FSJResultList *tempmodel in stationArr) {
            if ([tempmodel.stationId isEqualToString:annotation.subtitle]){
        NSString *AnnotationViewID1 = tempmodel.name;
        MyAnimatedAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID1];
             //annotationView.title = tempmodel.name;
             annotationView.canShowCallout = NO;
        }
        NSMutableArray *images = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"APPfashezhan"]];
        [images addObject:image];
        annotationView.annotationImages = images;
        return annotationView;
            }
        }
    }
    if ([annotation.title isEqualToString:@"gj"]) {
        for (FSJResultList *tempmodel in stationArr) {
            if ([tempmodel.stationId isEqualToString:annotation.subtitle]){
        NSString *AnnotationViewID2 = tempmodel.name;
        MyAnimatedAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID2];
            annotationView.canShowCallout = NO;
        }
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"APPfashezhan%d",i]];
            [images addObject:image];
        }
        annotationView.annotationImages = images;
        return annotationView;
            }
        }
    }
    if ([annotation.title isEqualToString:@"0"]) {
        NSString *AnnotationViewID1 = @"AnimatedAnnotation1";
        MyAnimatedAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID1];
            annotationView.canShowCallout = NO;
        }
        NSMutableArray *images = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"APPgreen"]];
        [images addObject:image];
        annotationView.annotationImages = images;
        return annotationView;
    }
    if ([annotation.title isEqualToString:@"1"]) {
        NSString *AnnotationViewID1 = @"AnimatedAnnotation1";
        MyAnimatedAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID1];
            annotationView.canShowCallout = NO;
        }
        NSMutableArray *images = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"APPred"]];
        [images addObject:image];
        annotationView.annotationImages = images;
        return annotationView;
    }
    if ([annotation.title isEqualToString:@"2"]) {
        NSString *AnnotationViewID1 = @"AnimatedAnnotation1";
        MyAnimatedAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID1];
            annotationView.canShowCallout = NO;
        }
        NSMutableArray *images = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"APPyellow"]];
        [images addObject:image];
        annotationView.annotationImages = images;
        return annotationView;
    }
    if ([annotation.title isEqualToString:@"3"]) {
        NSString *AnnotationViewID1 = @"AnimatedAnnotation1";
        MyAnimatedAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID1];
            annotationView.canShowCallout = NO;
        }
        NSMutableArray *images = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"APPhui"]];
        [images addObject:image];
        annotationView.annotationImages = images;
        return annotationView;
    }
    return nil;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    //[self getallstationInfoWith:view.annotation.title];
    NSString *lat = [NSString stringWithFormat:@"%lf",view.annotation.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%lf",view.annotation.coordinate.longitude];
    NSLog(@"annotion == %@ %@",[lon substringToIndex:8],[lat substringToIndex:7]);
    
    if ([view.annotation.title isEqualToString:@"zc"] ||  [view.annotation.title isEqualToString:@"gj"]) {
        for (FSJResultList *tempmodel in stationArr) {
            if ([tempmodel.stationId isEqualToString:view.annotation.subtitle]) {
                //if ([[tempmodel.lon substringToIndex:8] isEqualToString:[lon substringToIndex:8]] || [[tempmodel.lat substringToIndex:7] isEqualToString:[lat substringToIndex:7]]) {
                NSLog(@"标注 == %@ %@",[tempmodel.lon substringToIndex:8],[tempmodel.lat substringToIndex:7]);
                [self getallstationInfoWith:tempmodel.stationId andtype:Allstationquery anddicparameter:@"sid"andShowAnno:NO andFirst:NO];
                tableViewTitle = tempmodel.name;
            }
        }
    }
    else{
    for (FSJOneFSJ *tempmodel in allname) {
        if ([tempmodel.stationId isEqualToString:view.annotation.subtitle] ) {
            NSLog(@"全局标注 == %@ %@",[tempmodel.lon substringToIndex:8],[tempmodel.lat substringToIndex:7]);
            FSJPeopleManagerDetailViewController *detail = [[FSJPeopleManagerDetailViewController alloc]init];
            detail.DetailInfoType = StationManageDetail;
            detail.managerID = tempmodel.stationId;
            [self.navigationController pushViewController:detail animated:YES];
            //return;
        }
    }
    }
    //[_mapView deselectAnnotation:view.annotation animated:NO];
}
#pragma mark -- 查看发射机下面的所有发射机信息
- (void)getallstationInfoWith:(NSString *)ID andtype:(NetworkConnectionActionType)type anddicparameter:(NSString *)str andShowAnno:(BOOL)show andFirst:(BOOL)first {
//    if (allname.count >0) {
//        [allname removeAllObjects];
//    }
    if (allsite.count >0) {
        [allsite removeAllObjects];
    }
    if (self.mytableView) {
        self.mytableView.frame = CGRectZero;
        [self.mytableView removeFromSuperview];
    }
    if (!show && !first) {
        [self  createTableview];
    }    
   
    NSDictionary *dic = @{str:ID,@"pageSize":@"8",@"pageNo":@"1",@"jwt":staticJwt};
    [FSJNetworking networkingGETWithActionType:type requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJAllFSJ *model = [FSJAllFSJ initWithDictionary:responseObject];
        NSLog(@"%@",model.message);
        if ([model.status isEqualToString:@"200"]) {
           
            for (NSDictionary *dic in model.list) {
                FSJOneFSJ *model = [FSJOneFSJ initWithDictionary:dic];
                NSLog(@"%@ %@ %@ statue ==%@",model.name ,model.masterPr, model.masterPo, model.status);
                [allsite addObject:model];
                
                if (first) {
                    [allname addObject:model];
                }
                
                }
            [[EGOCache globalCache]setObject:responseObject forKey:@"array"];
            
            if (show && !first) {
                [self addAnnotataionOnmapWith:allsite];
                
            }
            else{
                 //dispatch_async(dispatch_get_main_queue(), ^{
                  [self.mytableView reloadData];
                 //});
                 //[LGProgressHud hideAllHudInView:self.mytableView animated:HudAnimatedTypeNone];
            }
        }

    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSArray *array = error.userInfo.allValues;
        NSHTTPURLResponse *response = array[0];
        if (response.statusCode ==401 ) {
            [SVProgressHUD showInfoWithStatus:AccountChanged];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.618 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[EGOCache globalCache]clearCache];
                [[EGOCache globalCache]setObject:[NSNumber numberWithBool:NO] forKey:@"Login" withTimeoutInterval:0];
            });
        }
    }];
}
#pragma mark -- 添加全局标注
- (void)addAnnotataionOnmapWith:(NSArray *)array{
   // showPop = YES;
    if (quanjuArr.count >0) {
        [quanjuArr removeAllObjects];
    }
    NSLog(@"全局标注数量为%lu",(unsigned long)array.count);
    for (FSJOneFSJ *model in array) {
        BMKPointAnnotation *annotataion = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = model.lat.floatValue;
        coor.longitude = model.lon.floatValue;
        annotataion.coordinate = coor;
        self.mapView.centerCoordinate = coor;
        if ([model.status isEqualToString:@"0"]) {
            annotataion.title = @"zc";
        }
        if([model.status isEqualToString:@"1"]){
            annotataion.title = @"gj";
        }
        annotataion.subtitle = model.stationId;
        [self.mapView addAnnotation:annotataion];
        [quanjuArr addObject:annotataion];
        NSLog(@"%@",model.name);
    }
}
#pragma mark -- 配置Tableview
- (UITableView *)mytableView{
    if (_mytableView == nil) {
        _mytableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                _mytableView.allowsSelection =YES;
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        [_mytableView addGestureRecognizer:swipup];
        [_mytableView addGestureRecognizer:swipdown];
    }
    return _mytableView;
}
- (void)createTableview{
    if (self.mytableView) {
        [self.mytableView removeFromSuperview];
    }
    self.mytableView.frame = CGRectMake(0, tableviewY, WIDTH, tableviewHeight);
    self.mytableView.scrollEnabled = NO;
    [self.mapView insertSubview:self.mytableView belowSubview:tabbarBg];
    // [self.view insertSubview:self.mytableView belowSubview:maskview];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return  2;
    }
    else{
        return 0.1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }
    return 45;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.mytableView) {
        return 2;
    }
    else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (tableView == self.mytableView) {
    switch (sectionIndex) {
        case 0:
            return 1;
            break;
        case 1:
            if (allsite.count == 0) {
                return 1;
            }
            else{
                return allsite.count;
            }
            
            break;
        default:
            return 0;
            break;
        }
    }else{
        return self.lenovoTableArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mytableView) {
    if (indexPath.section == 0) {

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HEADER"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HEADER"];
        }
        cell.backgroundColor = SystemBlueColor;
        cell.textLabel.text = [NSString stringWithFormat:@"%@",tableViewTitle];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor =SystemWhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell addGestureRecognizer:cellpan];
        return cell;
    }
    else{
       
        if (allsite.count == 0) {
            FSJNoDataTableViewCell *cell = [FSJNoDataTableViewCell initWith:tableView];
            cell.TopLabel.textAlignment = NSTextAlignmentCenter;
            cell.TopLabel.text = @"无数据";
            cell.userInteractionEnabled = NO;
            return cell;
        }
        else{
            FSJOneFSJTableViewCell *cell = [FSJOneFSJTableViewCell initWith:tableView];
            cell.item = allsite[indexPath.row];;
            return cell;
        }
      }
   }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        }
        cell.textLabel.text = self.lenovoTableArray[indexPath.row];
        return cell;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"1");
    if (tableView == self.mytableView) {
    if (indexPath.section == 0) {
//        [UIView animateWithDuration:1 animations:^{
//            CGRect rect = self.mytableView.frame;
//            if (rect.origin.y ==  HEIGH-50) {
//                rect.origin.y -= moveDistance-50;
//                rect.size.height += tableviewHeight-50;
//            }
//            else{
//                rect.origin.y = HEIGH-50;
//                rect.size.height = 50;
//            }
//            self.mytableView.frame = rect;
//        }];
//        [self.mytableView removeFromSuperview];
//         self.mytableView = nil;
        return;
    }
    else{
        FSJOneFSJ *model = allsite[indexPath.row];
        FSJPeopleManagerDetailViewController *detail = [[FSJPeopleManagerDetailViewController alloc]init];
        detail.DetailInfoType = FSJManageDetail;
        detail.managerID = model.transId;
        [self.navigationController pushViewController:detail animated:YES];
    }
}
    else{
        NSMutableArray *arr = @[].mutableCopy;
        for (FSJOneFSJ *model in allname) {
            if ([model.name isEqualToString:self.lenovoTableArray[indexPath.row]]) {
                NSLog(@"%@",model.name);
                self.LenovoTableView.hidden = YES;
                [arr addObject:model];
            }
        }
         [self addAnnotataionOnmapWith:arr];
         [self.view endEditing:YES];
         mainSearchbar.text = self.lenovoTableArray[indexPath.row];
    }
    //取消选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -- 导航
- (void)UserInfo:(UIButton *)sender {
    
       FSJMeViewController *me = [[FSJMeViewController alloc]init];
        me.jwtStr = staticJwt;
        me.VersionStr = versionStr;
        [self.navigationController pushViewController:me animated:YES];
        [[WBPopMenuSingleton shareManager]hideMenu];
    // [self changeStatusWith:@[@"1/11/12/10001",@"0"]];
    NSLog(@"状态改变1");
}
//- (IBAction)MoreButton:(UIButton *)sender {
//    FSJMoreInfomationViewController *more = [[FSJMoreInfomationViewController alloc]init];
//     [self.navigationController pushViewController:more animated:YES];
//    [self changeStatusWith:@[@"1/11/12/10000",@"0"]];
//    [self changeStatusWith:@[@"1/2/3/10004",@"1"]];
//    NSLog(@"状态改变0");
//}
#pragma mark - 添加自定义的手势（若不自定义手势，不需要下面的代码）
- (void)addCustomGestures {
    /*
     *注意：
     *添加自定义手势时，必须设置UIGestureRecognizer的属性cancelsTouchesInView 和 delaysTouchesEnded 为NO,
     *否则影响地图内部的手势处理
     */
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.cancelsTouchesInView = NO;
    doubleTap.delaysTouchesEnded = NO;
    doubleTap.delegate = self;
    [self.mapView  addGestureRecognizer:doubleTap];
    /*
     *注意：
     *添加自定义手势时，必须设置UIGestureRecognizer的属性cancelsTouchesInView 和 delaysTouchesEnded 为NO,
     *否则影响地图内部的手势处理
     */
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    //singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    singleTap.delaysTouchesEnded = NO;
    //[singleTap requireGestureRecognizerToFail:doubleTap];
    cellpan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveTable:)];
    
    [self.mapView addGestureRecognizer:singleTap];
    swipdown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(removeTableview:)];
    [swipdown setDirection:UISwipeGestureRecognizerDirectionDown];
   swipup = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(addTableview:)];
    [swipup setDirection:UISwipeGestureRecognizerDirectionUp];
    swipup.delegate   = self;
    swipdown.delegate = self;
//    [self.view addGestureRecognizer:swipup];
//    [self.view addGestureRecognizer:swipdown];
//    [self.mytableView addGestureRecognizer:swipup];
//    [self.mytableView addGestureRecognizer:swipdown];
}
- (void)moveTable:(UIGestureRecognizer *)pan{
    CGPoint ppoint = [pan locationInView:_mapView];
    CGRect rect = self.mytableView.frame;
    //if (rect.origin.y == tableviewY ) {
    rect.origin.y    = ppoint.y;
    rect.size.height = HEIGH ;
    if ( ppoint.y <= HEIGH - HEIGH*0.07 - 70 && ppoint.y>20) {
         self.mytableView.frame = rect;
    }
    else if (ppoint.y > HEIGH - HEIGH*0.07 - 70){
        rect.origin.y = HEIGH - HEIGH*0.07 - 70;
         self.mytableView.frame = rect;
    }
    else if(ppoint.y<20){
        rect.origin.y = 0;
        self.mytableView.frame = rect;
    }
}
- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap {
    NSLog(@"my handleSingleTap");
    
    [maskview removeFromSuperview];
    maskview = nil;
    for (UIButton *btn in btnArr) {
        btn.selected = NO;
        if (btn.tag == 600) {
            btn.selected = YES;
        }
    }
//    [UIView animateWithDuration:1 animations:^{
//        CGRect rect = self.mytableView.frame;
//        if (rect.origin.y == HEIGH-50) {
//            return;
//        }
//        else{
//            rect.origin.y = HEIGH-50;
//            rect.size.height = 50;
//        }
//        self.mytableView.frame = rect;
//    }];
}
- (void)handleDoubleTap:(UITapGestureRecognizer *)theDoubleTap {
    NSLog(@"my handleDoubleTap");
   [[WBPopMenuSingleton shareManager]hideMenu];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)addTableview:(UISwipeGestureRecognizer *)swip{
    if (self.mytableView.frame.origin.y == 0  ) {
        return;
    }
    else{
        if (self.mytableView != nil) {
            [UIView animateWithDuration:0.6 animations:^{
                CGRect rect = self.mytableView.frame;
//if (rect.origin.y == tableviewY ) {
                    rect.origin.y    = 0;
                    rect.size.height = HEIGH - HEIGH *0.07 ;
//                }
//                else{
//                    rect.origin.y    = tableviewY;
//                    rect.size.height = tableviewHeight;
//               }
                self.mytableView.frame = rect;
            }];
        }
    }
    NSLog(@"up");
}
- (void)removeTableview:(UISwipeGestureRecognizer *)swip{
    NSLog(@"down");
    if (self.mytableView.frame.origin.y == HEIGH - HEIGH*0.07 - 70) {
        return;
    }
    else{
        if (self.mytableView) {
            [UIView animateWithDuration:1 animations:^{
                CGRect rect = self.mytableView.frame;
                if (rect.origin.y    == HEIGH - HEIGH*0.07 - 70) {
                    [self.mytableView removeFromSuperview];
                     self.mytableView = nil;
//                   rect.origin.y    =  HEIGH - HEIGH*0.07 - 70;
//                   rect.size.height =  HEIGH- tableviewY;
                }
                else{
                    rect.origin.y    = HEIGH - HEIGH*0.07 - 70;
                    rect.size.height = tableviewHeight;
                }
                self.mytableView.frame = rect;
            }];
        }
    }
}
@end
