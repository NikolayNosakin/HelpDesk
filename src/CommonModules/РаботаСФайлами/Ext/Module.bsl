﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с файлами".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Обработчик события ПриЗаписи. Определен для объектов (кроме Документ), владельцев Файла.
Процедура УстановитьПометкуУдаленияФайловПередЗаписью(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда 
        Возврат;  
	КонецЕсли; 
	
	Если Источник.ПометкаУдаления <> Источник.Ссылка.ПометкаУдаления Тогда 
		РаботаСФайламиВызовСервера.ПометитьНаУдалениеПриложенныеФайлы(Источник.Ссылка, Источник.ПометкаУдаления);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события ПриЗаписи. Определен для объектов типа Документ, владельцев Файла.
Процедура УстановитьПометкуУдаленияФайловДокументовПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда 
        Возврат;  
	КонецЕсли; 
	
	Если Источник.ПометкаУдаления <> Источник.Ссылка.ПометкаУдаления Тогда 
		РаботаСФайламиВызовСервера.ПометитьНаУдалениеПриложенныеФайлы(Источник.Ссылка, Источник.ПометкаУдаления);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

//АбисСофт-Кострицын Олег-Старт 27 января 2013 г.
Процедура ФайлПриЗаписи(Источник, Отказ) Экспорт
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиВызовСервера.ПриЗаписиФайлаСервер(Источник);

КонецПроцедуры
 //АбисСофт-Кострицын Олег-Финиш 27 января 2013 г.

 // Получает полный путь к файлу на диске
// Параметры
//  Файл  - СправочникСсылка.Файлы 
//
// Возвращаемое значение:
//   Двоичные данные файла 
Функция ПолучитьДвоичныеДанныеФайла(ПрисоединенныйФайл) Экспорт
		
	УстановитьПривилегированныйРежим(Истина);
		
	ВерсияСсылка = ПрисоединенныйФайл.ТекущаяВерсия;
		
	Если ВерсияСсылка.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
		ХранилищеФайла = РаботаСФайламиВызовСервера.ПолучитьХранилищеФайлаИзИнформационнойБазы(ВерсияСсылка);

		Попытка
			Возврат ХранилищеФайла.Получить();
		Исключение
			// Запись в журнал регистрации.
			СообщениеОбОшибке = ТекстОшибкиПриПолученииФайла(ИнформацияОбОшибке(), ПрисоединенныйФайл);
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Получение данных файла файла из базы'"),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники[ПрисоединенныйФайл.Метаданные().Имя],
				ПрисоединенныйФайл,
				СообщениеОбОшибке);
				
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка открытия файла: файл не найден в информационной базе.
				           |Обратитесь к администратору.
				           |
				           |Файл: ""%1.%2"".'"),
				ВерсияСсылка.Наименование,
				ВерсияСсылка.Расширение);
		КонецПопытки;
	Иначе
		ПолныйПуть = ФайловыеФункцииСлужебный.ПолныйПутьТома(ВерсияСсылка.Том) + ВерсияСсылка.ПутьКФайлу;
		
		Попытка
			Возврат Новый ДвоичныеДанные(ПолныйПуть)
		Исключение
			// Запись в журнал регистрации.
			СообщениеОбОшибке = ТекстОшибкиПриПолученииФайла(ИнформацияОбОшибке(), ПрисоединенныйФайл);
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Получение файла из тома'"),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники[ПрисоединенныйФайл.Метаданные().Имя],
				ПрисоединенныйФайл,
				СообщениеОбОшибке);
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка открытия файла: файл не найден на сервере.
				           |Обратитесь к администратору.
				           |
				           |Файл: ""%1.%2"".'"),
				ВерсияСсылка.Наименование,
				ВерсияСсылка.Расширение);
		КонецПопытки;
	КонецЕсли;	
КонецФункции

// Возвращает текст сообщения об ошибке, добавляя к нему ссылку на элемент
// справочника хранимого файла.
//
Функция ТекстОшибкиПриПолученииФайла(Знач ИнформацияОбОшибке, Знач Файл)
	
	СообщениеОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	
	Если Файл <> Неопределено Тогда
		СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1
			           |
			           |Ссылка на файл: ""%2"".'"),
			СообщениеОбОшибке,
			ПолучитьНавигационнуюСсылку(Файл) );
	КонецЕсли;
	
	Возврат СообщениеОбОшибке;
	
КонецФункции
