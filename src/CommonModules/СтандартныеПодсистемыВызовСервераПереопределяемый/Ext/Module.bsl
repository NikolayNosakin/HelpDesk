﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Переопределяемые процедуры и функции для интеграции между собой подсистем библиотеки БСП.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

/////////////////////////////////////////////////////////////////////////////////
// Базовая функциональность
//

// Заполняет структуру параметров, необходимых для работы клиентского кода
// при запуске конфигурации, т.е. в обработчиках событий
// - ПередНачаломРаботыСистемы,
// - ПриНачалеРаботыСистемы
//
// Важно: при запуске недопустимо использовать команды сброса кэша
// повторно используемых модулей, иначе запуск может привести
// к непредсказуемым ошибкам и лишним серверным вызовам
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
// Возвращаемое значение:
//   Булево   - Ложь, если дальнейшее заполнение параметров необходимо прервать.
//
Функция ДобавитьПараметрыРаботыКлиентскойЛогикиСтандартныхПодсистемПриЗапуске(Параметры) Экспорт
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	Если НЕ СтандартныеПодсистемыСервер.ДобавитьПараметрыРаботыКлиентаПриЗапуске(Параметры) Тогда
		Возврат Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.НапоминанияПользователя
	НапоминанияПользователяСервер.ДобавитьПараметрыРаботыКлиентаПриЗапуске(Параметры);
	// Конец СтандартныеПодсистемы.НапоминанияПользователя
			
	// СтандартныеПодсистемы.ОбновлениеВерсииИБ
	ОбновлениеИнформационнойБазы.ДобавитьПараметрыРаботыКлиентскойЛогикиПриЗапуске(Параметры);
	// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ
			
	// СтандартныеПодсистемы.РегламентныеЗадания
	РегламентныеЗаданияСлужебный.ДобавитьПараметрыРаботыКлиентаПриЗапуске(Параметры);
	// Конец СтандартныеПодсистемы.РегламентныеЗадания
		
	// СтандартныеПодсистемы.ЗавершениеРаботыПользователей
	СоединенияИБ.ДобавитьПараметрыРаботыКлиентскойЛогикиПриЗапуске(Параметры);
	// Конец СтандартныеПодсистемы.ЗавершениеРаботыПользователей
	
	Возврат Истина;
	
КонецФункции

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации. 
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ДобавитьПараметрыРаботыКлиентскойЛогикиСтандартныхПодсистем(Параметры) Экспорт
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	СтандартныеПодсистемыСервер.ДобавитьПараметрыРаботыКлиента(Параметры);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
		
	// СтандартныеПодсистемы.ЗавершениеРаботыПользователей
	СоединенияИБ.ДобавитьПараметрыРаботыКлиента(Параметры);
	// Конец СтандартныеПодсистемы.ЗавершениеРаботыПользователей
	
	// СтандартныеПодсистемы.НапоминанияПользователя
	НапоминанияПользователяСервер.ДобавитьПараметрыРаботыКлиента(Параметры);
	// Конец СтандартныеПодсистемы.НапоминанияПользователя
	
	// СтандартныеПодсистемы.ОбновлениеВерсииИБ
	ОбновлениеИнформационнойБазы.ДобавитьПараметрыРаботыКлиента(Параметры);
	// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ
		
	// СтандартныеПодсистемы.ПолучениеФайловИзИнтернета
	ПолучениеФайловИзИнтернета.ДобавитьПараметрыРаботыКлиента(Параметры);
	// Конец СтандартныеПодсистемы.ПолучениеФайловИзИнтернета
			
	// СтандартныеПодсистемы.РегламентныеЗадания
	РегламентныеЗаданияСлужебный.ДобавитьПараметрыРаботыКлиента(Параметры);
	// Конец СтандартныеПодсистемы.РегламентныеЗадания
		
	// СтандартныеПодсистемы.ФайловыеФункции
	ФайловыеФункцииСлужебный.ДобавитьПараметрыРаботыКлиента(Параметры);
	// Конец СтандартныеПодсистемы.ФайловыеФункции
	
КонецПроцедуры

// Осуществляет копирование общих данных в разделенные.
//
Процедура ПодобратьПоставляемыеДанныеИзКлассификатора(Знач Ссылки, Знач ИгнорироватьРучноеИзменение = Ложь) Экспорт

	
КонецПроцедуры

