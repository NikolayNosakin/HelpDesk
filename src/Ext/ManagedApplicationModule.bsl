﻿
// СтандартныеПодсистемы

// СтандартныеПодсистемы.БазоваяФункциональность

// СписокЗначений для накапливания пакета сообщений в журнал регистрации, 
// формируемых в клиентской бизнес-логике.
Перем СообщенияДляЖурналаРегистрации Экспорт; 
// Признак того, что в данном сеансе не нужно повторно предлагать установку
Перем ПредлагатьУстановкуРасширенияРаботыСФайлами Экспорт;
// Признак того, что в данном сеансе не нужно запрашивать стандартное подтверждение при выходе
Перем ПропуститьПредупреждениеПередЗавершениемРаботыСистемы Экспорт;

// Конец СтандартныеПодсистемы.БазоваяФункциональность

// СтандартныеПодсистемы.ЗавершениеРаботыПользователей
Перем РаботаПользователейЗавершается Экспорт;
// Конец СтандартныеПодсистемы.ЗавершениеРаботыПользователей

// СтандартныеПодсистемы.РаботаСФайлами
Перем КомпонентаTwain Экспорт; // Twain компонента для работы со сканером
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.ФайловыеФункции
// Признак того, что в данном сеансе не нужно повторно делать проверку доступа к каталогу на диске
Перем ПроверкаДоступаКРабочемуКаталогуВыполнена Экспорт;
// Конец СтандартныеПодсистемы.ФайловыеФункции

// Конец СтандартныеПодсистемы

Перем КомпонентаПолученияКартинкиИзБуфера Экспорт; // компонента получения картинки из буфера обмена

Перем ЗавершитьРаботуСистемы Экспорт;
Перем глЗапрашиватьПодтверждениеПриЗавершенииПрограммы Экспорт;

Процедура ПередНачаломРаботыСистемы(Отказ)
	РаботаСИнтефейсамиСервер.ВыполнитьНастройкуПанелей();
	
	ОбновитьИнтерфейс();
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ДействияПередНачаломРаботыСистемы(Отказ);
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ДействияПриНачалеРаботыСистемы(Истина);
	// Конец СтандартныеПодсистемы
	
	
	Если Лев(ПараметрЗапуска ,3)="LNK"Тогда
		
		НавигационнаяСтрокаСсылка = СтрЗаменить(ПараметрЗапуска,"LNK","");
		НавигационнаяСтрокаСсылка = СтрЗаменить(НавигационнаяСтрокаСсылка,Сред(НавигационнаяСтрокаСсылка,1,СтрНайти(НавигационнаяСтрокаСсылка,"#")),"");

		Попытка
			
			ПерейтиПоНавигационнойСсылке(НавигационнаяСтрокаСсылка);
			
		Исключение
			
		КонецПопытки;

	КонецЕсли;
	
	//Кострицын Олег-Старт  27 февраля 2019 г.
	глЗапрашиватьПодтверждениеПриЗавершенииПрограммы = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЗапрашиватьПодтверждениеПриЗавершенииПрограммы;
	//Кострицын Олег-финиш  27 февраля 2019 г.
	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ,ТекстПредупреждения)
	
	Если ЗавершитьРаботуСистемы = Истина Тогда
		//Завершаем работу системы без вопросов
	Иначе	
		// СтандартныеПодсистемы
		//СтандартныеПодсистемыКлиент.ДействияПередЗавершениемРаботыСистемы(Отказ);
		// Конец СтандартныеПодсистемы
		
		Если глЗапрашиватьПодтверждениеПриЗавершенииПрограммы = Истина Тогда
			ТекстПредупреждения = НСтр("ru = 'Завершить работу с программой?'");
			Отказ = Истина;
		КонецЕсли;

		ЗавершитьРаботуСистемы = не Отказ;
	КонецЕсли;
КонецПроцедуры

