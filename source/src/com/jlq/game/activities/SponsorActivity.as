package com.jlq.game.activities
{
	import com.jlq.dragon.activities.BaseActivity;
	import com.jlq.dragon.activities.IActivityManager;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class SponsorActivity extends BaseActivity
	{
		[Embed(source="../../../../../build/assets/game_logo.png")]
		private var gameLogo:Class;
		
		private var logoContainer:Sprite;
		
		public function SponsorActivity(activityManager:IActivityManager, data:*=null)
		{
			super(activityManager, data);
		}
		
		override protected function onCreate():void
		{
			super.onCreate();
		}
		
		override public function onStart():void
		{
			super.onStart();
			this.graphics.beginFill(0xffffff,1);
			this.graphics.drawRect(0,0,fullSizeWidth,fullSizeHeight);
			this.graphics.endFill();
			
			var logoImage:Bitmap=Bitmap(new gameLogo());
			logoContainer=new Sprite();
			logoContainer.addEventListener(Event.ADDED_TO_STAGE,addedToStage);
			addChild(logoContainer);
			logoContainer.addChild(logoImage);
			logoContainer.x=(fullSizeWidth-logoContainer.width)/2;
			logoContainer.y=(fullSizeHeight-logoContainer.height)/2;
			
//			var appXML:XML=NativeApplication.nativeApplication.applicationDescriptor;
//			var ns:Namespace=appXML.namespace();
//			trace(appXML.ns::versionLabel);
//			trace(appXML.ns::versionNumber);
		}
		
		private function addedToStage(e:Event):void
		{
			//设置一下界面出现的时间延时
			startNextActivityTimer(StartActivity,3);
		}
	}
}