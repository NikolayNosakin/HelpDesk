﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Полнотекстовый поиск".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Обновляет индекс полнотекстового поиска.
//
Процедура ОбновлениеИндексаППД() Экспорт
	
	Если ПустаяСтрока(ИмяПользователя()) Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	РазрешитьПолнотекстовыйПоиск = ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить;
	Если РазрешитьПолнотекстовыйПоиск = Ложь Тогда
		Возврат;
	КонецЕсли;	
	
	Попытка
		ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация, , ,
			НСтр("ru = 'Начато регламентное индексирование порции'"));
		
		ПолнотекстовыйПоиск.ОбновитьИндекс(Ложь, Истина);
		
		ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация, , ,
			НСтр("ru = 'Закончено регламентное  индексирование порции'"));
	Исключение
		ТекстСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		  НСтр("ru = 'Во время регламентного обновления индекса произошла неизвестная ошибка.
		             |%1'"), ОписаниеОшибки());
		ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка, , ,
			ТекстСообщенияОбОшибке);
	КонецПопытки;
	
КонецПроцедуры

// Выполняет слияние индексов полнотекстового поиска.
//
Процедура СлияниеИндексаППД() Экспорт
	
	Если ПустаяСтрока(ИмяПользователя()) Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	РазрешитьПолнотекстовыйПоиск = ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить;
	Если РазрешитьПолнотекстовыйПоиск = Ложь Тогда
		Возврат;
	КонецЕсли;	
	
	Попытка
		ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация, , ,
			НСтр("ru = 'Начато регламентное слияние индексов'"));
		
		ПолнотекстовыйПоиск.ОбновитьИндекс(Истина);
		
		ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Информация, , ,
			НСтр("ru = 'Закончено регламентное слияние индексов'"));
	Исключение
		ТекстСообщенияОбОшибке =
		  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		    НСтр("ru = 'Во время регламентного слияния индекса произошла неизвестная ошибка.
		               |%1'"), ОписаниеОшибки());
		ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка, , ,
			ТекстСообщенияОбОшибке);
	КонецПопытки;
	
КонецПроцедуры

// Возвращает, актуален ли индекс полнотекстового поиска. 
//  Если индекс обновлялся менее 5 минут назад, считаем что он актуален 
//  Проверка функциональной опции, например "ИспользоватьПолнотекстовыйПоиск" - выполняется в вызывающем коде
Функция ИндексПоискаАктуален() Экспорт
	
	Если ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить Тогда
		
		// Если индекс обновлялся менее 5 минут назад, считаем что он актуален
		Возврат ПолнотекстовыйПоиск.ИндексАктуален() ИЛИ ТекущаяДата() - ПолнотекстовыйПоиск.ДатаАктуальности() < 300;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает имя, которое используется для записи событий в журнал регистрации.
//
Функция ИмяСобытияЖурналаРегистрации()
	Возврат НСтр("ru = 'Полнотекстовое индексирование'");	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы.

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.3.10";
	Обработчик.Процедура = "ПолнотекстовыйПоискСервер.ИнициализироватьФункциональнуюОпциюПолнотекстовыйПоиск";
	Обработчик.ОбщиеДанные = Истина;
	
КонецПроцедуры	

// Установить константу ИспользоватьПолнотекстовыйПоиск синхронно с ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска()
Процедура ИнициализироватьФункциональнуюОпциюПолнотекстовыйПоиск() Экспорт
	
	ЗначениеКонстанты = ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить;
	Константы.ИспользоватьПолнотекстовыйПоиск.Установить(ЗначениеКонстанты);
	
КонецПроцедуры

