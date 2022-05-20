﻿////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВключеноИзвлечениеТекста = Ложь;
	
	ИнтервалВремениВыполнения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("АвтоматическоеИзвлечениеТекстов", "ИнтервалВремениВыполнения");
	Если ИнтервалВремениВыполнения = 0 Тогда
		ИнтервалВремениВыполнения = 60;
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("АвтоматическоеИзвлечениеТекстов", "ИнтервалВремениВыполнения",  ИнтервалВремениВыполнения);
	КонецЕсли;
	
	СтандартныеПодсистемыПереопределяемый.ПолучитьКоличествоВерсийСНеизвлеченнымТекстом(
		КоличествоФайловСНеизвлеченнымТекстом);
	
	КоличествоФайловВПорции = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("АвтоматическоеИзвлечениеТекстов", "КоличествоФайловВПорции");
	Если КоличествоФайловВПорции = 0 Тогда
		КоличествоФайловВПорции = 100;
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("АвтоматическоеИзвлечениеТекстов", "КоличествоФайловВПорции",  КоличествоФайловВПорции);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
#Если ВебКлиент Тогда
	Отказ = Истина;
	ПоказатьПредупреждение(Неопределено, НСтр("ru = 'В Веб-клиенте извлечение текстов не поддерживается.'"));
	Возврат;
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалВремениВыполненияПриИзменении(Элемент)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("АвтоматическоеИзвлечениеТекстов", "ИнтервалВремениВыполнения",  ИнтервалВремениВыполнения);
	
	Если ВключеноИзвлечениеТекста Тогда
		ОтключитьОбработчикОжидания("ИзвлечениеТекстовКлиентОбработчик");
		// здесь ТекущаяДата() не пишется в базу - только на клиенте показывается в информационных целях - поэтому заменять на ТекущаяДатаСеанса не надо
		ПрогнозируемоеВремяНачалаИзвлечения = ТекущаяДата() + ИнтервалВремениВыполнения;
		ПодключитьОбработчикОжидания("ИзвлечениеТекстовКлиентОбработчик", ИнтервалВремениВыполнения);
		ОбновлениеОбратногоОтсчета();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики команд формы
//

////////////////////////////////////////////////////////////////////////////////
// Служебные
//

&НаСервереБезКонтекста
Процедура ЗаписьЖурналаРегистрацииСервер(ТекстСообщения)
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Извлечение текста файла'"), УровеньЖурналаРегистрации.Ошибка, , , ТекстСообщения);
	
КонецПроцедуры

// Обновляет обратный отсчет
//
&НаКлиенте
Процедура ОбновлениеОбратногоОтсчета()
	
	// здесь ТекущаяДата() не пишется в базу - только на клиенте показывается в информационных целях - поэтому заменять на ТекущаяДатаСеанса не надо
	Осталось = ПрогнозируемоеВремяНачалаИзвлечения - ТекущаяДата();
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'До начала извлечения текстов осталось %1 сек'"), 
							Осталось);
	
	Если Осталось <= 1 Тогда
		ТекстСообщения = "";
	КонецЕсли;
	
	ИнтервалВремениВыполнения = Элементы.ИнтервалВремениВыполнения.ТекстРедактирования;
	Статус = ТекстСообщения;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзвлечениеТекстовКлиентОбработчик()
	
#Если НЕ ВебКлиент Тогда
	ИзвлечениеТекстовКлиент();
#КонецЕсли	

КонецПроцедуры

#Если НЕ ВебКлиент Тогда
// Извлекает текст из файлов на диске на клиенте
&НаКлиенте
Процедура ИзвлечениеТекстовКлиент(РазмерПорции = Неопределено)
	
	// Здесь ТекущаяДата() не пишется в базу, показывается только на клиенте
	// в информационных целях - поэтому не нужно заменять на ТекущаяДатаСеанса.
	ПрогнозируемоеВремяНачалаИзвлечения = ТекущаяДата() + ИнтервалВремениВыполнения;
	
	Состояние(НСтр("ru = 'Начато извлечение текста'"));
	
	Попытка
		
		РазмерПорцииТекущий = КоличествоФайловВПорции;
		Если РазмерПорции <> Неопределено Тогда
			РазмерПорцииТекущий = РазмерПорции;
		КонецЕсли;
		МассивФайлов = ПолучитьФайлыДляИзвлеченияТекста(РазмерПорцииТекущий);
		
		Если МассивФайлов.Количество() = 0 Тогда
			Состояние(НСтр("ru = 'Нет файлов для извлечения текста'"));
			Возврат;
		КонецЕсли;
		
		Для Индекс = 0 По МассивФайлов.Количество() - 1 Цикл
			
			Расширение = МассивФайлов[Индекс].Расширение;
			НаименованиеФайла = МассивФайлов[Индекс].Наименование;
			ФайлИлиВерсияФайла = МассивФайлов[Индекс].Ссылка;
			Кодировка = МассивФайлов[Индекс].Кодировка;
			
			Попытка
				
				АдресФайла = ПолучитьНавигационнуюСсылкуФайла(
					ФайлИлиВерсияФайла, УникальныйИдентификатор);
				
				ИмяСРасширением = ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьИмяСРасширением(
					НаименованиеФайла, Расширение);
				
				Прогресс = Индекс * 100 / МассивФайлов.Количество();
				Состояние(НСтр("ru = 'Идет извлечение текста файла'"), Прогресс, ИмяСРасширением);
				
				ФайловыеФункцииСлужебныйКлиент.ИзвлечьТекстВерсии(
					ФайлИлиВерсияФайла, АдресФайла, Расширение, УникальныйИдентификатор, Кодировка);
			
			Исключение
				
				ОписаниеОшибкиИнфо = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
				
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Во время извлечения текста из файла ""%1"" произошла неизвестная ошибка.'"),
					Строка(ФайлИлиВерсияФайла));
				
				ТекстСообщения = ТекстСообщения + Строка(ОписаниеОшибкиИнфо);
				
				Состояние(ТекстСообщения);
				
				РезультатИзвлечения = "ИзвлечьНеУдалось";
				ЗаписьОшибкиИзвлечения(ФайлИлиВерсияФайла, РезультатИзвлечения, ТекстСообщения);
				
			КонецПопытки;
			
		КонецЦикла;
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Извлечение текста завершено. Обработано файлов: %1'"),
			МассивФайлов.Количество());
		
		Состояние(ТекстСообщения);
		
	Исключение
		
		ОписаниеОшибкиИнфо = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Во время извлечения текста из файла ""%1"" произошла неизвестная ошибка.'"),
			Строка(ФайлИлиВерсияФайла));
		
		ТекстСообщения = ТекстСообщения + Строка(ОписаниеОшибкиИнфо);
		
		Состояние(ТекстСообщения);
		
		ЗаписьЖурналаРегистрацииСервер(ТекстСообщения);
		
	КонецПопытки;
	
	ПолучитьКоличествоВерсийСНеизвлеченнымТекстом(КоличествоФайловСНеизвлеченнымТекстом);
	
КонецПроцедуры
#КонецЕсли

&НаСервереБезКонтекста
Процедура ЗаписьОшибкиИзвлечения(ФайлИлиВерсияФайла, РезультатИзвлечения, ТекстСообщения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ФайловыеФункцииСлужебный.ЗаписатьРезультатИзвлеченияТекста(ФайлИлиВерсияФайла, РезультатИзвлечения, "");
	
	// запись в журнал регистрации
	ЗаписьЖурналаРегистрацииСервер(ТекстСообщения);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьФайлыДляИзвлеченияТекста(КоличествоФайловВПорции)
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	ПолучитьВсеФайлы = (КоличествоФайловВПорции = 0);
	
	СтандартныеПодсистемыПереопределяемый.ПолучитьТекстЗапросаДляИзвлеченияТекста(
		Запрос.Текст, ПолучитьВсеФайлы);
	
	Для Каждого Строка Из Запрос.Выполнить().Выгрузить() Цикл
		
		Кодировка = ФайловыеФункцииСлужебный.ПолучитьКодировкуВерсииФайла(Строка.Ссылка);
		
		Результат.Добавить(Новый Структура("Ссылка, Расширение, Наименование, Кодировка",
			Строка.Ссылка, Строка.Расширение, Строка.Наименование, Кодировка));
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьНавигационнуюСсылкуФайла(Знач ФайлИлиВерсияФайла, Знач УникальныйИдентификатор)
	
	Возврат СтандартныеПодсистемыПереопределяемый.ПолучитьНавигационнуюСсылкуФайла(
		ФайлИлиВерсияФайла, УникальныйИдентификатор);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПолучитьКоличествоВерсийСНеизвлеченнымТекстом(КоличествоФайловСНеизвлеченнымТекстом)
	
	СтандартныеПодсистемыПереопределяемый.ПолучитьКоличествоВерсийСНеизвлеченнымТекстом(
		КоличествоФайловСНеизвлеченнымТекстом);
	
КонецПроцедуры

&НаКлиенте
Процедура Старт(Команда)
	
	ВключеноИзвлечениеТекста = Истина; 
	
	// здесь ТекущаяДата() не пишется в базу - только на клиенте показывается в информационных целях - поэтому заменять на ТекущаяДатаСеанса не надо
	ПрогнозируемоеВремяНачалаИзвлечения = ТекущаяДата();
	ПодключитьОбработчикОжидания("ИзвлечениеТекстовКлиентОбработчик", ИнтервалВремениВыполнения);
	
#Если НЕ ВебКлиент Тогда
	ИзвлечениеТекстовКлиентОбработчик();
#КонецЕсли
	
	ПодключитьОбработчикОжидания("ОбновлениеОбратногоОтсчета", 1);
	ОбновлениеОбратногоОтсчета();
	
КонецПроцедуры

&НаКлиенте
Процедура Стоп(Команда)
	ВыполнитьСтоп();
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСтоп()
	ОтключитьОбработчикОжидания("ИзвлечениеТекстовКлиентОбработчик");
	ОтключитьОбработчикОжидания("ОбновлениеОбратногоОтсчета");
	Статус = "";
	ВключеноИзвлечениеТекста = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ИзвлечьВсе(Команда)
	
	#Если НЕ ВебКлиент Тогда
		КоличествоФайловСНеизвлеченнымТекстомДоНачалаОперации = КоличествоФайловСНеизвлеченнымТекстом;
		Статус = "";
		РазмерПорции = 0; // извлечь все
		ИзвлечениеТекстовКлиент(РазмерПорции);
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Завершено извлечение текста из всех файлов с неизвлеченным текстом. Обработано файлов: %1.'"),
			КоличествоФайловСНеизвлеченнымТекстомДоНачалаОперации);
		Предупреждение(ТекстСообщения);
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоФайловВПорцииПриИзменении(Элемент)
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("АвтоматическоеИзвлечениеТекстов", "КоличествоФайловВПорции",  КоличествоФайловВПорции);
КонецПроцедуры
