﻿
&НаКлиенте
Процедура ОбработкаОжиданияКонтактныеЛица()
	
	Если Элементы.Корреспонденты.ТекущаяСтрока <> Неопределено Тогда 
		СписокКонтактныеЛица.Параметры.УстановитьЗначениеПараметра("Корреспондент", Элементы.Корреспонденты.ТекущаяСтрока);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокКонтактныеЛица.Параметры.УстановитьЗначениеПараметра("Корреспондент", Элементы.Корреспонденты.ТекущаяСтрока);
	
	ЛичныйАдресат = Параметры.ЛичныйАдресат;
	
КонецПроцедуры

&НаКлиенте
Процедура КорреспондентыПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработкаОжиданияКонтактныеЛица", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокКонтактныеЛицаВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если ЭтотОбъект.ТекущийЭлемент = Элементы.СписокКонтактныеЛица Тогда 
		
		Если Элементы.СписокКонтактныеЛица.ТекущаяСтрока = Неопределено Тогда 
			Возврат;
		КонецЕсли;	
	
		ОповеститьОВыборе(Элементы.СписокКонтактныеЛица.ТекущаяСтрока);
		
	Иначе
		
		Если Элементы.Корреспонденты.ТекущаяСтрока = Неопределено Тогда 
			Возврат;
		КонецЕсли;	
	
		ОповеститьОВыборе(Элементы.Корреспонденты.ТекущаяСтрока);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокКонтактныеЛицаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Копирование Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Корреспонденты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;	
	
	Отказ = Истина;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Владелец", ТекущиеДанные.Ссылка);

	ПараметрыФормы = Новый Структура("ЛичныйАдресат", ЛичныйАдресат);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
	ОткрытьФорму("Справочник.КонтактныеЛица.ФормаОбъекта", ПараметрыФормы, Элемент);	
	
КонецПроцедуры

&НаКлиенте
Процедура КорреспондентыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Копирование Тогда 
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЛичныйАдресат", ЛичныйАдресат);
		
	ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КорреспондентыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура КорреспондентыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(ВыбраннаяСтрока);
	
КонецПроцедуры
