package com.jlq.game.activities
{
	import com.jlq.dragon.activities.IActivityManager;
	import com.jlq.game.utils.SQLiteUtil;
	import com.jlq.game.view.AdView;
	import com.jlq.game.view.IMenuOptions;
	import com.jlq.game.view.Menu;
	import com.jlq.game.view.RankView;
	import com.jlq.nativeExtensions.android.nativeAds.youmi.YoumiAd;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	
	public class StartActivity extends PetGameActivity implements IMenuOptions
	{
		[Embed(source="../../../../../build/assets/game_menu_bg.png")]
		private var bgAsset:Class;
		
		private var rankView:RankView;
		private var menu:Menu;
		private var adANE:YoumiAd;
		
		public function StartActivity(activityManager:IActivityManager, data:*=null)
		{
			super(activityManager, data);
		}
		
		override protected function onCreate():void
		{
			//创建所需的数据表格
			sqlUtil=SQLiteUtil.getInstance() as SQLiteUtil;
			sqlUtil.dbFile=File.applicationDirectory.resolvePath("feedpetgame.db");
			sqlUtil.openDBConnect();
			/*
			创建数据表
			recordId记录ID
			player玩家姓名
			score玩家得分
			*/
			var createTbSql:String="create table if not exists records_tb ("	+
				"recordId INTEGER PRIMARY KEY autoincrement,"	+
				"player TEXT,"	+
				"score NUMBERIC"	+
				")";
			sqlUtil.createTable(createTbSql);
			
			super.onCreate();
		}
		
		override public function onStart():void
		{
			super.onStart();
			
			//显示广告
			adANE = new YoumiAd();
			adANE.initAd("17eba847a8ae2a06","cd157826f5aef8c8",30,false);
			adANE.showAd(0,fullSizeHeight-38,fullSizeWidth,38);
			
			//背景
			var bgImage:Bitmap=addChild(Bitmap(new bgAsset())) as Bitmap;
			
			//Menu菜单
			menu=new Menu(this);
			addChild(menu);
			menu.x=(800-menu.width)/2-32;
			menu.y=(480-menu.height)/2+13;
			
			//var ad:AdView=addChild(new AdView()) as AdView;
			//ad.y=(fullSizeHeight-ad.height);
		}
		
		public function newGame():void
		{
			trace("new game");
			//重置状态
			activeState.activeGame=true;
			activeState.reset();
			startNextActivityTimer(NewGameActivity,1);
		}
		
		public function exitGame():void
		{
			trace("startGame");
			onExit();
		}
		
		public function showRank():void
		{
			trace("Show Rank List ");
			rankView=addChild(new RankView()) as RankView;
			rankView.x=(fullSizeWidth-rankView.width)/2;
			rankView.y=(fullSizeHeight-rankView.height)/2;
			rankView.addEventListener(MouseEvent.MOUSE_UP,closeRank);
		}
		
		private function closeRank(e:MouseEvent):void
		{
			rankView.removeEventListener(MouseEvent.MOUSE_UP,closeRank);
			removeChild(rankView);
		}
		
		override public function onStop():void{
			super.onStop();
			adANE.removeAd();
		}
	}
}