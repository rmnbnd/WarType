package com.wartype.words
{
    import com.wartype.MainConstants;
    import com.wartype.Universe;
    import com.wartype.interfaces.IObject;

    public class WordL1 extends WordBase implements IObject
    {

        public function WordL1(wordObject:String, speed:int, timerWord:uint)
        {
            createSpritesForScene();

            wordIntoTextField = wordObject; //Записываем слово, передаваемое в конструктор, в переменную
            wordSplitChars = wordObject.split(''); //Разделяем слово по буквам
            wordsArrayLength = wordSplitChars.length; //Записываем размерность массива в переменную

            setSpeedY = speed; //Устанавливаем скорость
            go = true; //Флаг движения (потом понадобится)
            isDead = false; //Флаг "смерти" слова
            isAttacked = false; //Флаг атакуемости слова
            throwTimeWord = timerWord;

            init();
        }

        override public function update(delta:Number):void
        {
            super.update(delta);
            if (this.y >= MainConstants.SCR_HEIGHT - WordConstants.JET_BOTTOM_MARGIN)
            {
                Universe.getInstance().gun.setHealth = WordConstants.JET_DAMAGE;
                free();
            }
        }

        override public function boost():void
        {
            setSpeedY = getSpeedY + 20;
            setCurrentSpeed = getSpeedY;
            if(highFlameFirstFrame != null && highFlameFirstFrame.height < WordConstants.JET_MAX_FLAME_HEIGHT)
            {
                if(getChildByName("highFlameFirstFrame") == null)
                {
                    addChildAt(highFlameFirstFrame, 0);
                }
                highFlameFirstFrame.height += 4;
            }
        }

        private function createSpritesForScene():void
        {
            sprite = new wordL1_mc();
            textClip = new textLabelL1_mc();
            highFlameFirstFrame = new jetL1_highFlame1();
            highFlameFirstFrame.x += WordConstants.JET_FLAME_POSTION_X;
            highFlameFirstFrame.y -= WordConstants.JET_FLAME_POSTION_Y;
            highFlameFirstFrame.name = "highFlameFirstFrame";
        }

        override public function destruction():void
        {
            universe.getScore.inc(WordConstants.JET_SCORE_INC);
            super.destruction();
        }

    }
}