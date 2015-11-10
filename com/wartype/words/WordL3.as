package com.wartype.words
{
    import com.wartype.App;
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
            if (this.y >= App.SCR_HEIGHT - 20)
            {
                Universe.getInstance().gun.setHealth = 10;
                free();
            }
        }

        private function createSpritesForScene():void
        {
            sprite = new wordL3_mc();
            textClip = new textlabel_mc();
        }

    }
}