package com.wartype.scores
{
    public class Score
	{
        private var count:Number = 0;
        
        public function inc():void
        {
            count++;
            trace(count);
        }
        
        public function get getCount():Number
        {
            return this.count;
        }
    }
}