package com.wartype.words
{
    import com.wartype.App;
    import com.wartype.Universe;
    import com.wartype.interfaces.IObject;

    import flash.display.Sprite;

    public class WordL4 extends WordBase implements IObject
    {

        private var leftBladeSprite:Sprite;
        private var rightBladeSprite:Sprite;
        private var bladeConusesSprite:Sprite;

        public function WordL4(wordObject:String, speed:int, timerWord:uint)
        {
            createSpritesForScene();

            wordIntoTextField = wordObject; //Записываем слово, передаваемое в конструктор, в переменную
            wordSplitChars = wordObject.split(''); //Разделяем слово по буквам
            _wordsArrayLenght = wordSplitChars.length; //Записываем размерность массива в переменную

            speedY = speed; //Устанавливаем скорость
            _go = true; //Флаг движения (потом понадобится)
            isDead = false; //Флаг "смерти" слова
            isAttacked = false; //Флаг атакуемости слова
            _throwTimeWord = timerWord;

            init();

            if (leftBladeSprite != null && rightBladeSprite != null
                    && bladeConusesSprite != null)
            {
                addChild(leftBladeSprite);
                addChild(rightBladeSprite);
                addChild(bladeConusesSprite);
            }
        }

        override public function update(delta:Number):void
        {
            leftBladeSprite.rotation+=56;
            rightBladeSprite.rotation+=56;
            super.update(delta);
            if (this.y >= App.SCR_HEIGHT - 20)
            {
                Universe.getInstance().gun.setHealth = 10;
                free();
            }
        }

        private function createSpritesForScene():void
        {
            _sprite = new wordL4_mc();
            textClip = new textlabel_mc();
            leftBladeSprite = new ospreyBlade_mc();
            rightBladeSprite = new ospreyBlade_mc();
            bladeConusesSprite = new bladeConuses_mc();
            leftBladeSprite.x -= 90;
            leftBladeSprite.y += 7;
            rightBladeSprite.x += 90;
            rightBladeSprite.y += 7;
        }

    }
}