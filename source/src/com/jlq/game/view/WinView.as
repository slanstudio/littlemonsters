package com.jlq.game.view
{
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 * 通关界面
	 * 
	 * */
	
	public class WinView extends Sprite
	{
		[Embed(source="../../../../../build/assets/win_game_bg.png")]
		private var BGAsset:Class;
		[Embed(source="../../../../../build/buttons/button_yes.png")]
		private var yesBTNAsset:Class;
		[Embed(source="../../../../../build/buttons/button_no.png")]
		private var noBTNAsset:Class;
		
		private var yesBTN:SimpleButton;
		private var noBTN:SimpleButton;
		
		public var currentLevel:int;	//当前关卡
		public var totalScore:Number;	//总得分
		
		public function WinView()
		{
			super();
			
			var bgImage:Bitmap=addChild(Bitmap(new BGAsset())) as Bitmap;
			
			yesBTN=addChild(new SimpleButton(new yesBTNAsset(),new yesBTNAsset(),new yesBTNAsset(),new yesBTNAsset())) as SimpleButton;
			yesBTN.addEventListener(MouseEvent.MOUSE_UP,nextLevel);
			yesBTN.x=186;
			yesBTN.y=129;
			noBTN=addChild(new SimpleButton(new noBTNAsset(),new noBTNAsset(),new noBTNAsset(),new noBTNAsset())) as SimpleButton;
			noBTN.addEventListener(MouseEvent.MOUSE_UP,cancel);
			noBTN.x=65;
			noBTN.y=129;
		}
		
		private function nextLevel(e:MouseEvent):void
		{
			this.dispatchEvent(new Event("nextLevel"));
		}
		
		private function cancel(e:MouseEvent):void
		{
			this.dispatchEvent(new Event("cancel"));
		}
	}
}