package com.wartype.scores
{
    public class Score
	{
        private var count:Number = 0;
        private var factor:Number = 1;
        private var damagedEnemies:Number = 0;

        public function inc(incNumber: Number):void
        {
            count += incNumber * factor;
            trace('Score: ' + count);
            trace('Factor: ' + factor);
        }

        public function incDamagedEnemies():void
        {
            damagedEnemies++;
            if(damagedEnemies % 5 == 0)
            {
                factor++;
            }
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