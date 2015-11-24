package com.wartype.scores
{
    public class Score
	{
        private var count:Number = 1;
        private var factor:Number = 1;
        
        public function inc():void
        {
            count += factor * 1;
            trace('Score: ' + count);
            trace('Factor: ' + factor);
        }
        
        public function incFactor():void
        {
            factor++;
        }
        
        public function resetFactor():void
        {
            factor = 1;
        }
        
        public function get getCount():Number
        {
            return this.count;
        }
        
        public function get getFactor():Number
        {
            return this.factor;
        }
    }
}