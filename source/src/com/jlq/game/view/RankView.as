package com.jlq.game.view
{
	import com.jlq.game.utils.SQLiteUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * 分数排行榜
	 * */
	
	public class RankView extends Sprite
	{
		[Embed(source="../../../../../build/assets/game_rank_list.png")]
		private var bgAsset:Class;
		
		private var scoresTxt:TextField;
		private var sqlUtil:SQLiteUtil;
		private var dbFile:File;
		private var allRecords:Array;
		private var format:TextFormat;
		
		public function RankView()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE,addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage);
		}
		
		private function removedFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStage);
			//trace("rank view removed from stage");
		}
		
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,addedToStage);
			//trace("rank list view added to stage");
			
			var backgroundImage:Bitmap=addChild(Bitmap(new bgAsset())) as Bitmap;
			
			format=new TextFormat();
			format.size=28;
			format.bold=true;
			format.color=0x000000;
			format.font="Times New Roman";
			
			scoresTxt=new TextField();
			scoresTxt.defaultTextFormat=format;
			scoresTxt.width=backgroundImage.width-20;
			scoresTxt.height=backgroundImage.height-30;
			scoresTxt.x=(backgroundImage.width-scoresTxt.width)/2+28;
			scoresTxt.y=(backgroundImage.width-scoresTxt.width)/2+40;
			addChild(scoresTxt);
			
			sqlUtil=SQLiteUtil.getInstance() as SQLiteUtil;
			dbFile=File.applicationDirectory.resolvePath("feedpetgame.db");
			sqlUtil.dbFile=dbFile;
			sqlUtil.openDBConnect();
			
			var sql:String="select * from records_tb";
			allRecords=sqlUtil.getAllRecords(sql);
			
			/*
				插入数据
			*/
//			if(allRecords.length<=8)
//			{
//				var insertSql:String="insert into records_tb(player,score) values('player',)";
//				sqlUtil.insertRecord(insertSql);
//			}
			
			var len:int=allRecords.length;
			var temp:Array=allRecords.sortOn("score",Array.DESCENDING);
			for(var i:int=0;i<8;i++)
			{
				var obj:Object=temp[i];
				scoresTxt.appendText('\n'+obj.score+'\t    '+obj.player);
			}
			
			sqlUtil.closeDBConnect();
		}
	}
}