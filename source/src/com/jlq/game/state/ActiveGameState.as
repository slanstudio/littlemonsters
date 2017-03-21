package com.jlq.game.state
{
	import com.jlq.dragon.state.AbstractStateObject;
	
	public class ActiveGameState extends AbstractStateObject
	{
		private static const FEED_PET:String="FeedPet";
		public function ActiveGameState()
		{
			super(this,FEED_PET);
		}
		
		//游戏因没有正常结束玩家只是想以后玩或者暂停一会过会再玩，那么游戏还处于激活状态
		public function get activeGame():Boolean
		{
			return _dataObject.activeGame?_dataObject.activeGame:false;
		}
		public function set activeGame(value:Boolean):void
		{
			_dataObject.activeGame=value;
		}
		
		//游戏状态
		public function get gameState():int
		{
			return _dataObject.gameState;
		}
		public function set gameState(value:int):void
		{
			_dataObject.gameState=value;
		}
		
		//正在玩游戏的玩家
		public function get player():String
		{
			return _dataObject.player?_dataObject.player:"";
		}
		public function set player(value:String):void
		{
			_dataObject.player=value;
		}
		
		//玩家总得分
		public function get totalScore():Number
		{
			return _dataObject.totalScore?_dataObject.totalScore:0;
		}
		public function set totalScore(value:Number):void
		{
			_dataObject.totalScore;
		}
		
		//是否静音
		public function get mute():Boolean
		{
			return _dataObject.mute?_dataObject.mute:false;
		}
		public function set mute(value:Boolean):void
		{
			_dataObject.mute=value;
		}
		
		//关卡难度
		public function get difficult():int
		{
			return _dataObject.difficult
		}
		public function set difficult(value:int):void
		{
			_dataObject.difficult=value;
		}
		
		//状态重置
		public function reset():void
		{
			_dataObject.totalScore=0;
			_dataObject.difficultLevel=1;
		}
	}
}