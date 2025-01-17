﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Выбранные",                 Параметры.Выбранные);
	Запрос.УстановитьПараметр("ПользовательГрупп",         Параметры.ПользовательГрупп);
	Запрос.УстановитьПараметр("Администратор",             Пользователи.АвторизованныйПользователь());
	Запрос.УстановитьПараметр("ПолноправныйОтветственный", Пользователи.ЭтоПолноправныйПользователь());
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДоступа.Ссылка,
	|	ГруппыДоступа.Наименование,
	|	ГруппыДоступа.ЭтоГруппа,
	|	ВЫБОР
	|		КОГДА ГруппыДоступа.ЭтоГруппа
	|				И НЕ ГруппыДоступа.ПометкаУдаления
	|			ТОГДА 0
	|		КОГДА ГруппыДоступа.ЭтоГруппа
	|				И ГруппыДоступа.ПометкаУдаления
	|			ТОГДА 1
	|		КОГДА НЕ ГруппыДоступа.ЭтоГруппа
	|				И НЕ ГруппыДоступа.ПометкаУдаления
	|			ТОГДА 2
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК НомерКартинки,
	|	ЛОЖЬ КАК Пометка
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|ГДЕ
	|	НЕ ГруппыДоступа.Ссылка В (ЗНАЧЕНИЕ(Справочник.ГруппыДоступа.Администраторы))
	|	И НЕ ГруппыДоступа.Ссылка В (&Выбранные)
	|	И ВЫБОР
	|			КОГДА &ПолноправныйОтветственный
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ГруппыДоступа.Администратор = &Администратор
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА ГруппыДоступа.ЭтоГруппа
	|				ТОГДА ИСТИНА
	|			КОГДА ГруппыДоступа.Пользователь = НЕОПРЕДЕЛЕНО
	|				ТОГДА ИСТИНА
	|			КОГДА ГруппыДоступа.Пользователь = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			КОГДА ГруппыДоступа.Пользователь = ЗНАЧЕНИЕ(Справочник.ВнешниеПользователи.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ГруппыДоступа.Пользователь = &ПользовательГрупп
	|		КОНЕЦ
	|	И НЕ ГруппыДоступа.ПометкаУдаления
	|	И НЕ ГруппыДоступа.Профиль.ПометкаУдаления
	|	И ВЫБОР
	|			КОГДА ГруппыДоступа.ТипПользователей = НЕОПРЕДЕЛЕНО
	|				ТОГДА ИСТИНА
	|			КОГДА ТИПЗНАЧЕНИЯ(ГруппыДоступа.ТипПользователей) = ТИП(Справочник.Пользователи)
	|				ТОГДА ВЫБОР
	|						КОГДА ТИПЗНАЧЕНИЯ(&ПользовательГрупп) = ТИП(Справочник.Пользователи)
	|								ИЛИ ТИПЗНАЧЕНИЯ(&ПользовательГрупп) = ТИП(Справочник.ГруппыПользователей)
	|							ТОГДА ИСТИНА
	|						ИНАЧЕ ЛОЖЬ
	|					КОНЕЦ
	|			КОГДА ТИПЗНАЧЕНИЯ(&ПользовательГрупп) = ТИП(Справочник.ВнешниеПользователи)
	|				ТОГДА ИСТИНА В
	|						(ВЫБРАТЬ ПЕРВЫЕ 1
	|							ИСТИНА
	|						ИЗ
	|							Справочник.ВнешниеПользователи КАК ВнешниеПользователи
	|						ГДЕ
	|							ВнешниеПользователи.Ссылка = &ПользовательГрупп
	|							И ТИПЗНАЧЕНИЯ(ВнешниеПользователи.ОбъектАвторизации) = ТИПЗНАЧЕНИЯ(ГруппыДоступа.ТипПользователей))
	|			КОГДА ТИПЗНАЧЕНИЯ(&ПользовательГрупп) = ТИП(Справочник.ГруппыВнешнихПользователей)
	|				ТОГДА ИСТИНА В
	|						(ВЫБРАТЬ ПЕРВЫЕ 1
	|							ИСТИНА
	|						ИЗ
	|							Справочник.ГруппыВнешнихПользователей КАК ГруппыВнешнихПользователей
	|						ГДЕ
	|							ГруппыВнешнихПользователей.Ссылка = &ПользовательГрупп
	|							И ТИПЗНАЧЕНИЯ(ГруппыВнешнихПользователей.ТипОбъектовАвторизации) = ТИПЗНАЧЕНИЯ(ГруппыДоступа.ТипПользователей))
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГруппыДоступа.Ссылка ИЕРАРХИЯ";
	
	НовоеДерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	Папки = НовоеДерево.Строки.НайтиСтроки(Новый Структура("ЭтоГруппа", Истина), Истина);
	
	УдалитьПапки = Новый Соответствие;
	НетПапок = Истина;
	
	Для каждого Папка Из Папки Цикл
		Если Папка.Родитель = Неопределено
		   И Папка.Строки.Количество() = 0
		 ИЛИ Папка.Строки.НайтиСтроки(Новый Структура("ЭтоГруппа", Ложь), Истина).Количество() = 0 Тогда
			
			УдалитьПапки.Вставить(
				?(Папка.Родитель = Неопределено, НовоеДерево.Строки, Папка.Родитель.Строки),
				Папка);
		Иначе
			НетПапок = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого УдалитьПапку Из УдалитьПапки Цикл
		Если УдалитьПапку.Ключ.Индекс(УдалитьПапку.Значение) > -1 Тогда
			УдалитьПапку.Ключ.Удалить(УдалитьПапку.Значение);
		КонецЕсли;
	КонецЦикла;
	
	НовоеДерево.Строки.Сортировать("ЭтоГруппа Убыв, Наименование Возр", Истина);
	ЗначениеВРеквизитФормы(НовоеДерево, "ГруппыДоступа");
	
	Если НетПапок Тогда
		Элементы.ГруппыДоступа.Отображение = ОтображениеТаблицы.Список;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ГруппыДоступа

&НаКлиенте
Процедура ГруппыДоступаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПриВыборе();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	
	ПриВыборе();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПриВыборе()
	
	ТекущиеДанные = Элементы.ГруппыДоступа.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		Если ТекущиеДанные.ЭтоГруппа Тогда
			
			Если Элементы.ГруппыДоступа.Развернут(Элементы.ГруппыДоступа.ТекущаяСтрока) Тогда
				Элементы.ГруппыДоступа.Свернуть(Элементы.ГруппыДоступа.ТекущаяСтрока);
			Иначе
				Элементы.ГруппыДоступа.Развернуть(Элементы.ГруппыДоступа.ТекущаяСтрока);
			КонецЕсли;
		Иначе
			Закрыть(ТекущиеДанные.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
