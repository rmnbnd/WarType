package com.wartype.words
{
    import com.wartype.App;
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

            getSpeedY = speed; //Устанавливаем скорость
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

        private function createSpritesForScene():void
        {
            sprite = new wordL1_mc();
            textClip = new textlabel_mc();
        }

    }
}