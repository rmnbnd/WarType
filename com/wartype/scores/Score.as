package com.wartype.scores
{
    import com.wartype.Universe;
    import caurina.transitions.Tweener;

    public class Score
	{
        private var count:Number = 0;
        private var factor:Factor = new Factor();
        private var damagedEnemies:Number = 0;
        private var universe:Universe = Universe.getInstance();

        public function inc(incNumber: Number):void
        {
            count += incNumber * factor.count;
            Universe.getInstance().getTextFieldScore.text = "Score: " + count.toString();
        }

        public function incDamagedEnemies():void
        {
            damagedEnemies++;
            if(damagedEnemies % 5 == 0)
            {
                factor.count++;
                switch (factor.count) {
                    case 2:
                        createNewFactorSprite(factorX2_mc);
                        break;
                    case 3:
                        createNewFactorSprite(factorX3_mc);
                        break;
                    case 4:
                        createNewFactorSprite(factorX4_mc);
                        break;
                    case 5:
                        createNewFactorSprite(factorX5_mc);
                        break;
                    case 6:
                        createNewFactorSprite(factorX6_mc);
                        break;
                }
            }
        }
        
        public function resetFactor():void
        {
            factor.count = 1;
            if(factor.factorSprite)
            {
                universe.removeChild(factor.factorSprite);
            }
            factor.resetFactor();
            universe.addChild(factor.factorSprite);
            Tweener.addTween(factor.factorSprite, { alpha: 1, time: 3} );
        }

        private function createNewFactorSprite(factor_mc: Class):void
        {
            universe.removeChild(factor.factorSprite);
            factor.factorSprite = new factor_mc();
            factor.factorSprite.x = ScoreConstants.FACTOR_SPRITE_X;
            factor.factorSprite.y = ScoreConstants.FACTOR_SPRITE_Y;
            factor.factorSprite.alpha = 0;
            universe.addChild(factor.factorSprite);
            Tweener.addTween(factor.factorSprite, { alpha: 1, time: 3} );
        }
        
        public function get getCount():Number
        {
            return this.count;
        }
        
        public function get getFactor():Factor
        {
            return this.factor;
        }
    }
}