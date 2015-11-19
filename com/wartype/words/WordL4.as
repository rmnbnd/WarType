package com.wartype.words
{
    import com.wartype.App;
    import com.wartype.MainConstants;
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
            wordsArrayLength = wordSplitChars.length; //Записываем размерность массива в переменную

            setSpeedY = speed;
            go = true;
            isDead = false;
            isAttacked = false;
            throwTimeWord = timerWord;

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
            leftBladeSprite.rotation += WordConstants.OSPREY_BLADES_ROTATION_SPEED;
            rightBladeSprite.rotation += WordConstants.OSPREY_BLADES_ROTATION_SPEED;
            super.update(delta);
            if (this.y >= MainConstants.SCR_HEIGHT - WordConstants.OSPREY_BOTTOM_MARGIN)
            {
                Universe.getInstance().gun.setHealth = WordConstants.OSPREY_DAMAGE;
                free();
            }
        }

        private function createSpritesForScene():void
        {
            sprite = new wordL4_mc();
            textClip = new textlabel_mc();
            leftBladeSprite = new ospreyBlade_mc();
            rightBladeSprite = new ospreyBlade_mc();
            bladeConusesSprite = new bladeConuses_mc();
            leftBladeSprite.x -= WordConstants.OSPREY_BLADE_POSITION_X;
            leftBladeSprite.y += WordConstants.OSPREY_BLADE_POSITION_Y;
            rightBladeSprite.x += WordConstants.OSPREY_BLADE_POSITION_X;
            rightBladeSprite.y += WordConstants.OSPREY_BLADE_POSITION_Y;
        }

    }
}