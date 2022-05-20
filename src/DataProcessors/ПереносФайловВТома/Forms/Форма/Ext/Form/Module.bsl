﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЧислоВерсийВБазе = ПолучитьЧислоВерсийВБазе();
	ТипХраненияВТомах = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске;
	
	РазмерВерсийВБазеВБайтах = ПолучитьРазмерВерсийВБазе();
	РазмерВерсийВБазе = РазмерВерсийВБазеВБайтах / 1048576;
	
	
	ДополнительныеПараметры = Новый Структура;
	
	ДополнительныеПараметры.Вставить(
		"ПриОткрытииХранитьФайлыВТомахНаДиске",
		ФайловыеФункцииСлужебный.ПолучитьКонстантуХранитьФайлыВТомахНаДиске());
	
	ДополнительныеПараметры.Вставить(
		"ПриОткрытииЕстьТомаХраненияФайлов",
		ФайловыеФункцииСлужебный.ЕстьТомаХраненияФайлов());
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРазмерВерсийВБазе()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(СУММА(ВерсииФайлов.Размер), 0) КАК Размер
		|ИЗ
		|	Справочник.ВерсииФайлов КАК ВерсииФайлов
		|ГДЕ
		|	ВерсииФайлов.ТипХраненияФайла = &ТипХраненияФайла";
	Запрос.УстановитьПараметр("ТипХраненияФайла", Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Размер;
	
КонецФункции

&НаСервере
Функция ПолучитьЧислоВерсийВБазе()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ИЗ
		|	Справочник.ВерсииФайлов КАК ВерсииФайлов
		|ГДЕ
		|	ВерсииФайлов.ТипХраненияФайла = &ТипХраненияФайла";
	Запрос.УстановитьПараметр("ТипХраненияФайла", Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Количество;
	
КонецФункции

&НаСервере
Функция ПолучитьМассивВерсийВБазе()
	
	МассивВерсий = Новый Массив;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВерсииФайлов.Ссылка КАК Ссылка,
		|	ВерсииФайлов.ПолноеНаименование КАК ПолноеНаименование,
		|	ВерсииФайлов.Размер КАК Размер
		|ИЗ
		|	Справочник.ВерсииФайлов КАК ВерсииФайлов
		|ГДЕ
		|	ВерсииФайлов.ТипХраненияФайла = &ТипХраненияФайла";
	Запрос.УстановитьПараметр("ТипХраненияФайла", Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе);
	
	Результат = Запрос.Выполнить();
	ТаблицаВыгрузки = Результат.Выгрузить();
	
	Для Каждого Строка Из ТаблицаВыгрузки Цикл
		ВерсияСтруктура = Новый Структура("Ссылка, Текст, Размер", 
			Строка.Ссылка, Строка.ПолноеНаименование, Строка.Размер);
		МассивВерсий.Добавить(ВерсияСтруктура);
	КонецЦикла;
	
	Возврат МассивВерсий;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьПереносФайловВТома(Команда)
	
	СвойстваХраненияФайлов = СвойстваХраненияФайлов();
	
	Если СвойстваХраненияФайлов.ТипХраненияФайлов <> ТипХраненияВТомах Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Не установлен тип хранения файлов ""В томах на диске""'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ СвойстваХраненияФайлов.ЕстьТомаХраненияФайлов Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Нет ни одного тома для размещения файлов'"));
		Возврат;
	КонецЕсли;
	
	Если ЧислоВерсийВБазе = 0 Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Нет ни одного файла в информационной базе'"));
		Возврат;
	КонецЕсли;
	
	Результат = Неопределено;

	
	ПоказатьВопрос(Новый ОписаниеОповещения("ВыполнитьПереносФайловВТомаЗавершение1", ЭтотОбъект), 
		НСтр("ru = 'Выполнить перенос файлов в информационной базе в тома хранения файлов?
		           |
		           |Эта операция может занять продолжительное время.'"),
	РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПереносФайловВТомаЗавершение1(РезультатВопроса, ДополнительныеПараметры1) Экспорт
	
	Результат = РезультатВопроса;
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Выполняется получение списка файлов...'"));
	
	МассивВерсий = ПолучитьМассивВерсийВБазе();
	НомерЦикла = 0;
	ЧислоПеренесенных = 0;
	
	ЧислоВерсийВПакете = 10;
	ПакетВерсий = Новый Массив;
	
	МассивФайловСОшибками = Новый Массив;
	ОбработкаПрервана = Ложь;
	
	Для Каждого ВерсияСтруктура Из МассивВерсий Цикл
		
		Прогресс = 0;
		Если ЧислоВерсийВБазе <> 0 Тогда
			Прогресс = НомерЦикла * 100 / ЧислоВерсийВБазе;
		КонецЕсли;
		
		Состояние(НСтр("ru = 'Выполняется перенос файла в том...'"), Прогресс, ВерсияСтруктура.Текст, БиблиотекаКартинок.УстановитьВремя);
		
		ПакетВерсий.Добавить(ВерсияСтруктура);
		
		Если ПакетВерсий.Количество() >= ЧислоВерсийВПакете Тогда
			ЧислоПеренесенныхВПакете = ПеренестиМассивВерсийВТом(ПакетВерсий, МассивФайловСОшибками);
			
			Если ЧислоПеренесенныхВПакете = 0 И ПакетВерсий.Количество() = ЧислоВерсийВПакете Тогда
				ОбработкаПрервана = Истина; // весь пакет не смогли перенести - прекращаем операцию
				Прервать;
			КонецЕсли;	
			
			ЧислоПеренесенных = ЧислоПеренесенных + ЧислоПеренесенныхВПакете;
			ПакетВерсий.Очистить();
			
		КонецЕсли;	
		
		НомерЦикла = НомерЦикла + 1;
	КонецЦикла;	
	
	Если ПакетВерсий.Количество() <> 0 Тогда
		ЧислоПеренесенныхВПакете = ПеренестиМассивВерсийВТом(ПакетВерсий, МассивФайловСОшибками);
		
		Если ЧислоПеренесенныхВПакете = 0 Тогда
			ОбработкаПрервана = Истина; // весь пакет не смогли перенести - прекращаем операцию
		КонецЕсли;	
		
		ЧислоПеренесенных = ЧислоПеренесенных + ЧислоПеренесенныхВПакете;
		ПакетВерсий.Очистить();
	КонецЕсли;	
	
	ЧислоВерсийВБазе = ПолучитьЧислоВерсийВБазе();
	РазмерВерсийВБазеВБайтах = ПолучитьРазмерВерсийВБазе();
	РазмерВерсийВБазе = РазмерВерсийВБазеВБайтах / 1048576;
	
	Если ЧислоПеренесенных <> 0 Тогда
		СтрокаСообщения
		= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Завершен перенос файлов в тома. Перенесено файлов: %1'"),
		ЧислоПеренесенных);
		ПоказатьПредупреждение(Новый ОписаниеОповещения("ВыполнитьПереносФайловВТомаЗавершение", ЭтотОбъект, Новый Структура("МассивФайловСОшибками, ОбработкаПрервана", МассивФайловСОшибками, ОбработкаПрервана)), СтрокаСообщения);
		Возврат;
	КонецЕсли;
	
	ВыполнитьПереносФайловВТомаФрагмент(МассивФайловСОшибками, ОбработкаПрервана);

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПереносФайловВТомаЗавершение(ДополнительныеПараметры1) Экспорт
	
	МассивФайловСОшибками = ДополнительныеПараметры1.МассивФайловСОшибками;
	ОбработкаПрервана = ДополнительныеПараметры1.ОбработкаПрервана;
	
	
	ВыполнитьПереносФайловВТомаФрагмент(МассивФайловСОшибками, ОбработкаПрервана);

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПереносФайловВТомаФрагмент(Знач МассивФайловСОшибками, Знач ОбработкаПрервана)
	
	Перем ПараметрыФормы, Пояснение;
	
	Если МассивФайловСОшибками.Количество() <> 0 Тогда
		
		Пояснение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Количество ошибок при переносе: %1'"),
		МассивФайловСОшибками.Количество());
		
		Если ОбработкаПрервана Тогда
			Пояснение = НСтр("ru = 'Не удалось перенести ни одного файла из пакета. Перенос прерван.'");
		КонецЕсли;	
		
		ПараметрыФормы = Новый Структура("МассивФайловСОшибками, Пояснение", МассивФайловСОшибками, Пояснение);
		ОткрытьФорму("Обработка.ПереносФайловВТома.Форма.ФормаОтчета", ПараметрыФормы);
		
	КонецЕсли;	
	
	Закрыть();

КонецПроцедуры

&НаСервереБезКонтекста
Функция СвойстваХраненияФайлов()
	
	СвойстваХраненияФайлов = Новый Структура;
	
	СвойстваХраненияФайлов.Вставить(
		"ТипХраненияФайлов", ФайловыеФункцииСлужебный.ПолучитьТипХраненияФайлов());
	
	СвойстваХраненияФайлов.Вставить(
		"ЕстьТомаХраненияФайлов", ФайловыеФункцииСлужебный.ЕстьТомаХраненияФайлов());
	
	Возврат СвойстваХраненияФайлов;
	
КонецФункции

&НаСервере
Функция ПеренестиМассивВерсийВТом(ПакетВерсий, МассивФайловСОшибками)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЧислоОбработанных = 0;
	МаксимальныйРазмерФайла = ФайловыеФункцииСлужебный.ПолучитьМаксимальныйРазмерФайла();
	
	Для Каждого ВерсияСтруктура Из ПакетВерсий Цикл
		
		Если ПеренестиВерсиюВТом(ВерсияСтруктура, МаксимальныйРазмерФайла, МассивФайловСОшибками) Тогда
			ЧислоОбработанных = ЧислоОбработанных + 1;
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат ЧислоОбработанных;
	
КонецФункции

&НаСервере
// переносит одну версию в том
Функция ПеренестиВерсиюВТом(ВерсияСтруктура, МаксимальныйРазмерФайла, МассивФайловСОшибками)
	
	Перем СсылкаНаТом;
	
	КодВозврата = Истина;
	
	ВерсияСсылка = ВерсияСтруктура.Ссылка;
	ФайлСсылка = ВерсияСсылка.Владелец;
	Размер = ВерсияСтруктура.Размер;
	ИмяДляЖурнала = "";
	
	Если Размер > МаксимальныйРазмерФайла Тогда
		
		ИмяДляЖурнала = ВерсияСтруктура.Текст;
		ЗаписьЖурналаРегистрации("Перенос не выполнен. Размер файла превышает максимальный.", 
		                         УровеньЖурналаРегистрации.Информация, , 
								 ФайлСсылка,
		                         ИмяДляЖурнала);
		
		Возврат Ложь; // ничего не сообщаем 
	КонецЕсли;	
	
	ИмяДляЖурнала = ВерсияСтруктура.Текст;
	ЗаписьЖурналаРегистрации("Начат перенос файла в том", 
	                         УровеньЖурналаРегистрации.Информация, , 
							 ФайлСсылка,
	                         ИмяДляЖурнала);
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(ФайлСсылка);
	Исключение
		Возврат Ложь; // ничего не сообщаем 
	КонецПопытки;
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(ВерсияСсылка);
	Исключение
		РазблокироватьДанныеДляРедактирования(ФайлСсылка);
		Возврат Ложь; // ничего не сообщаем 
	КонецПопытки;
	
	Попытка
		
		ТипХраненияФайла = ВерсияСсылка.ТипХраненияФайла;
		
		Если ТипХраненияФайла <> Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
		 	// тут файл на диске - так не должно быть
			РазблокироватьДанныеДляРедактирования(ФайлСсылка);
			РазблокироватьДанныеДляРедактирования(ВерсияСсылка);
			Возврат Ложь;
		КонецЕсли;	
		
		НачатьТранзакцию();
		
		ВерсияОбъект = ВерсияСсылка.ПолучитьОбъект();
			
		ХранилищеФайла = РаботаСФайламиВызовСервера.ПолучитьХранилищеФайлаИзИнформационнойБазы(ВерсияСсылка);
		ДвоичныеДанныеФайла = ХранилищеФайла.Получить();
		
		ПутьКФайлуНаТоме = "";
		ФайловыеФункцииСлужебный.ДобавитьНаДиск(ДвоичныеДанныеФайла, ПутьКФайлуНаТоме, СсылкаНаТом, 
			ВерсияСсылка.ДатаМодификацииУниверсальная, 
			ВерсияСсылка.НомерВерсии, ВерсияСсылка.ПолноеНаименование, 
			ВерсияСсылка.Расширение, ВерсияСсылка.Размер,
			ВерсияСсылка.ДатаМодификацииУниверсальная // чтобы все файлы не попали в одну папку - за сегодняшний день - подставляем дату создания файла
		);
		
		ВерсияОбъект.ПутьКФайлу = ПутьКФайлуНаТоме;
		ВерсияОбъект.Том = СсылкаНаТом.Ссылка;
		ВерсияОбъект.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске;
		ВерсияОбъект.ФайлХранилище = Новый ХранилищеЗначения("");
		ВерсияОбъект.Записать();
		
		ФайлОбъект = ФайлСсылка.ПолучитьОбъект();
		ФайлОбъект.Записать(); // для переноса полей версии в файл
		
		РаботаСФайламиВызовСервера.УдалитьЗаписьИзРегистраХранимыеФайлыВерсий(ВерсияСсылка);
		
		ЗафиксироватьТранзакцию();
		
		ЗаписьЖурналаРегистрации("Успешно завершен перенос версии файла в том", 
		                         УровеньЖурналаРегистрации.Информация, , 
								 ФайлСсылка,
		                         ИмяДляЖурнала);
		
	Исключение	
		ОтменитьТранзакцию();
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		СтруктураОшибки = Новый Структура("ИмяФайла, Ошибка, Версия",
			ИмяДляЖурнала, КраткоеПредставлениеОшибки(ИнформацияОбОшибке), ВерсияСсылка);
		МассивФайловСОшибками.Добавить(СтруктураОшибки);
		
		ЗаписьЖурналаРегистрации("Ошибка переноса версии файла в том: " + ИмяДляЖурнала, 
		                         УровеньЖурналаРегистрации.Информация, , 
								 ФайлСсылка,
		                         КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
								 
		КодВозврата = Ложь;
		
	КонецПопытки;
	
	РазблокироватьДанныеДляРедактирования(ФайлСсылка);
	РазблокироватьДанныеДляРедактирования(ВерсияСсылка);
	
	Возврат КодВозврата;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ДополнительныеПараметры.ПриОткрытииХранитьФайлыВТомахНаДиске Тогда
		ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Не установлен тип хранения файлов ""В томах на диске""'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ ДополнительныеПараметры.ПриОткрытииЕстьТомаХраненияФайлов Тогда 
		ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Нет ни одного тома для размещения файлов'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры
