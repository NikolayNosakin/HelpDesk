
&НаКлиенте
Процедура ПриЗакрытии()
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЭтаФорма.Заголовок = Параметры.Заголовок;
	КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(Параметры.ПользовательскиеНастройки);
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	Оповестить("ФормаНастроекДинамическогоСпискаЗакрытие",КомпоновщикНастроек);
	Закрыть();
КонецПроцедуры
