package com.jlq.game.core
{
	import com.jlq.game.assets.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 怪物类
	 * */
	
	public class Monster extends Sprite
	{
		public static const monstersClassArr:Array=[Monster1,Monster2,Monster3,Monster4];
		private var monsterStateArr:Array=new Array(new Array(1,2),new Array(3,3),new Array(4,5,6));	//该怪物的状态数组
		private var monsterClass:Class;
		private var monsterMC:MovieClip;
		private var _foodKind:int;	//所吃的事物种类
		private var timer:Timer;
		private var _currentState:int;	//当前状态
		private var count:int;
		/**
		 * 0---怪兽等待进食
		 * 1---怪兽等待食物放入口中
		 * 2---怪兽咀嚼食物
		 * */
		
		public function Monster(classIndex:int)
		{
			super();
			
			_foodKind=classIndex;
			trace("_foodKind=",_foodKind);
			monsterClass=monstersClassArr[classIndex];
			monsterMC=addChild(MovieClip(new monsterClass())) as MovieClip;
			monsterMC.stop();
			
			addEventListener(Event.ADDED_TO_STAGE,addedToStage);
		}
		
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,addedToStage);
			
			count=0;
			
			timer=new Timer(120,0);
			timer.addEventListener(TimerEvent.TIMER,timerIng);
			timer.start();
		}
		
		public function timerIng(e:TimerEvent):void
		{	
			//当前为状态2
			if(_currentState==2)
			{
				count ++;
				if(count>10){
					_currentState=0;
					count=0;
					monsterMC.gotoAndStop(1);
				}
			}
			//trace("state=",_currentState);
			
			//当前为状态1
			if(_currentState==1)
			{
				count ++;
				if(count>5)
				{
					_currentState=0;
					count=0;
					monsterMC.gotoAndStop(1);
				}
			}
			
			playMC();
		}
		
		private function playMC():void
		{	
			var arr:Array=monsterStateArr[_currentState];
			if(monsterMC.currentFrame!=arr[arr.length-1])
			{
				monsterMC.nextFrame();
			}else{
				monsterMC.gotoAndStop(arr[0]);
			}
		}
		
		public function checkFood(food:Food):Boolean
		{
			//切换呢怪兽影片简介状态为等待食物进口状态
			setState(1);
			if(food.kind==_foodKind){
				return true;
			}else{
				return false;
			}
		}
		
		/**
		 * 设置Monster状态
		 * */
		public function setState(s:int):void
		{
			if(s==_currentState){
				return;
			}
			
			_currentState=s;
		}
		
		/**
		 * 停止影片剪辑播放,当暂停游戏时
		 * */
		public function stopMC():void
		{
			timer.stop();
		}
		
		public function rePlay():void
		{
			_currentState=0;
			timer.reset();
		}
	}
}