﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	 ТекПользователь = Пользователи.ТекущийПользователь();
	 СписокЗаявокПоИсполнителю.Параметры.УстановитьЗначениеПараметра("Ответственный", ТекПользователь);
	 
	 Если ПолучитьФункциональнуюОпцию("ВестиУчетПоОрганизациям") Тогда
		ИспользоватьУчетПоОрганизациям = Истина;
	Иначе
		ИспользоватьУчетПоОрганизациям = Ложь;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоКонтрагентам") Тогда
		ИспользоватьУчетПоКонтрагентам = Истина;
	Иначе
		ИспользоватьУчетПоКонтрагентам = Ложь;
	КонецЕсли;
	
 КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ) 	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок()
	Элементы.СписокМоихЗаявок.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура СписокМоихЗаявокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		СтандартнаяОбработка = Ложь;
		Если Элементы.СписокМоихЗаявок.Развернут(ВыбраннаяСтрока) Тогда
            Элементы.СписокМоихЗаявок.Свернуть(ВыбраннаяСтрока);
        иначе
            Элементы.СписокМоихЗаявок.Развернуть(ВыбраннаяСтрока);
        КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдаление(Команда)
	ТекТабл = ЭтотОбъект.ТекущийЭлемент;
	Если ТипЗнч(ТекТабл) = Тип("ТаблицаФормы") Тогда
		ТекДок = ТекТабл.ТекущаяСтрока;
		Если ТипЗнч(ТекДок) = Тип("ДокументСсылка.Заявка") тогда
			РаботаСЗаявками.ОбработатьУдалениеЗаявки(ТекДок);
		КонецЕсли;
		ТекТабл.Обновить()	
	КонецЕсли;
КонецПроцедуры

