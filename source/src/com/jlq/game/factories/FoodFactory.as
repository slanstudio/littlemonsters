package com.jlq.game.factories
{
	import com.jlq.game.assets.graphics.*;
	import com.jlq.game.utils.ArrayUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class FoodFactory
	{
		private static const foods:Array=[[Air,Bus,Car,Bike,Truck],
			[Dress,Hat,Coat,Jean,Shorts],
			[Cat,Dog,Pig,Elephant,Horse,Tiger],
			[Apple,Banana,Watermelon,Grape,Orange,Pear]];
		/**
		 * 0---交通工具
		 * 1---衣服
		 * 2---动物
		 * 3---水果
		 * */
		
		public static function produceFood(kind:int=0):Bitmap
		{
			var temp:Array=foods[kind];
			var classInstance:Class=ArrayUtil.shuffleArray(temp).slice(0,1)[0] as Class;
			var bitmapData:BitmapData=new classInstance() as BitmapData;
			return new Bitmap(bitmapData,"auto");
		}
	}
}