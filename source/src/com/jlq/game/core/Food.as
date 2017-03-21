package com.jlq.game.core
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * 食物类
	 * */
	public class Food extends Sprite
	{
		public var kind:int;	//食物所属的分类
		public var currentPointIndex:Number;
		
		public function Food(foodImage:Bitmap,kind:int)
		{
			super();
			currentPointIndex=0;
			this.kind=kind;
			this.addChild(foodImage);
		}
	}
}