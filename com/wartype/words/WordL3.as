package com.wartype.words
{
    import com.wartype.MainConstants;
    import com.wartype.Universe;
    import com.wartype.interfaces.IObject;

    public class WordL3 extends WordBase implements IObject
    {

        public function WordL3(wordObject:String, speed:int, timerWord:uint)
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
            if (this.y >= MainConstants.SCR_HEIGHT - WordConstants.ENTERPRISE_BOTTOM_MARGIN)
            {
                Universe.getInstance().gun.setHealth = WordConstants.ENTERPRISE_DAMAGE;
                free();
            }
        }

        override public function boost():void
        {
            setSpeedY = getSpeedY + 20;
            setCurrentSpeed = getSpeedY;
            if(highFlameFirstFrame != null && highFlameFirstFrame.height < WordConstants.ENTERPRISE_MAX_FLAME_HEIGHT)
            {
                if(getChildByName("highFlameFirstFrame") == null)
                {
                    addChildAt(highFlameFirstFrame, 0);
                }
                highFlameFirstFrame.height += 5;
            }
        }

        override public function destruction():void
        {
            universe.getScore.inc(WordConstants.ENTERPRISE_SCORE_INC);
            super.destruction();
        }

        private function createSpritesForScene():void
        {
            sprite = new wordL3_mc();
            textClip = new textlabel_mc();
            highFlameFirstFrame = new jetL3_highFlame1();
            highFlameFirstFrame.x += WordConstants.ENTERPRISE_FLAME_POSTION_X;
            highFlameFirstFrame.y -= WordConstants.ENTERPRISE_FLAME_POSTION_Y;
            highFlameFirstFrame.name = "highFlameFirstFrame";
        }

    }
}