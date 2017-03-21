package com.jlq.game.utils
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;

	public class SQLiteUtil
	{
		private static var _instance:SQLiteUtil;	//单体类实例
		private var dbConn:SQLConnection;	//数据库连接
		private var stmt:SQLStatement;		//数据库查询
		private var result:SQLResult;		//查询结果集
		private var row:Object;		//一行记录对象
		private var _dbFile:File;	//数据库文件
		
		public function SQLiteUtil()
		{
			dbConn=new SQLConnection();
			dbConn.addEventListener(SQLEvent.OPEN,openDBHandler);
			dbConn.addEventListener(SQLErrorEvent.ERROR,openError);
		}
		
		/**
		 * SQLiteUtil单体实例方法
		 * */
		public static function getInstance():SQLiteUtil
		{
			if(_instance==null)
				_instance=new SQLiteUtil();
			return _instance as SQLiteUtil;
		}
		
		/**
		 * 连接数据库
		 * */
		public function openDBConnect():void
		{
			//如果已有数据连接，则关闭连接
			if(dbConn.connected)
				dbConn.close();
			
			dbConn.open(_dbFile);
		}
		
		/**
		 * 关闭数据库连接
		 * */
		public function closeDBConnect():void
		{
			if(dbConn.connected)
				dbConn.close();
		}
		
		/**
		 * 获得指定数量的值
		 * */
		public function getAllRecords(sql:String):Array
		{
			stmt=new SQLStatement();
			stmt.sqlConnection=dbConn;
			stmt.text=sql;
			stmt.execute();
			
			var resultArr:Array=new Array();
			result=stmt.getResult();
			if(result.data!=null)
			{
				var numResults:int =result.data.length;			
				for (var i:int = 0; i < numResults; i++) 
				{ 
					resultArr[i] = result.data[i];  				
				} 	
			}
			return resultArr;
		}
		
		/**
		 * 创建表
		 * */
		public function createTable(sql:String):Boolean
		{
			stmt=new SQLStatement();
			stmt.sqlConnection=dbConn;
			stmt.text=sql;
			stmt.execute();
			return true;
		}
		
		/**
		 * 插入一条记录
		 * */
		public function insertRecord(sql:String):Boolean
		{
			stmt=new SQLStatement();
			stmt.sqlConnection=dbConn;
			stmt.text=sql;
			stmt.execute();
			return true;
		}
		
		/**
		 * 获得一条记录
		 * */
		public function getRecord(sql:String):Object
		{
			stmt=new SQLStatement();
			stmt.sqlConnection=dbConn;
			stmt.text=sql;
			stmt.execute();
			
			result=stmt.getResult();
			
			if(result!=null)
			{
				var numResults:int=result.data.length;
				for(var i:int=0;i<numResults;i++)
				{
					row=result.data[i];
				}
			}
			return row;
		}
		
		/**
		 * 获得最高分数
		 * */
		public function getMaxScore(sql:String):Object
		{
			stmt=new SQLStatement();
			stmt.sqlConnection=dbConn;
			stmt.text=sql;
			stmt.execute();
			
			result=stmt.getResult();
			
			if(result!=null)
			{
				var numResults:int=result.data.length;
				for(var i:uint=0;i<numResults;i++)
				{
					row=result.data[i];
				}
			}
			
			return row;
		}
		
		/**
		 * 更新记录
		 * */
		public function updateRecord(sql:String):Boolean
		{
			stmt=new SQLStatement();
			stmt.sqlConnection=dbConn;
			stmt.text=sql;
			stmt.execute();
			return true;
		}
		
		private function openDBHandler(e:SQLEvent):void
		{
			//trace("open db success");
		}
		
		private function openError(e:SQLErrorEvent):void
		{
			trace("open db failed");
			trace(e.error.message);
			trace(e.error.details);
		}

		public function get dbFile():File
		{
			return _dbFile;
		}

		public function set dbFile(value:File):void
		{
			_dbFile = value;
		}
		
		
		
		
		
		
		/**
		 * 
		 * 喂喂小宠物怪兽数据库表设计
		 * 
		 * records_tb	分数记录表
		 * 
		 * name:姓名
		 * score:得分
		 * 
		 * */
	}
}