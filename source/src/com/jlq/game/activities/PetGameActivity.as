package com.jlq.game.activities
{
	import com.jlq.dragon.activities.BaseActivity;
	import com.jlq.dragon.activities.IActivityManager;
	import com.jlq.game.state.ActiveGameState;
	import com.jlq.game.utils.SQLiteUtil;
	
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;

	public class PetGameActivity extends BaseActivity
	{
		protected var activeState:ActiveGameState;
		protected var sqlUtil:SQLiteUtil;
		public function PetGameActivity(activityManager:IActivityManager, data:*=null)
		{
			super(activityManager, data);
		}
		
		override protected function onCreate():void
		{
			//游戏状态
			activeState=new ActiveGameState();
			activeState.load();
			
			//SQLiteUtil本地数据库工具类
			sqlUtil=SQLiteUtil.getInstance() as SQLiteUtil;
			sqlUtil.dbFile=File.applicationDirectory.resolvePath("feedpetgame.db");
			sqlUtil.openDBConnect();
			
			super.onCreate();
		}
		
		override public function onStart():void
		{
			super.onStart();
		}
		
		/**
		 * 游戏暂停
		 * */
		override public function onStop():void
		{
			saveState();	//保存状态
			
			super.onStop();
		}
		
		/**
		 * 保存状态
		 * */
		override public function saveState():void
		{
			activeState.mute=soundManager.mute;
			activeState.save();	
			
			super.saveState();
		}
		
		/**
		 * 游戏返回
		 * */
		override public function onBack():void
		{
			super.onBack();
		}
		
		/**
		 * 游戏退出
		 * */
		override public function onExit():void
		{
			//activeState.activeGame=false;
			saveState();
			
			//关闭数据库连接
			sqlUtil.closeDBConnect();
			
			super.onExit();
		}
		
		/**
		 * 暂停游戏
		 * */
		override public function onPause():void
		{
			super.onPause();
		}
		
		/**
		 * 重新启动游戏
		 * */
		override public function reStart():void
		{
			super.reStart();
		}
	}
}