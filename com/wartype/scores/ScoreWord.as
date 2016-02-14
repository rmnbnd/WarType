package com.wartype.scores
{
    import com.framework.math.Anumber;
    import com.wartype.words.WordBase;
    import com.wartype.words.WordConstants;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.text.TextField;

    public class ScoreWord extends Sprite
    {
        private var scoreWordSprite:MovieClip;
        private var scoreWordTextField:TextField;
        public var nameWord:String;

        public function ScoreWord(word: WordBase, name: String)
        {
            scoreWordSprite = new scoreWordTextField_mc();
            scoreWordSprite.x = Anumber.randRange(0, 50);
            if (scoreWordSprite[WordConstants.DEFAULT_GUN_TEXTFIELD_TEXT] != null)
            {
                scoreWordTextField = scoreWordSprite[WordConstants.DEFAULT_GUN_TEXTFIELD_TEXT] as TextField;
            }
            scoreWordTextField.text = "+" + WordConstants.JET_SCORE_INC.toString();
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
