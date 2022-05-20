﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ВызватьИсключение НСтр("ru = 'Настройка параметров серверной ИБ доступна только в клиент-серверном режиме работы.'");
		Возврат;
	КонецЕсли;
		
	ПараметрыАдминистрирования = СоединенияИБ.ПолучитьПараметрыАдминистрированияИБ();
	
	ИмяАдминистратораКластера	= ПараметрыАдминистрирования.ИмяАдминистратораКластера;
	ПарольАдминистратораКластера= ПараметрыАдминистрирования.ПарольАдминистратораКластера;
	ПортАгентаСервера			= ПараметрыАдминистрирования.ПортАгентаСервера;
	ПортКластераСерверов		= ПараметрыАдминистрирования.ПортКластераСерверов;
	
	НестандартныеПорты			= ПортКластераСерверов <> 0 ИЛИ ПортАгентаСервера <> 0;
	КластерТребуетАвторизации	= НЕ ПустаяСтрока(ИмяАдминистратораКластера);
		
	Элементы.ГруппаПорты.Доступность = НестандартныеПорты;
	Элементы.ГруппаАвторизацияКластера.Доступность = КластерТребуетАвторизации;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура Записать(Команда)
	
	ОчиститьСообщения();
	ПараметрыПодключения = СохранитьПараметрыПодключения(КластерТребуетАвторизации,
		ИмяАдминистратораКластера, ПарольАдминистратораКластера, НестандартныеПорты,
		ПортАгентаСервера, ПортКластераСерверов);
	
	Если ПараметрыПодключения = Неопределено Тогда
		Возврат;
	КонецЕсли;							
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КластерТребуетАвторизацииПриИзменении(Элемент)
	
	УстановитьСостояниеПолей()
	
КонецПроцедуры

&НаКлиенте
Процедура НестандартныеПортыПриИзменении(Элемент)
	
	УстановитьСостояниеПолей();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьСостояниеПолей()
	
	Элементы.ГруппаПорты.Доступность = НестандартныеПорты;
	Элементы.ГруппаАвторизацияКластера.Доступность = КластерТребуетАвторизации;
	
КонецПроцедуры

&НаСервере
Функция СохранитьПараметрыПодключения(КластерТребуетАвторизации,
	ИмяАдминистратораКластера, ПарольАдминистратораКластера, НестандартныеПорты,
	ПортАгентаСервера, ПортКластераСерверов)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Неопределено;	
	КонецЕсли;
		
	ПараметрыАдминистрирования = СоединенияИБ.ПолучитьПараметрыАдминистрированияИБ();
		
	Если КластерТребуетАвторизации Тогда
		ПараметрыАдминистрирования.ИмяАдминистратораКластера = ИмяАдминистратораКластера;
		ПараметрыАдминистрирования.ПарольАдминистратораКластера = ПарольАдминистратораКластера;
	Иначе	
		ПараметрыАдминистрирования.ИмяАдминистратораКластера = "";
		ПараметрыАдминистрирования.ПарольАдминистратораКластера = "";
	КонецЕсли;
	
	Если НестандартныеПорты Тогда
		ПараметрыАдминистрирования.ПортКластераСерверов = ПортКластераСерверов;
		ПараметрыАдминистрирования.ПортАгентаСервера = ПортАгентаСервера;
	Иначе	
		ПараметрыАдминистрирования.ПортКластераСерверов = 0;
		ПараметрыАдминистрирования.ПортАгентаСервера = 0;
	КонецЕсли;	
	
	Константы.ПараметрыАдминистрированияИБ.Установить(Новый ХранилищеЗначения(ПараметрыАдминистрирования));
	
	СоединенияИБ.ЗаписатьПараметрыАдминистрированияИБ(ПараметрыАдминистрирования);
	
	Возврат ПараметрыАдминистрирования;
	
КонецФункции


