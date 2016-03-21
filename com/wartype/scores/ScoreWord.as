package com.wartype.scores
{
    import com.framework.math.Anumber;
    import com.wartype.Universe;
    import com.wartype.words.WordBase;
    import com.wartype.words.WordConstants;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.utils.getQualifiedClassName;

    public class ScoreWord extends Sprite
    {
        private var scoreWordSprite:MovieClip;
        private var scoreWordTextField:TextField;
        public var nameWord:String;
        private var universe:Universe = Universe.getInstance();
        private var scoreIncJet:Number = WordConstants.JET_SCORE_INC;
        private var scoreIncHeli:Number = WordConstants.HELI_SCORE_INC;
        private var scoreIncEnterprise:Number = WordConstants.ENTERPRISE_SCORE_INC;
        private var scoreIncOsprey:Number = WordConstants.OSPREY_SCORE_INC;

        public function ScoreWord(word: WordBase, name: String)
        {
            if (word.getWordsArrayLength <= 0 && word.wordSplitChars.length <= 0)
            {
                scoreIncJet = WordConstants.JET_SCORE_INC_FINAL;
                scoreIncHeli = WordConstants.HELI_SCORE_INC_FINAL;
                scoreIncEnterprise = WordConstants.ENTERPRISE_SCORE_INC_FINAL;
                scoreIncOsprey = WordConstants.OSPREY_SCORE_INC_FINAL;
            }
            scoreWordSprite = new scoreWordTextField_mc();
            scoreWordSprite.x = Anumber.randRange(0, 50);
            if (scoreWordSprite[WordConstants.DEFAULT_GUN_TEXTFIELD_TEXT] != null)
            {
                scoreWordTextField = scoreWordSprite[WordConstants.DEFAULT_GUN_TEXTFIELD_TEXT] as TextField;
            }
            switch (getQualifiedClassName(word))
            {
                case "com.wartype.words::WordL1":
                    scoreWordTextField.text = "+" + (scoreIncJet * universe.score.getFactor.count).toString();
                    break;
                case "com.wartype.words::WordL2":
                    scoreWordTextField.text = "+" + (scoreIncHeli * universe.score.getFactor.count).toString();
                    break;
                case "com.wartype.words::WordL3":
                    scoreWordTextField.text = "+" + (scoreIncEnterprise * universe.score.getFactor.count).toString();
                    break;
                case "com.wartype.words::WordL4":
                    scoreWordTextField.text = "+" + (scoreIncOsprey * universe.score.getFactor.count).toString();
                    break;
            }
            createScoreForWord(word);
            nameWord = name;
        }

        public function createScoreForWord(word: WordBase):void
        {
            if(scoreWordSprite != null)
            {
                word.addChild(scoreWordSprite);
            }
        }

        public function update(word: WordBase):void
        {
            if(scoreWordSprite.alpha > 0)
            {
                scoreWordSprite.alpha -= 0.095;
                scoreWordSprite.y -= 2;
            }
            else
            {
                word.removeScoreWord(this);
            }
        }

    }
}
