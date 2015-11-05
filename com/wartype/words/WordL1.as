package com.wartype.words
{
    import com.wartype.App;
    import com.wartype.Universe;
    import com.wartype.interfaces.IObject;

    import flash.display.Sprite;

    public class WordL1 extends WordBase implements IObject
    {

        public function WordL1(wordObject:String, speed:int, timerWord:uint)
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
            _sprite = new wordL1_mc();
            textClip = new textlabel_mc();
        }

    }
}