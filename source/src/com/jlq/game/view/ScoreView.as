package com.jlq.game.view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class ScoreView extends Sprite
	{
		[Embed(source="../../../../../build/assets/MuQianFenShu.png")]
		private var MQScoreTextAsset:Class;
		[Embed(source="../../../../../build/assets/ZuiGaoFenShu.png")]
		private var ZGScoreTextAsset:Class;
		
		private var _currentScore:Number;	//目前分数
		private var _highestScore:Number;	//最高分数
		private var _currentScoreTxt:TextField;	//目前分数文本显示框
		private var _highestScoreTxt:TextField;	//最高分数文本显示框
		
		public function ScoreView()
		{
			super();
			
			var mqScoreImage:Bitmap=addChild(Bitmap(new MQScoreTextAsset())) as Bitmap;
			mqScoreImage.x=0;
			mqScoreImage.y=0;
			
			var zgScoreImage:Bitmap=addChild(Bitmap(new ZGScoreTextAsset())) as Bitmap;
			zgScoreImage.x=0;
			zgScoreImage.y=mqScoreImage.height+10;
			
			_currentScoreTxt=addChild(new TextField()) as TextField;
			_currentScoreTxt.textColor=0x0000ff;
			_currentScoreTxt.x=mqScoreImage.width-10;
			_currentScoreTxt.y=mqScoreImage.height/2;
			
			_highestScoreTxt=addChild(new TextField()) as TextField;
			_highestScoreTxt.textColor=0x0000ff;
			_highestScoreTxt.text="0";
			_highestScoreTxt.x=zgScoreImage.width-10;
			_highestScoreTxt.y=zgScoreImage.height+10+zgScoreImage.height/2;
			
		}
		
		/**
		 * 更新得分
		 * */
		public function updateScore(_currentScore:Number):void
		{
			this._currentScore=_currentScore;
			_currentScoreTxt.text=_currentScore.toString();
			if(_currentScore>_highestScore){
				_highestScoreTxt.text=_currentScore.toString();
			}
		}
	}
}