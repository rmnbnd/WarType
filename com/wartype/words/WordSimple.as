package com.wartype.words
{
    import com.wartype.App;
    import com.wartype.guns.GunBase;
    import com.wartype.interfaces.IObject;

    import flash.text.TextField;

    import flash.text.TextFormat;

    public class WordSimple extends WordBase implements IObject
    {

        public function WordSimple(wordObject:String, speed:int)
        {
            _sprite = new word_mc(); //Спрайт для слова
            textClip = new textlabel_mc(); //Клип для TextLabel

            wordIntoTextField = wordObject; //Записываем слово, передаваемое в конструктор, в переменную
            wordSplitChars = wordObject.split(''); //Разделяем слово по буквам
            _wordsArrayLenght = wordSplitChars.length; //Записываем размерность массива в переменную
            trace(wordSplitChars);

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
                _gun.setHealth = 10;
                free();
            }
        }

        override public function damage():void
        {
            //Выводим слово после нанесения урона
            wordIntoTextField = '';
            wordSplitChars.shift();
            for (var i:int = 0; i < wordSplitChars.length; i++)
            {
                wordIntoTextField += wordSplitChars[i].toString();
            }

            if (wordSplitChars.length <= 0 || this.y >= App.SCR_HEIGHT)
            {
                _textLabel.visible = false;
                isDead = true;
                GunBase.isAttackedWord = false;
            }
        }

        override public function destruction():void
        {
            _wordsArrayLenght--;
            super.destruction();
        }

    }
}