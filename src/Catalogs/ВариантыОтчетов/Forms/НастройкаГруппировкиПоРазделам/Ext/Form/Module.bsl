﻿
&НаКлиенте
Процедура ПрименитьКомандыйИнтерфейс(Команда)
	
	ПрименитьНастройки();
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ПрименитьНастройки()
	
	//список вариантов
	СписокВариантов = Новый ТаблицаЗначений;
	
	СписокВариантов.Колонки.Добавить("Вариант");
	СписокВариантов.Колонки.Добавить("Путь");
	СписокВариантов.Колонки.Добавить("ПутьПредставление");
	
	
	Для каждого СтрокаВарианта из ДеревоПодсистем.ПолучитьЭлементы() Цикл
		Если НЕ СтрокаВарианта.Вариант.Пустая() и НЕ СтрокаВарианта.Предопредленная тогда
			СтркаВарианта                   = СписокВариантов.Добавить();
			СтркаВарианта.Вариант           = СтрокаВарианта.Вариант;
			СтркаВарианта.Путь              = СтрокаВарианта.Путь;
			СтркаВарианта.ПутьПредставление = СтрокаВарианта.ПолучитьРодителя().Представление;
		Иначе
			СкопироватьПодчиенныеВарианты(СтрокаВарианта, СписокВариантов);
		КонецЕсли;
		
	КонецЦикла;
	
	СписокВариантовБезПодсистем = СписокВариантов.Скопировать();
	СписокВариантовБезПодсистем.Свернуть("Вариант");
	
	НачатьТранзакцию();
	Попытка
		Для каждого СтрокаВарианта из СписокВариантовБезПодсистем Цикл
			
			ОбъектВарианта = СтрокаВарианта.Вариант.ПолучитьОбъект();
			
			МассивСтрокДляУдаления = Новый Массив;
			
			// удалим подсистемы
			Для каждого СтрокаПодсиситемы из ОбъектВарианта.Подсистемы Цикл
				Если НЕ СтрокаПодсиситемы.Предопределенная тогда
					МассивСтрокДляУдаления.Добавить(СтрокаПодсиситемы);
				КонецЕсли;
			КонецЦикла;
			
			Для каждого СтрокаПодсиситемы из МассивСтрокДляУдаления Цикл
				ОбъектВарианта.Подсистемы.Удалить(СтрокаПодсиситемы)
			КонецЦикла;
			
			// формирование строк подсистемы
			МассивСтрокДляДобавления = СписокВариантов.НайтиСтроки(Новый Структура("Вариант", СтрокаВарианта.Вариант));
			
			Для каждого СтрокаПодсистемы из МассивСтрокДляДобавления Цикл
				НоваяСтрокаПодсистемы            = ОбъектВарианта.Подсистемы.Добавить();
				НоваяСтрокаПодсистемы.Подсистема = СтрокаПодсистемы.Путь;
				НоваяСтрокаПодсистемы.Название   = СтрокаПодсистемы.ПутьПредставление
			КонецЦикла;
			ОбъектВарианта.ЗАписать();
		КонецЦикла;
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Варианты отчетов. Настройка группировки по разделам'"), 
			УровеньЖурналаРегистрации.Ошибка,
			,
			, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
		);
	КонецПопытки;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

&НаСервере
Процедура СкопироватьПодчиенныеВарианты(СтрокаВарианта, СписокВариантов)
	
	Для каждого СтрокаВариантаПодчиненная из СтрокаВарианта.ПолучитьЭлементы() Цикл
		Если НЕ СтрокаВариантаПодчиненная.Вариант.Пустая() И НЕ СтрокаВариантаПодчиненная.Предопредленная тогда
			СтркаВарианта                   = СписокВариантов.Добавить();
			СтркаВарианта.Вариант           = СтрокаВариантаПодчиненная.Вариант;
			СтркаВарианта.Путь              = СтрокаВариантаПодчиненная.Путь;
			СтркаВарианта.ПутьПредставление = СтрокаВариантаПодчиненная.ПолучитьРодителя().Представление;		
		Иначе
			СкопироватьПодчиенныеВарианты(СтрокаВариантаПодчиненная, СписокВариантов);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗагузитьСтруктураПодсистем();
	
	// заполним вариантами группировки
	
	ТЗ = "ВЫБРАТЬ
	     |	ВариантыОтчетовПодсистемы.Подсистема,
	     |	ВариантыОтчетовПодсистемы.Ссылка,
	     |	ВариантыОтчетовПодсистемы.Ссылка.Наименование КАК Представление,
	     |	ВариантыОтчетовПодсистемы.Ссылка.КлючВарианта,
	     |	ВариантыОтчетовПодсистемы.Ссылка.КлючОбъекта КАК Отчет,
	     |	ВариантыОтчетовПодсистемы.Предопределенная
	     |ИЗ
	     |	Справочник.ВариантыОтчетов.Подсистемы КАК ВариантыОтчетовПодсистемы
	     |ГДЕ
	     |	(НЕ ВариантыОтчетовПодсистемы.Ссылка.ПометкаУдаления)";
		 
	Запрос = Новый Запрос(ТЗ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		МассивСтрок = СоответсвиеПодсистемИСтрок.НайтиСтроки(Новый Структура("Путь", Выборка.Подсистема));
		Если МассивСтрок.Количество() > 0 тогда
			СтрокаПодсистемы = ДеревоПодсистем.НайтиПоИдентификатору(МассивСтрок[0].ИдентификаторСтроки);
		Иначе
			Продолжить;;
		КонецЕсли;

		Если СтрокаПодсистемы = Неопределено тогда
			Продолжить;
		КонецЕсли;
		СтрокаВарианта   = СтрокаПодсистемы.ПолучитьЭлементы().Добавить();
		
		СтрокаВарианта.Путь            = СтрокаПодсистемы.Путь;
		СтрокаВарианта.Представление   = Выборка.Представление;
		СтрокаВарианта.Вариант         = Выборка.Ссылка;
		СтрокаВарианта.Ключ            = Выборка.КлючВарианта;
		СтрокаВарианта.Отчет           = Выборка.Отчет;
		СтрокаВарианта.Предопредленная = Выборка.Предопределенная;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗагузитьСтруктураПодсистем()
	
	ДеревоПодсистемДляКопирования = Новый ДеревоЗначений;
	ДеревоПодсистемДляКопирования.Колонки.Добавить("Подсистема");
	ДеревоПодсистемДляКопирования.Колонки.Добавить("Название");
	
	СписокПодсистем = Новый СписокЗначений;
	СписокПодсистем.Добавить("");
	
	// Сделаем список отчетов
	СписокПодсистем = ВариантыОтчетов.ПолучитьСписокПодсистем(СписокПодсистем, ДеревоПодсистемДляКопирования);

	СтрокаКонфигурации = ДеревоПодсистем.ПолучитьЭлементы().Добавить();
	СтрокаКонфигурации.Путь = "";
	СтрокаКонфигурации.Представление = "Конфигурация";
	СтрокаКонфигурации.Предопредленная = истина;
	
	СкопироватьДеревоЗначений(СтрокаКонфигурации.ПолучитьЭлементы(), ДеревоПодсистемДляКопирования.Строки, СоответсвиеПодсистемИСтрок);

КонецПроцедуры

&НаСервере
Процедура СкопироватьДеревоЗначений(КолекцияПриемник, КолекцияИсточник, СоответсвиеПодсистемИСтрок)
	
	Для каждого Элемент из КолекцияИсточник Цикл
		СтрокаЗначение                 = КолекцияПриемник.Добавить();
		СтрокаЗначение.Путь            = Элемент.Подсистема;
		СтрокаЗначение.Представление   = Элемент.Название;
		СтрокаЗначение.Предопредленная = Метаданные.НайтиПоПолномуИмени("Подсистема." + СтрЗаменить(Элемент.Подсистема, "\", ".Подсистема.")) <> Неопределено;
		СтрокаВарианта = СоответсвиеПодсистемИСтрок.Добавить();
		СтрокаВарианта.Путь                = СтрокаЗначение.Путь;
		СтрокаВарианта.ИдентификаторСтроки = СтрокаЗначение.ПолучитьИдентификатор();
		СкопироватьДеревоЗначений(СтрокаЗначение.ПолучитьЭлементы(), Элемент.Строки, СоответсвиеПодсистемИСтрок);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКомандныйИнтерфейсПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) <> Тип("Массив") тогда
	   ПараметрыПеретаскивания.Действие  = ДействиеПеретаскивания.Отмена;
	   Возврат;
	КонецЕсли;
	
	СтрокаВставки = ДеревоПодсистем.НайтиПоИдентификатору(Строка);
	ПеретаскиваемыеДанные = Неопределено;
	Если ПараметрыПеретаскивания.Значение.Количество() > 0 тогда
		ИндексСтроки = ПараметрыПеретаскивания.Значение[0];
		ПеретаскиваемыеДанные = ДеревоПодсистем.НайтиПоИдентификатору(ИндексСтроки);
	КонецЕсли;
	
	
	Если НЕ ((СтрокаВставки <> Неопределено и СтрокаВставки.Отчет = "") 
	 	  и (ПеретаскиваемыеДанные <> Неопределено и ПеретаскиваемыеДанные.Отчет <> "")) тогда
		ПараметрыПеретаскивания.Действие  = ДействиеПеретаскивания.Отмена;
	КонецЕсли;
	
	Если ПеретаскиваемыеДанные <> Неопределено и ПеретаскиваемыеДанные.Предопредленная 
	   и ПараметрыПеретаскивания.Действие <> ДействиеПеретаскивания.Копирование тогда
	   ПараметрыПеретаскивания.Действие  = ДействиеПеретаскивания.Отмена;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКомандныйИнтерфейсПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) <> Тип("Массив") тогда
		СтандартнаяОбработка = ложь;
		Возврат;
	КонецЕсли;
	
	ПеретаскиваемыеДанные = Неопределено;
	Если ПараметрыПеретаскивания.Значение.Количество() > 0 тогда
		ИндексСтроки = ПараметрыПеретаскивания.Значение[0];
		ПеретаскиваемыеДанные = ДеревоПодсистем.НайтиПоИдентификатору(ИндексСтроки);
	КонецЕсли;
	СтандартнаяОбработка = ложь;
	СтрокаВставки = ДеревоПодсистем.НайтиПоИдентификатору(Строка);
	ПутьПодсистемы = СтрокаВставки.Путь;
	
	// опредлим формирование отчетности
	СтрокаВарианта = Неопределено;
	Для каждого СтркаВарианта из СтрокаВставки.ПолучитьЭлементы() Цикл
		Если СтркаВарианта.Ключ = ПеретаскиваемыеДанные.Ключ 
			И СтркаВарианта.Отчет = ПеретаскиваемыеДанные.Отчет 
			И ПутьПодсистемы = ПеретаскиваемыеДанные.ПолучитьРодителя().Путь тогда
			СтрокаВарианта = СтркаВарианта;
			Прервать;   
		КонецЕсли;
	КонецЦикла;
	
	Если СтрокаВарианта <> Неопределено тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование тогда
		НоваяСтрока    = СтрокаВставки.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ПеретаскиваемыеДанные);
		НоваяСтрока.Путь = ПутьПодсистемы;
		НоваяСтрока.Предопредленная = ложь;
	ИначеЕсли ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение тогда
		
		НоваяСтрока    = СтрокаВставки.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ПеретаскиваемыеДанные);
		НоваяСтрока.Путь = ПутьПодсистемы;
		НоваяСтрока.Предопредленная = ложь;
		РодительСтроки = ПеретаскиваемыеДанные.ПолучитьРодителя();
		РодительСтроки.ПолучитьЭлементы().Удалить(ПеретаскиваемыеДанные);
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПреместитьВариант(Команда)
	
	Результат = Неопределено;

	
	ОткрытьФорму("Справочник.ВариантыОтчетов.Форма.ПереместитьВариантВРаздел", , ЭтотОбъект,,,, Новый ОписаниеОповещения("ПреместитьВариантЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ПреместитьВариантЗавершение(Результат1, ДополнительныеПараметры) Экспорт
	
	Результат = Результат1;
	Если Результат <> Неопределено тогда
		МассивСтрок = СоответсвиеПодсистемИСтрок.НайтиСтроки(Новый Структура("Путь", Результат));
		Если МассивСтрок.Количество() > 0 тогда
			СтрокаПодсистемы = ДеревоПодсистем.НайтиПоИдентификатору(МассивСтрок[0].ИдентификаторСтроки);
		Иначе
			Возврат;
		КонецЕсли;
		ПеретаскиваемыеДанные = Элементы.ДеревоПодсистем.ТекущиеДанные;
		Если ПеретаскиваемыеДанные.Предопредленная тогда 
			Возврат;
		КонецЕсли;
		НоваяСтрока = СтрокаПодсистемы.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ПеретаскиваемыеДанные);
		НоваяСтрока.Путь = Результат;
		
		РодительСтроки = ПеретаскиваемыеДанные.ПолучитьРодителя();
		РодительСтроки.ПолучитьЭлементы().Удалить(ПеретаскиваемыеДанные);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьВариант(Команда)
	
	Результат = Неопределено;

	
	ОткрытьФорму("Справочник.ВариантыОтчетов.Форма.СкопироватьВариантВРаздел", , ЭтотОбъект,,,, Новый ОписаниеОповещения("СкопироватьВариантЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьВариантЗавершение(Результат1, ДополнительныеПараметры) Экспорт
	
	Результат = Результат1;
	Если Результат <> Неопределено  тогда
		МассивСтрок = СоответсвиеПодсистемИСтрок.НайтиСтроки(Новый Структура("Путь", Результат.Путь));
		Если МассивСтрок.Количество() > 0 тогда
			СтрокаПодсистемы = ДеревоПодсистем.НайтиПоИдентификатору(МассивСтрок[0].ИдентификаторСтроки);
		Иначе
			Возврат;
		КонецЕсли;
		НоваяСтрока = СтрокаПодсистемы.ПолучитьЭлементы().Добавить();
		НоваяСтрока.Путь    = Результат.Путь;
		НоваяСтрока.Отчет   = Результат.Отчет;
		НоваяСтрока.Ключ    = Результат.Вариант;
		НоваяСтрока.Вариант = Результат.Ссылка;
		НоваяСтрока.Представление = Результат.ПредставлениеВарианта;
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ДеревоПодсистемПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено тогда
		Если Элемент.ТекущиеДанные.Предопредленная или Элемент.ТекущиеДанные.Отчет = "" тогда
			Элементы.ДеревоПодсистемПереместитьВариант.Доступность = Ложь;
			Элементы.Удалить.Доступность = Ложь;
		Иначе
			Элементы.ДеревоПодсистемПереместитьВариант.Доступность = истина;
			Элементы.Удалить.Доступность = истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

