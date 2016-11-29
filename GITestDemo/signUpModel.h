//
//  signUpModel.h
//  GITestDemo
//
//  Created by WS on 15/10/12.
//  Copyright © 2015年 Kyson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface signUpModel : NSObject
/**
 *  商户类型
 */
@property (nonatomic, copy) NSString *merType;
/**
 *  登陆密码
 */
@property (nonatomic, copy) NSString *passwd;
/**
 *  地区编码
 */
@property (nonatomic, copy) NSString *areaCode;
/**
 *  法定代表人
 */
@property (nonatomic, copy) NSString *lawMan;
/**
 *  手机号
 */
@property (nonatomic, copy) NSString *phone;
/**
 *  法人有效证件种类
 */
@property (nonatomic, copy) NSString *certType;
/**
 *  法人有效证件号码
 */
@property (nonatomic, copy) NSString *certNo;
/**
 *  法人证件有效日期
 */
@property (nonatomic, copy) NSString *certExpdate;
/**
 *  商户营业地址
 */
@property (nonatomic, copy) NSString *mchAddr;
/**
 *  银行卡类型
 */
@property (nonatomic, copy) NSString *accountType;
/**
 *  对公或者对私账户标识
 */
@property (nonatomic, copy) NSString *isPrivate;
/**
 *  开户行全称
 */
@property (nonatomic, copy) NSString *bankName;
/**
 *  开户行所在省
 */
@property (nonatomic, copy) NSString *province;
/**
 *  开户行所在市
 */
@property (nonatomic, copy) NSString *city;
/**
 *  支行名称
 */
@property (nonatomic, copy) NSString *bankBranch;
/**
 *  开户行账号
 */
@property (nonatomic, copy) NSString *settleAccno;
/**
 *  开户行号联行号
 */
@property (nonatomic, copy) NSString *settleBank;
/**
 *  开户姓名
 */
@property (nonatomic, copy) NSString *accName;
/**
 *  G1设备码
 */
@property (nonatomic, copy) NSString *sn;


@end
