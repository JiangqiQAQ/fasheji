//
//  FSJShebeiInfo50W.h
//  FSJ
//
//  Created by Monstar on 2017/3/17.
//  Copyright © 2017年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSJJiankongBase.h"
@interface FSJShebeiInfo50W : FSJJiankongBase
/**
 *  @brief 设备纬度指示（0：北纬，1：南纬）
 */
@property (nonatomic, copy)NSString *latFlag;
/**
 *  @brief 高度
 */
@property (nonatomic, copy)NSString *altitude;
/**
 *  @brief 产品序列号
 */
@property (nonatomic, copy)NSString *serialNum;

/**
 *  @brief 地点台站编码
 */
@property (nonatomic, copy)NSString *addrNo;
/**
 *  @brief 产品型号
 */
@property (nonatomic, copy)NSString *modelNum;
/**
 *  @brief 生产厂家
 */
@property (nonatomic, copy)NSString *manuFactory;
/**
 *  @brief 设备名称
 */
@property (nonatomic, copy)NSString *devName;
/**
 *  @brief 设备类型
 */
@property (nonatomic, copy)NSString *shebeitype;
/**
 *  @brief 设备经度
 */
@property (nonatomic, copy)NSString *lonVal;
/**
 *  @brief 设备时间
 */
@property (nonatomic, copy)NSString *devTime;
/**
 *  @brief 设备经度指示  0：东经，1：西经
 */
@property (nonatomic, copy)NSString *lonFlag;
/**
 *  @brief cpu序列号
 */
@property (nonatomic, copy)NSString *cpuNo;
/**
 *  @brief 发射机功率等级
 */
@property (nonatomic, copy)NSString *transDev;

/**
 *  @brief 硬件版本号
 */
@property (nonatomic, copy)NSString *hardwareVersion;

/**
 *  @brief 设备纬度
 */
@property (nonatomic, copy)NSString *latVal;

/**
 *  @brief id
 */
@property (nonatomic, copy)NSString *idStr;

/**
 *  @brief 软件版本号
 */
@property (nonatomic, copy)NSString *softwareVersion;

/**
 *  @brief  冷却方式
 */
@property (nonatomic, copy)NSString *devCold;


@end
@interface FSJTongxinjiekou50W : FSJJiankongBase



@property (nonatomic, copy)NSString *ipAddr;

@property (nonatomic, copy)NSString *deviceId;

@property (nonatomic, copy)NSString *macAddr;

@property (nonatomic, copy)NSString *isDHCP;

@property (nonatomic, copy)NSString *ipMask;

@property (nonatomic, copy)NSString *ipGateway;

@property (nonatomic, copy)NSString *localIp;

@end
@interface FSJZhengjistatus50W : FSJJiankongBase

@property (nonatomic, copy)NSString *tProtectTemp;

@property (nonatomic, copy)NSString *tProtectreflect;

@property (nonatomic, copy)NSString *tWorkLate;

@property (nonatomic, copy)NSString *tEnviTemp;

@property (nonatomic, copy)NSString *tRfInputVal;

@property (nonatomic, copy)NSString *tSwr;

@property (nonatomic, copy)NSString *tInputPowThreHigh;

@property (nonatomic, copy)NSString *tWorkAuto;



@property (nonatomic, copy)NSString *tInputPowThreLow;

@property (nonatomic, copy)NSString *tAmpCuur;

@property (nonatomic, copy)NSString *tRfOutputVal;

@property (nonatomic, copy)NSString *tAGC;

@property (nonatomic, copy)NSString *tRefPowTop;

@property (nonatomic, copy)NSString *tTempThre;

@property (nonatomic, copy)NSString *tCpuNo;

@property (nonatomic, copy)NSString *tOutputPow;

@property (nonatomic, copy)NSString *tRefPow;

@property (nonatomic, copy)NSString *tProtectCurrent;

@property (nonatomic, copy)NSString *tOverloadVol;

@property (nonatomic, copy)NSString *tFrontCurr;

@property (nonatomic, copy)NSString *tCommStatus;

@property (nonatomic, copy)NSString *tProtect;

@property (nonatomic, copy)NSString *tSetOutputPow;

@property (nonatomic, copy)NSString *tAmpVol;

@property (nonatomic, copy)NSString *tFrontVol;

@property (nonatomic, copy)NSString *tRfRefVal;

@property (nonatomic, copy)NSString *tmasterInputPower;

@property (nonatomic, copy)NSString *ampDrivVol;

@property (nonatomic, copy)NSString *ampPowVol;

@property (nonatomic, copy)NSString *ampTemperature;

@property (nonatomic, copy)NSString *ampInputPow;

@end


@interface FSJShebeijiegoul50W : FSJJiankongBase

@property (nonatomic, copy)NSString *inputNum;

@property (nonatomic, copy)NSString *actuatorNum;

@property (nonatomic, copy)NSString *outputNum;

@property (nonatomic, copy)NSString *amplifierNum;

@property (nonatomic, copy)NSString *powerNum;


@end


@interface FSJDianyuan50W : FSJJiankongBase

@property (nonatomic, copy)NSString *powersDirectVol;

@property (nonatomic, copy)NSString *powersDirectCurr;



@end


@interface FSJGongfang50W : FSJJiankongBase

@property (nonatomic, copy)NSString *ampPowVol;

@property (nonatomic, copy)NSString *ampTemperature;

@property (nonatomic, copy)NSString *ampOutputPow;

@property (nonatomic, copy)NSString *ampCurr2;

@property (nonatomic, copy)NSString *ampInputPow;

@property (nonatomic, copy)NSString *ampCurr1;

@property (nonatomic, copy)NSString *ampFan1;

@property (nonatomic, copy)NSString *ampFan2;

@property (nonatomic, copy)NSString *ampFan3;

@property (nonatomic, copy)NSString *ampDrivVol;

@property (nonatomic, copy)NSString *ampFan4;

@property (nonatomic, copy)NSString *ampDrivCurr;


@end
@interface FSJJiliqi50W : FSJJiankongBase

@property (nonatomic, strong)NSDictionary *rf;

@property (nonatomic, strong)NSDictionary *pipe;

@property (nonatomic, strong)NSDictionary *secondStatus;


@property (nonatomic, copy)NSString *eInputCodeRate;

@property (nonatomic, copy)NSString *eRFOutputAtte;

@property (nonatomic, copy)NSString *eRFOutputSwitch;

@property (nonatomic, copy)NSString *eSingleFreNetAddr;

@property (nonatomic, copy)NSString *eType;

@property (nonatomic, copy)NSString *eTemper;

@property (nonatomic, copy)NSString *eCpuNum;

@property (nonatomic, copy)NSDictionary *eStatus;


@property (nonatomic, copy)NSString *str0;

@property (nonatomic, copy)NSString *str1;

@property (nonatomic, copy)NSString *str2;

@property (nonatomic, copy)NSString *str3;

@property (nonatomic, copy)NSString *str4;

@property (nonatomic, copy)NSString *str5;

@property (nonatomic, copy)NSString *str6;

@property (nonatomic, copy)NSString *str7;

@property (nonatomic, copy)NSString *str8;

@property (nonatomic, copy)NSString *str9;

@property (nonatomic, copy)NSString *str10;

@property (nonatomic, copy)NSString *str11;

@property (nonatomic, copy)NSString *str12;

@property (nonatomic, copy)NSString *str13;

@property (nonatomic, copy)NSString *str14;

@property (nonatomic, copy)NSString *str15;

@property (nonatomic, copy)NSString *str16;

@property (nonatomic, copy)NSString *str17;

@property (nonatomic, copy)NSString *str18;

@end
@interface FSJJiliqiStatus50W : FSJJiankongBase

@property (nonatomic, copy)NSString *over;

@property (nonatomic, copy)NSString *SIP1;

@property (nonatomic, copy)NSString *oven;

@property (nonatomic, copy)NSString *temper;

@property (nonatomic, copy)NSString *onepps;

@property (nonatomic, copy)NSString *GPSlock;

@property (nonatomic, copy)NSString *GPS;

@property (nonatomic, copy)NSString *store;

@property (nonatomic, copy)NSString *SIP4;

@property (nonatomic, copy)NSString *SIP2;
@property (nonatomic, copy)NSString *SIP3;


@end

@interface FSJJiliqiRf50W : FSJJiankongBase

@property (nonatomic, copy)NSString *eDemoRFFreq;

@property (nonatomic, copy)NSString *eDemoRFBroadBand;

@property (nonatomic, copy)NSString *eDemoRFIQ;

@property (nonatomic, copy)NSString *eRFInputSNR;

@property (nonatomic, copy)NSString *eRFInputRate;

@property (nonatomic, copy)NSString *eRFInputStatus;

@property (nonatomic, copy)NSString *eRFInputSingleNetDelay;
@end
@interface FSJJiliqiPipe50W : FSJJiankongBase

@property (nonatomic, copy)NSString *eChOutputCarrWay;

@property (nonatomic, copy)NSString *eChOutputMixMode;

@property (nonatomic, copy)NSString *eChLevelAtte;

@property (nonatomic, copy)NSString *eChOutputLDPCQAM;

@property (nonatomic, copy)NSString *eChAddrDelay;

@property (nonatomic, copy)NSString *eChOutputFrameMode;

@property (nonatomic, copy)NSString *eChOutputPilotSwitch;

@property (nonatomic, copy)NSString *eChCodeStreamStatus;

@property (nonatomic, copy)NSString *eChOutputFreq;

@property (nonatomic, copy)NSString *eChSingleNetDelay;

@property (nonatomic, copy)NSString *eChAddrDelaySwitch;

@property (nonatomic, copy)NSString *eChOutputPNPh;

@property (nonatomic, copy)NSString *eChOutputStoneSwitch;

@property (nonatomic, copy)NSString *eChOutputNetWay;

@property (nonatomic, copy)NSString *eRFInputSingleNetDelay;
@end


@interface FSJJiliqiLunbo50W : FSJJiankongBase

@property (nonatomic, copy)NSString *eStatus;

@property (nonatomic, copy)NSString *GPS;

@property (nonatomic, copy)NSString *inputStatus1;

@property (nonatomic, copy)NSString *inputStatus2;

@property (nonatomic, copy)NSString *inputStatus3;

@property (nonatomic, copy)NSString *inputStatus4;

@property (nonatomic, copy)NSString *outStatus1;

@property (nonatomic, copy)NSString *outStatus2;

@property (nonatomic, copy)NSString *outStatus3;

@property (nonatomic, copy)NSString *outStatus4;

@property (nonatomic, copy)NSString *input1Freq;

@property (nonatomic, copy)NSString *input2Freq;

@property (nonatomic, copy)NSString *input3Freq;

@property (nonatomic, copy)NSString *input4Freq;

@property (nonatomic, copy)NSString *output1Freq;

@property (nonatomic, copy)NSString *output2Freq;

@property (nonatomic, copy)NSString *output3Freq;

@property (nonatomic, copy)NSString *output4Freq;
@end


@interface FSJTongdao50W : FSJJiankongBase

@property (nonatomic, copy)NSString *eChOutputCarrWay;

@property (nonatomic, copy)NSString *eChOutputMixMode;

@property (nonatomic, copy)NSString *eChOutputFreq;

@property (nonatomic, copy)NSString *eChLevelAtte;

@property (nonatomic, copy)NSString *eChSingleNetDelay;

@property (nonatomic, copy)NSString *eChOutputLDPCQAM;

@property (nonatomic, copy)NSString *eChOutputPNPh;

@property (nonatomic, copy)NSString *eChOutputFrameMode;

@property (nonatomic, copy)NSString *eChOutputPilotSwitch;

@property (nonatomic, copy)NSString *eChOutputStoneSwitch;

@property (nonatomic, copy)NSString *eChCodeStreamStatus;

@property (nonatomic, copy)NSString *eChOutputNetWay;

@end


@interface FSJJietiao50W : FSJJiankongBase

@property (nonatomic, copy)NSString *eRFInputStatus;

@property (nonatomic, copy)NSString *eDemoRFIQ;

@property (nonatomic, copy)NSString *eRFInputSingleNetDelay;

@property (nonatomic, copy)NSString *eRFInputSNR;

@property (nonatomic, copy)NSString *eRFInputRate;

@property (nonatomic, copy)NSString *eDemoRFBroadBand;

@property (nonatomic, copy)NSString *eDemoRFFreq;

@end

@interface FSJZhengjicontrol50W : FSJJiankongBase

@property (nonatomic, copy)NSString *tSetOutputPow;

@property (nonatomic, copy)NSString *tWorkAuto;

@property (nonatomic, copy)NSString *protSwitch0;

@property (nonatomic, copy)NSString *protSwitch1;

@property (nonatomic, copy)NSString *protSwitch2;

@property (nonatomic, copy)NSString *protSwitch3;

@property (nonatomic, copy)NSString *tempThre;

@property (nonatomic, copy)NSString *tCuurThre;

@property (nonatomic, copy)NSString *tInputPowThreHigh;

@property (nonatomic, copy)NSString *vswrHigh;

@property (nonatomic, retain)NSArray *scheduleMon;
@property (nonatomic, retain)NSArray *scheduleTue;
@property (nonatomic, retain)NSArray *scheduleWed;
@property (nonatomic, retain)NSArray *scheduleThurs;
@property (nonatomic, retain)NSArray *scheduleFri;
@property (nonatomic, retain)NSArray *scheduleSat;
@property (nonatomic, retain)NSArray *scheduleSun;

@end
@interface FSJDTUnormal50W : FSJJiankongBase

@property (nonatomic, copy)NSString *spy_domin;

@property (nonatomic, copy)NSString *heartbeat;

@property (nonatomic, copy)NSString *dtu_id;

@property (nonatomic, copy)NSString *spy_ip;

@property (nonatomic, copy)NSString *dtu_pwd;

@property (nonatomic, copy)NSString *spy_port;

@end
@interface FSJDTUabNormal50W : FSJJiankongBase

@property (nonatomic, copy)NSString *network;

@property (nonatomic, copy)NSString *dtu_login_mode;

@property (nonatomic, copy)NSString *seri_param;

@property (nonatomic, copy)NSString *dns_ip;

@property (nonatomic, copy)NSString *seri_date;

@property (nonatomic, copy)NSString *seri_flow;

@property (nonatomic, copy)NSString *dtu_phone_num;

@property (nonatomic, copy)NSString *data_2name;

@property (nonatomic, copy)NSString *data_3ip;

@property (nonatomic, copy)NSString *data_2ip;

@property (nonatomic, copy)NSString *apn_name;

@property (nonatomic, copy)NSString *data_3name;

@property (nonatomic, copy)NSString *apn_pwd;

@property (nonatomic, copy)NSString *apn_username;

@end
