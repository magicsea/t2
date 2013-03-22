//
//  controlLayer.h
//  tankMap
//
//  Created by mirror on 10-5-22.
//  Copyright 2010 zhong. All rights reserved.
//4141assg

#import "cocos2d.h"
#import "gameLayer.h"
#import "tankSprite.h"

@interface controlLayer : CCLayer {
	gameLayer *glayer;
	mapAction kAct;
	
	tankAction tAct;
	// action button
	CCSprite *item_f_n, *item_f_s, *item_u_out, *item_u_on, *item_l_out, *item_l_on, *item_r_out, *item_r_on, *item_d_out, *item_d_on;
}


@property(nonatomic,readwrite,assign)gameLayer *glayer;

//连续移动
-(void)keepDoing;
@end
