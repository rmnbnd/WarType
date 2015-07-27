package com.wartype.words
{
    import com.wartype.App;
    import com.wartype.Universe;
    import com.wartype.interfaces.IObject;

    public class WordL2 extends WordBase implements IObject
    {

        public function WordL2(wordObject:String, speed:int)
        {
            _sprite = new wordL2_mc(); //Спрайт для слова
            textClip = new textlabel_mc(); //Клип для TextLabel

            wordIntoTextField = wordObject; //Записываем слово, передаваемое в конструктор, в переменную
            wordSplitChars = wordObject.split(''); //Разделяем слово по буквам
            _wordsArrayLenght = wordSplitChars.length; //Записываем размерность массива в переменную
            //trace(wordSplitChars);

            speedY = speed; //Устанавливаем скорость
            _go = true; //Флаг движения (потом понадобится)
            isDead = false; //Флаг "смерти" слова
            isAttacked = false; //Флаг атакуемости слова

            init();
        }

        override public function update(delta:Number):void
        {
            super.update(delta);
            if (this.y >= App.SCR_HEIGHT - 20)
            {
                Universe.getInstance()._gun.setHealth = 10;
                free();
            }
        }

    }
}