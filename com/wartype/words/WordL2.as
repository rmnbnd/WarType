package com.wartype.words
{
    import com.wartype.MainConstants;
    import com.wartype.Universe;
    import com.wartype.interfaces.IObject;

    import flash.display.Sprite;

    public class WordL2 extends WordBase implements IObject
    {
        private var bladesSprite:Sprite;
        private var bladeConusesSprite:Sprite;

        public function WordL2(wordObject:String, speed:int, timerWord:uint)
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

            if (bladesSprite != null && bladeConusesSprite != null)
            {
                addChild(bladesSprite);
                addChild(bladeConusesSprite);
            }
        }

        override public function update(delta:Number):void
        {
            bladesSprite.rotation+=WordConstants.HELI_BLADES_ROTATION_SPEED;
            super.update(delta);
            if (this.y >= MainConstants.SCR_HEIGHT - WordConstants.HELI_BOTTOM_MARGIN)
            {
                Universe.getInstance().gun.setHealth = WordConstants.HELI_DAMAGE;
                free();
            }
        }

        override public function boost():void
        {
            setSpeedY = getSpeedY + 20;
            setCurrentSpeed = getSpeedY;
        }

        override public function destruction():void
        {
            universe.getScore.inc(WordConstants.HELI_SCORE_INC);
            super.destruction();
        }

        private function createSpritesForScene():void
        {
            highlight = new L1Highlight_mc();
            sprite = new wordL2_mc();
            textClip = new textLabelL2_mc();
            bladesSprite = new heliBlade_mc();
            bladeConusesSprite = new heliConus_mc();
            bladeConusesSprite.y += WordConstants.HELI_BLADE_POSITION_Y;
            bladesSprite.y += WordConstants.HELI_BLADE_POSITION_Y;
        }

    }
}