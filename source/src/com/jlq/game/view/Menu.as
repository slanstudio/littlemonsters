package com.jlq.game.view
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Menu extends Sprite
	{
		[Embed(source="../../../../../build/buttons/button_exit.png")]
		private var exitBTNAsset:Class;
		[Embed(source="../../../../../build/buttons/button_rank.png")]
		private var rankBTNAsset:Class;
		[Embed(source="../../../../../build/buttons/button_start.png")]
		private var newGameBTNAsset:Class;
		
		private var newGameBTN:SimpleButton;	//新游戏按钮
		private var exitBTN:SimpleButton;	//退出游戏按钮
		private var rankBTN:SimpleButton;	//排行榜按钮
		public var isAgain:Boolean=false;	//是否重玩游戏
		private var activity:IMenuOptions;
		
		public function Menu(activity:IMenuOptions)
		{
			super();
			
			this.activity=activity;
			
			addEventListener(Event.ADDED_TO_STAGE,addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage);
		}
		
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,addedToStage);
			
			//新游戏按钮
			newGameBTN=addChild(new SimpleButton(new newGameBTNAsset(),new newGameBTNAsset(),new newGameBTNAsset(),new newGameBTNAsset())) as SimpleButton;
			newGameBTN.x=0;
			newGameBTN.y=0;
			newGameBTN.addEventListener(MouseEvent.MOUSE_UP,newGame);
			
			//排行榜按钮
			rankBTN=addChild(new SimpleButton(new rankBTNAsset(),new rankBTNAsset(),new rankBTNAsset(),new rankBTNAsset())) as SimpleButton;
			rankBTN.x=(newGameBTN.width-rankBTN.width)/2;
			rankBTN.y=newGameBTN.height+45;
			rankBTN.addEventListener(MouseEvent.MOUSE_UP,showRank);
			
			//退出游戏按钮
			exitBTN=addChild(new SimpleButton(new exitBTNAsset(),new exitBTNAsset(),new exitBTNAsset(),new exitBTNAsset())) as SimpleButton;
			exitBTN.x=(newGameBTN.width-rankBTN.width)/2;
			exitBTN.y=rankBTN.height+rankBTN.y+55;
			exitBTN.addEventListener(MouseEvent.MOUSE_UP,exitGame);
		}
		
		
		private function newGame(e:MouseEvent):void
		{
			activity.newGame();
		}
		
		private function exitGame(e:MouseEvent):void
		{
			activity.exitGame();
		}
		
		private function showRank(e:MouseEvent):void
		{
			activity.showRank();
		}
		
		private function removedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStage);
			trace("Menu removed from stage");
			newGameBTN.removeEventListener(MouseEvent.MOUSE_UP,newGame);
			rankBTN.removeEventListener(MouseEvent.MOUSE_UP,showRank);
			exitBTN.removeEventListener(MouseEvent.MOUSE_UP,exitGame);
		}
	}
}