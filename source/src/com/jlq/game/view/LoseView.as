package com.jlq.game.view
{
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * 
	 * 通关失败界面
	 * 
	 * */
	
	public class LoseView extends Sprite
	{
		[Embed(source="../../../../../build/assets/lose_game_bg.png")]
		private var BGAsset:Class;
		[Embed(source="../../../../../build/buttons/button_save_score.png")]
		private var saveGameBTNAsset:Class;
		[Embed(source="../../../../../build/buttons/button_restart.png")]
		private var againBTNAsset:Class;
		
		private var saveGameBTN:SimpleButton;
		private var againBTN:SimpleButton;
		
		public function LoseView()
		{
			super();
			
			var bgImage:Bitmap=addChild(Bitmap(new BGAsset())) as Bitmap;
			
			saveGameBTN=addChild(new SimpleButton(new saveGameBTNAsset(),new saveGameBTNAsset(),new saveGameBTNAsset(),new saveGameBTNAsset())) as SimpleButton;
			saveGameBTN.addEventListener(MouseEvent.MOUSE_UP,saveGame);
			saveGameBTN.x=66;
			saveGameBTN.y=130;
			
			againBTN=addChild(new SimpleButton(new againBTNAsset(),new againBTNAsset(),new againBTNAsset(),new againBTNAsset())) as SimpleButton;
			againBTN.addEventListener(MouseEvent.MOUSE_UP,restart);
			againBTN.x=166;
			againBTN.y=130;
		}
		
		/**
		 * 保存游戏
		 * */
		private function saveGame(e:MouseEvent):void
		{
			this.dispatchEvent(new Event("saveGame"));
		}
		
		/**
		 * 重新挑战
		 * */
		private function restart(e:MouseEvent):void
		{
			this.dispatchEvent(new Event("restart"));
		}
	}
}