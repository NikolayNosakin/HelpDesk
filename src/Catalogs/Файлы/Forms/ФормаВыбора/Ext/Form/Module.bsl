﻿&НаКлиенте
Процедура ГруппыПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
КонецПроцедуры

// Процедура обновляет список Файлов
&НаКлиенте
Процедура ОбработкаОжидания()
	
	Если Элементы.Папки.ТекущаяСтрока <> Неопределено Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Владелец", Элементы.Папки.ТекущаяСтрока);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ВладелецФайла") Тогда 
		Список.Параметры.УстановитьЗначениеПараметра(
			"Владелец", Параметры.ВладелецФайла);
	
		Если ТипЗнч(Параметры.ВладелецФайла) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
			Элементы.Папки.ТекущаяСтрока = Параметры.ВладелецФайла;
			Элементы.Папки.ВыделенныеСтроки.Очистить();
			Элементы.Папки.ВыделенныеСтроки.Добавить(Элементы.Папки.ТекущаяСтрока);
		Иначе
			Элементы.Папки.Видимость = Ложь;
		КонецЕсли;
	Иначе	
		Если Параметры.Свойство("ВыборШаблона") И Параметры.ВыборШаблона Тогда 	
			Элементы.Папки.ТекущаяСтрока = Справочники.ПапкиФайлов.Шаблоны;
			Элементы.Папки.ВыделенныеСтроки.Очистить();
			Элементы.Папки.ВыделенныеСтроки.Добавить(Элементы.Папки.ТекущаяСтрока);
		Иначе
			Группы.Отбор.Элементы.Очистить();
		КонецЕсли;	
		
		Список.Параметры.УстановитьЗначениеПараметра("Владелец", Элементы.Папки.ТекущаяСтрока);
	КонецЕсли;
	
	Если Параметры.Свойство("ТекущаяСтрока") Тогда 
		Элементы.Папки.ТекущаяСтрока = Параметры.ТекущаяСтрока;
	КонецЕсли;
	
КонецПроцедуры

