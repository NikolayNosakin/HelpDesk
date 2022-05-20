﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Начальное значение настройки до загрузки данных из настроек.
	ВыбиратьИерархически = Истина;
	
	ЗаполнитьХранимыеПараметры();
	ЗаполнитьПараметрыДинамическихСписков();
	
	Если Параметры.РежимВыбора Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	ОбновитьОтборНедействительныхПользователей(ЭтотОбъект);
	
	// Скрытие пользователей с пустым идентификатором, если значение параметра Истина.
	Если Параметры.ДоступКИнформационнойБазеРазрешен Тогда
		
		Если Параметры.ДоступКИнформационнойБазеРазрешен = Ложь Тогда
			ВидСравненияКД = ВидСравненияКомпоновкиДанных.Равно;
		Иначе
			ВидСравненияКД = ВидСравненияКомпоновкиДанных.НеРавно;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ВнешниеПользователиСписок.Отбор,
			"ИдентификаторПользователяИБ",
			Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"),
			ВидСравненияКД);
		
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Добавление", Метаданные.Справочники.ГруппыВнешнихПользователей) Тогда
		Элементы.СоздатьГруппуВнешнихПользователей.Видимость = Ложь;
	КонецЕсли;
	Если НЕ ПравоДоступа("Добавление", Метаданные.Справочники.ВнешниеПользователи) Тогда
		Элементы.СоздатьВнешнегоПользователя.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		
		Если Элементы.Найти("ПользователиИБ") <> Неопределено Тогда
			Элементы.ПользователиИБ.Видимость = Ложь;
		КонецЕсли;
		
		// Отбор не помеченных на удаление.
		ВнешниеПользователиСписок.Отбор.Элементы[0].Использование = Истина;
		
		Элементы.ВнешниеПользователиСписок.РежимВыбора = Истина;
		Элементы.ГруппыВнешнихПользователей.РежимВыбора =
			ХранимыеПараметры.ВыборГруппВнешнихПользователей;
		
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Элементы.ВнешниеПользователиСписок.МножественныйВыбор = Истина;
			
			Если ХранимыеПараметры.ВыборГруппВнешнихПользователей Тогда
				Элементы.ГруппыВнешнихПользователей.МножественныйВыбор = Истина;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Элементы.ВыбратьВнешнегоПользователя.Видимость       = Ложь;
		Элементы.ВыбратьГруппуВнешнихПользователей.Видимость = Ложь;
	КонецЕсли;
	
	ХранимыеПараметры.Вставить("ТекущаяСтрока", Параметры.ТекущаяСтрока);
	НастроитьФормуПоИспользованиюГруппПользователей();
	ХранимыеПараметры.Удалить("ТекущаяСтрока");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_ГруппыВнешнихПользователей")
	   И Источник = Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока Тогда
		
		Элементы.ГруппыВнешнихПользователей.Обновить();
		Элементы.ВнешниеПользователиСписок.Обновить();
		ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
		
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("Запись_ИспользоватьГруппыПользователей") Тогда
		
		ПодключитьОбработчикОжидания("ПриИзмененииИспользованияГруппПользователей", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если ТипЗнч(Настройки["ВыбиратьИерархически"]) = Тип("Булево") Тогда
		ВыбиратьИерархически = Настройки["ВыбиратьИерархически"];
	КонецЕсли;
	
	Если НЕ ВыбиратьИерархически Тогда
		ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ВыбиратьИерархическиПриИзменении(Элемент)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ГруппыВнешнихПользователей

&НаКлиенте
Процедура ГруппыВнешнихПользователейПриАктивизацииСтроки(Элемент)
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если НЕ Копирование Тогда
		Отказ = Истина;
		ПараметрыФормы = Новый Структура;
		
		Если ЗначениеЗаполнено(Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока) Тогда
			
			ПараметрыФормы.Вставить(
				"ЗначенияЗаполнения",
				Новый Структура("Родитель", Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока));
		КонецЕсли;
		
		ОткрытьФорму(
			"Справочник.ГруппыВнешнихПользователей.ФормаОбъекта",
			ПараметрыФормы,
			Элементы.ГруппыВнешнихПользователей);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ВнешниеПользователи

&НаКлиенте
Процедура ВнешниеПользователиСписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешниеПользователиСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура(
		"ГруппаНовогоВнешнегоПользователя", Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока);
	
	Если ЗначениеЗаполнено(ХранимыеПараметры.ОтборОбъектАвторизации) Тогда
		
		ПараметрыФормы.Вставить(
			"ОбъектАвторизацииНовогоВнешнегоПользователя",
			ХранимыеПараметры.ОтборОбъектАвторизации);
	КонецЕсли;
	
	Если Копирование И Элемент.ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элемент.ТекущаяСтрока);
	КонецЕсли;
	
	ОткрытьФорму(
		"Справочник.ВнешниеПользователи.ФормаОбъекта",
		ПараметрыФормы,
		Элементы.ВнешниеПользователиСписок);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СоздатьГруппуВнешнихПользователей(Команда)
	
	Элементы.ГруппыВнешнихПользователей.ДобавитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительныхПользователей(Команда)
	
	ОбновитьОтборНедействительныхПользователей(ЭтотОбъект, Истина);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьХранимыеПараметры()
	
	ХранимыеПараметры = Новый Структура;
	ХранимыеПараметры.Вставить("ВыборГруппВнешнихПользователей", Параметры.ВыборГруппВнешнихПользователей);
	
	Если Параметры.Отбор.Свойство("ОбъектАвторизации") Тогда
		ХранимыеПараметры.Вставить("ОтборОбъектАвторизации", Параметры.Отбор.ОбъектАвторизации);
	Иначе
		ХранимыеПараметры.Вставить("ОтборОбъектАвторизации", Неопределено);
	КонецЕсли;
	
	// Подготовка представлений типов объектов авторизации.
	ХранимыеПараметры.Вставить("ПредставлениеТиповОбъектовАвторизации", Новый СписокЗначений);
	ТипыОбъектовАвторизации = Метаданные.Справочники.ВнешниеПользователи.Реквизиты.ОбъектАвторизации.Тип.Типы();
	
	Для каждого ТекущийТипОбъектовАвторизации Из ТипыОбъектовАвторизации Цикл
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТекущийТипОбъектовАвторизации);
		ОписаниеТипа = Новый ОписаниеТипов(МассивТипов);
		
		ХранимыеПараметры.ПредставлениеТиповОбъектовАвторизации.Добавить(
			ОписаниеТипа.ПривестиЗначение(Неопределено),
			Метаданные.НайтиПоТипу(ТекущийТипОбъектовАвторизации).Синоним);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыДинамическихСписков()
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(
		ВнешниеПользователиСписок,
		"ПустойУникальныйИдентификатор",
		Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
	ТипОбъектовАвторизации = Неопределено;
	Параметры.Свойство("ТипОбъектовАвторизации", ТипОбъектовАвторизации);
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(
		ГруппыВнешнихПользователей,
		"ЛюбойТипОбъектовАвторизации",
		ТипОбъектовАвторизации = Неопределено);
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(
		ГруппыВнешнихПользователей,
		"ТипОбъектовАвторизации",
		ТипЗнч(ТипОбъектовАвторизации));
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(
		ВнешниеПользователиСписок,
		"ЛюбойТипОбъектовАвторизации",
		ТипОбъектовАвторизации = Неопределено);
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(
		ВнешниеПользователиСписок,
		"ТипОбъектовАвторизации",
		ТипЗнч(ТипОбъектовАвторизации));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьОтборНедействительныхПользователей(Форма, ИзменитьОтбор = Ложь)
	
	Элементы = Форма.Элементы;
	
	Если ИзменитьОтбор Тогда
		
		Элементы.ПоказыватьНедействительныхПользователей.Пометка =
			НЕ Элементы.ПоказыватьНедействительныхПользователей.Пометка;
		
	ИначеЕсли Форма.Параметры.Отбор.Свойство("Недействителен") Тогда
		
		Элементы.ПоказыватьНедействительныхПользователей.Пометка =
			Форма.Параметры.Отбор.Недействителен;
		
	КонецЕсли;
	
	Если Элементы.ПоказыватьНедействительныхПользователей.Пометка Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Форма.ВнешниеПользователиСписок.Отбор, "Недействителен", Ложь, , , Ложь);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Форма.ВнешниеПользователиСписок.Отбор, "Недействителен", Ложь, , , Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииИспользованияГруппПользователей()
	
	НастроитьФормуПоИспользованиюГруппПользователей();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоИспользованиюГруппПользователей()
	
	ХранимыеПараметры.Вставить(
		"ИспользоватьГруппы", ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей"));
		
	Если ХранимыеПараметры.Свойство("ТекущаяСтрока") Тогда
		
		Если ТипЗнч(Параметры.ТекущаяСтрока) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") Тогда
			
			Если ХранимыеПараметры.ИспользоватьГруппы Тогда
				Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока = ХранимыеПараметры.ТекущаяСтрока;
			Иначе
				Параметры.ТекущаяСтрока = Неопределено;
			КонецЕсли;
		Иначе
			ТекущийЭлемент = Элементы.ВнешниеПользователиСписок;
			
			Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока =
				Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи;
		КонецЕсли;
	Иначе
		Если НЕ ХранимыеПараметры.ИспользоватьГруппы
		   И Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока
		     <> Справочники.ГруппыПользователей.ВсеПользователи Тогда
			
			Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока =
				Справочники.ГруппыПользователей.ВсеПользователи;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ГруппаПоказыватьВнешнихПользователейДочернихГрупп.Видимость =
		ХранимыеПараметры.ИспользоватьГруппы;
	
	Элементы.СоздатьГруппуВнешнихПользователей.Видимость =
		ХранимыеПараметры.ИспользоватьГруппы;
	
	ВыборГруппВнешнихПользователей = ХранимыеПараметры.ВыборГруппВнешнихПользователей
	                               И ХранимыеПараметры.ИспользоватьГруппы
	                               И Параметры.РежимВыбора;
	
	Если Параметры.РежимВыбора Тогда
		
		Элементы.ВыбратьГруппуВнешнихПользователей.Видимость   =    ВыборГруппВнешнихПользователей;
		Элементы.ВыбратьВнешнегоПользователя.КнопкаПоУмолчанию = НЕ ВыборГруппВнешнихПользователей;
		АвтоЗаголовок = Ложь;
		
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			
			Если ВыборГруппВнешнихПользователей Тогда
				
				Заголовок = НСтр("ru = 'Подбор внешних пользователей и групп'");
					
				Элементы.ВыбратьВнешнегоПользователя.Заголовок =
					НСтр("ru = 'Выбрать внешних пользователей'");
				
				Элементы.ВыбратьГруппуВнешнихПользователей.Заголовок =
					НСтр("ru = 'Выбрать группы'");
				
			Иначе
				Заголовок = НСтр("ru = 'Подбор внешних пользователей'");
			КонецЕсли;
		Иначе
			// Режим выбора.
			Если ВыборГруппВнешнихПользователей Тогда
				Заголовок = НСтр("ru = 'Выбор внешнего пользователя или группы'");
				
				Элементы.ВыбратьВнешнегоПользователя.Заголовок =
					НСтр("ru = 'Выбрать внешнего пользователя'");
			Иначе
				Заголовок = НСтр("ru = 'Выбор внешнего пользователя'");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСодержимоеФормыПриИзмененииГруппы(Форма)
	
	Элементы = Форма.Элементы;
	
	Если НЕ Форма.ХранимыеПараметры.ИспользоватьГруппы
	 ИЛИ Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока = ПредопределенноеЗначение(
	         "Справочник.ГруппыВнешнихПользователей.ВсеВнешниеПользователи") Тогда
		
		Форма.ОписаниеОтображаемыхВнешнихПользователей = НСтр("ru = 'Все внешние пользователи'");
		
		Элементы.ГруппаПоказыватьВнешнихПользователейДочернихГрупп.ТекущаяСтраница =
			Элементы.ГруппаНельзяУстановитьСвойство;
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(
			Форма.ВнешниеПользователиСписок, "ВыбиратьИерархически", Истина);
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(
			Форма.ВнешниеПользователиСписок,
			"ГруппаВнешнихПользователей",
			ПредопределенноеЗначение("Справочник.ГруппыВнешнихПользователей.ВсеВнешниеПользователи"));
	Иначе
	#Если Сервер Тогда
		Если ЗначениеЗаполнено(Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока) Тогда
			ТекущиеДанные = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(
				Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока, "ВсеОбъектыАвторизации");
		Иначе
			ТекущиеДанные = Неопределено;
		КонецЕсли;
	#Иначе
		ТекущиеДанные = Элементы.ГруппыВнешнихПользователей.ТекущиеДанные;
	#КонецЕсли
		
		Если ТекущиеДанные <> Неопределено
		   И ТекущиеДанные.ВсеОбъектыАвторизации Тогда
			
			ЭлементПредставленияТипаОбъектаАвторизации =
				Форма.ХранимыеПараметры.ПредставлениеТиповОбъектовАвторизации.НайтиПоЗначению(
					ТекущиеДанные.ТипОбъектовАвторизации);
				
			Форма.ОписаниеОтображаемыхВнешнихПользователей =
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Все %1'"),
					НРег(?(
						ЭлементПредставленияТипаОбъектаАвторизации = Неопределено,
						НСтр("ru = '<Недопустимый тип>'"),
						ЭлементПредставленияТипаОбъектаАвторизации.Представление)) );
			
			Элементы.ГруппаПоказыватьВнешнихПользователейДочернихГрупп.ТекущаяСтраница =
				Элементы.ГруппаНельзяУстановитьСвойство;
			
			ОбновитьЗначениеПараметраКомпоновкиДанных(
				Форма.ВнешниеПользователиСписок, "ВыбиратьИерархически", Истина);
		Иначе
			Элементы.ГруппаПоказыватьВнешнихПользователейДочернихГрупп.ТекущаяСтраница =
				Элементы.ГруппаУстановитьСвойство;
			
			ОбновитьЗначениеПараметраКомпоновкиДанных(
				Форма.ВнешниеПользователиСписок, "ВыбиратьИерархически", Форма.ВыбиратьИерархически);
		КонецЕсли;
		
		ОбновитьЗначениеПараметраКомпоновкиДанных(
			Форма.ВнешниеПользователиСписок,
			"ГруппаВнешнихПользователей",
			Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗначениеПараметраКомпоновкиДанных(Знач ВладелецПараметров,
                                                    Знач ИмяПараметра,
                                                    Знач ЗначениеПараметра)
	
	Для каждого Параметр Из ВладелецПараметров.Параметры.Элементы Цикл
		Если Строка(Параметр.Параметр) = ИмяПараметра Тогда
			
			Если Параметр.Использование
			   И Параметр.Значение = ЗначениеПараметра Тогда
				
				Возврат;
			КонецЕсли;
			Прервать;
			
		КонецЕсли;
	КонецЦикла;
	
	ВладелецПараметров.Параметры.УстановитьЗначениеПараметра(ИмяПараметра, ЗначениеПараметра);
	
КонецПроцедуры
