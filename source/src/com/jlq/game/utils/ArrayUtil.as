package com.jlq.game.utils
{
    public class ArrayUtil
    {
        public static function shuffleArray(value:Array):Array
        {
            var arr:Array = value.slice();
            var arr2:Array = [];
            while (arr.length > 0)
            {
                arr2.push(arr.splice(Math.round(Math.random() * (arr.length - 1)), 1)[0]);
            }

            return arr2;
        }
    }
}
