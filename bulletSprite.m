//
//  bulletSprite.m
//  tankMap
//
//  Created by mirror on 10-5-26.
//  Copyright 2010 zhong. All rights reserved.
//111

#import "bulletSprite.h"
#import "gameLayer.h"

@implementation bulletSprite

@synthesize isEnemy;

+(id)initWithLayer:(CCLayer *)layer{
	gameLayer *ly=(gameLayer *)layer;
	bulletSprite *sprite=[bulletSprite spriteWithFile:@"bullet.PNG" rect:CGRectMake(0, 0, 16, 16)];
	
	[ly.gameWorld addChild:sprite z:100];
	[sprite setVisible:NO];
	[sprite setGameLayer:layer];
	return sprite;
}
-(void)setGameLayer:(CCLayer *)layer{
	gLayer=layer;
}
-(void)emitterInit{
	//敌方坦克使用
	smokeEmitter=[[CCParticleSmoke alloc] initWithTotalParticles:500];
	
	
	
	fireEmitter=[[CCParticleSun alloc] initWithTotalParticles:800];
	
}

-(void)dealloc{
	[super dealloc];
}

//子弹检测函数
-(void)checkBullectCollision{
	gameLayer *ly=(gameLayer *)gLayer;
	
	unsigned int tid;
	tid=[ly tileIDFromPosition:self.position];
	
	
	//子弹和我方坦克碰撞检测
	if (self.isEnemy) {
		CGRect ct;
		ct=CGRectMake(ly.tank.position.x-ly.tank.textureRect.size.width/2,
					  ly.tank.position.y-ly.tank.textureRect.size.height/2, 
					  ly.tank.textureRect.size.width, 
					  ly.tank.textureRect.size.height);
		if (CGRectContainsPoint(ct, self.position)) {
			[self unschedule:@selector(checkBullectCollision)];
			[self stopAllActions];
			[self setVisible:NO];
			
			[ly.tank stopAllActions];
			if (self.isEnemy) {
				[self addExplode:ly];
				//显示爆炸效果
				[self showExplodeAt:ccp(self.position.x,self.position.y)];
				[ly.tank tankDeath];
			}

			id ac=[CCTintBy actionWithDuration:0.1f red:0 green:255 blue:255];
			id seq=[CCSequence actions:ac,ac,nil];
			
			[ly.tank runAction:seq];
		}
	}
	//子弹和敌方坦克相撞
	for (tankSprite *enemy in ly.enemyList) {
		CGRect enemyCt=CGRectMake(enemy.position.x-enemy.textureRect.size.width/2,
								  enemy.position.y-enemy.textureRect.size.height/2,
								  enemy.textureRect.size.width,
								  enemy.textureRect.size.height);
		if (CGRectContainsPoint(enemyCt, self.position)) {
			if (enemy.isEnemy) {
				[self unschedule:@selector(checkBullectCollision)];
				[self stopAllActions];
				[self setVisible:NO];
				if (!self.isEnemy) {
					//[enemy setVisible:NO];
					[enemy stopAllActions];
					id ac=[CCTintBy actionWithDuration:0.1f red:0 green:255 blue:255];
					id seq=[CCSequence actions:ac,ac,nil];
					[enemy runAction:seq];
					[self addExplode:ly];
					//显示爆炸效果
					[self showExplodeAt:ccp(self.position.x,self.position.y)];
					
					[enemy tankDeath];
				}
			}
			
		}
	}
//	//子弹相撞
//	CGRect bullectCt=[self textureRect];
//	if (CGRectContainsPoint(bullectCt, self.position)) {
//		if (self.isEnemy) {
//			[self unschedule:@selector(checkBullectCollision)];
//			[self stopAllActions];
//			[self setVisible:NO];
//		}
//	}
	

	
	//子弹撞上砖块
	if (tid!=4) {
		if (tid!=0){
			//添加爆炸效果
			[self addExplode:ly];
			//显示爆炸效果
			[self showExplodeAt:ccp(self.position.x,self.position.y)];
			[self unschedule:@selector(checkBullectCollision)];
			[self stopAllActions];
			[self setVisible:NO];
			//撞击的砖墙变化效果	
			
		}else {
			//移除检测函数和停止子弹的运动，设置子弹不可见 
			[self unschedule:@selector(checkBullectCollision)];
			[self stopAllActions];
			[self setVisible:NO];
		}
	}
}
-(void)addExplode:(CCLayer *)layer{
	gameLayer *ly=(gameLayer *)layer;
	sheetExplode=[CCSpriteSheet spriteSheetWithFile:@"Explode1.png" capacity:10];
	[ly.gameWorld addChild:sheetExplode z:99];
	
	spriteExplode=[CCSprite spriteWithTexture:sheetExplode.texture rect:CGRectMake(0, 0, 23, 23)];
	[sheetExplode addChild:spriteExplode z:1 tag:5];
	
	spriteExplode.position=ccp(160,240);
	[spriteExplode setVisible:NO];	
}
//显示爆炸效果
-(void)showExplodeAt:(CGPoint)posAt{
	int nsize=23;
	[spriteExplode setPosition:posAt];
	[spriteExplode setVisible:YES];
	
	CCAnimation *animation=[CCAnimation animationWithName:@"exp" delay:0.05f];
	for (int i=1; i<8; i++) {
		[animation addFrameWithTexture:sheetExplode.texture rect:CGRectMake(i*nsize, 0, nsize, nsize)];
	}
	
	id action=[CCAnimate actionWithAnimation:animation];
	id ac=[CCSequence actions:action,[CCHide action],nil];
	
	[spriteExplode runAction:ac];
	
}
@end
