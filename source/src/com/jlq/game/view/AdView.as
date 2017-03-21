package com.jlq.game.view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class AdView extends Sprite
	{
		[Embed(source="../../../../../build/assets/ad.png")]
		private var adAsset:Class;
		
		public function AdView()
		{
			init();
		}
		
		private function init():void
		{
			var ad:Bitmap=addChild(Bitmap(new adAsset())) as Bitmap;
		}
	}
}