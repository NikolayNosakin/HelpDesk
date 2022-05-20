﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Функция читает данные календарного графика за указанный год
//
&НаСервереБезКонтекста
Функция ПрочитатьКалендарныйГрафик(Календарь, НомерГода)
	
	Возврат Справочники.Календари.ПрочитатьДанныеГрафикаИзРегистра(Календарь, НомерГода);
	
КонецФункции

// Процедура записывает данные календарного графика за указанный год
//
&НаСервере
Процедура ЗаписатьКалендарныйГрафик(Знач НомерГода, Знач ТекущийОбъект = Неопределено)
	
	Если ТекущийОбъект = Неопределено Тогда
		ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	
	Справочники.Календари.ЗаписатьДанныеГрафикаВРегистр(ТекущийОбъект.Ссылка, НомерГода, ТаблицаРегистра);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПриСозданииНаСервере" формы
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НомерТекущегоГода		= Год(ТекущаяДата());
	НомерПредыдущегоГода	= НомерТекущегоГода;
	
	Элементы.Календарь.НачалоПериодаОтображения	= Дата(НомерТекущегоГода, 1, 1);
	Элементы.Календарь.КонецПериодаОтображения	= Дата(НомерТекущегоГода, 12, 31);
	
	Если Не ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		СсылкаНаКалендарь = Объект.Ссылка;
	Иначе
		СсылкаНаКалендарь = Параметры.ЗначениеКопирования;
	КонецЕсли;
	
	ТаблицаРегистра.ЗагрузитьЗначения(Справочники.Календари.ПрочитатьДанныеГрафикаИзРегистра(СсылкаНаКалендарь, НомерТекущегоГода));
	
КонецПроцедуры

// Процедура - обработчик события "ПриЗаписиНаСервере" формы
//
&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Перем НомерГода;
	
	Если Не ПараметрыЗаписи.Свойство("НомерГода", НомерГода) Тогда
		НомерГода = НомерТекущегоГода;
	КонецЕсли;
	
	ЗаписатьКалендарныйГрафик(НомерГода, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	Если ТипЗнч(РезультатВыбора) = Тип("СправочникСсылка.Календари") Тогда
		ТаблицаРегистра.ЗагрузитьЗначения(ПрочитатьКалендарныйГрафик(РезультатВыбора, НомерТекущегоГода));
		
		Элементы.Календарь.Обновить();
	КонецЕсли;
	
	Возврат;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура - обработчик действия команды "ЗаполнитьКалендарь"
//
&НаКлиенте
Процедура ЗаполнитьКалендарь()
	
	ТаблицаРегистра.Очистить();
	
	Для Месяц = 1 По 12 Цикл
		Для НомерДня = 1 По День(КонецМесяца(Дата(НомерТекущегоГода, Месяц, 1))) Цикл
			ДатаКалендаря = Дата(НомерТекущегоГода, Месяц, НомерДня);
			
			Если ДеньНедели(ДатаКалендаря) = 6 Или ДеньНедели(ДатаКалендаря) = 7 Тогда
				Продолжить;
			КонецЕсли;
			
			ТаблицаРегистра.Добавить(ДатаКалендаря);
		КонецЦикла;
	КонецЦикла;
	
	Элементы.Календарь.Обновить();
	
КонецПроцедуры

// Процедура - обработчик действия команды "ЗаполнитьПоКалендарю"
//
&НаКлиенте
Процедура ЗаполнитьПоКалендарю(Команда)
	
	ОткрытьФорму("Справочник.Календари.ФормаВыбора", , ЭтотОбъект, КлючУникальности);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура - обработчик события "ПриИзменении" элемента формы "НомерТекущегоГода"
//
&НаКлиенте
Процедура НомерТекущегоГодаПриИзменении(Элемент)
	
	Если НомерТекущегоГода < 1900 Тогда
		НомерТекущегоГода = НомерПредыдущегоГода;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Записать измененные данные за %1 год?'"), Формат(НомерПредыдущегоГода, "ЧГ=0"));
		
		ПоказатьВопрос(Новый ОписаниеОповещения("НомерТекущегоГодаПриИзмененииЗавершение", ЭтотОбъект), ТекстСообщения, РежимДиалогаВопрос.ДаНет);
        Возврат;
	КонецЕсли;
	
	НомерТекущегоГодаПриИзмененииФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура НомерТекущегоГодаПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Если Объект.Ссылка.Пустая() Тогда
			Записать(Новый Структура("НомерГода", НомерПредыдущегоГода));
		Иначе
			ЗаписатьКалендарныйГрафик(НомерПредыдущегоГода);
		КонецЕсли;
	КонецЕсли;
	
	НомерТекущегоГодаПриИзмененииФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура НомерТекущегоГодаПриИзмененииФрагмент()
	
	НомерПредыдущегоГода = НомерТекущегоГода;
	
	Элементы.Календарь.НачалоПериодаОтображения	= Дата(НомерТекущегоГода, 1, 1);
	Элементы.Календарь.КонецПериодаОтображения	= Дата(НомерТекущегоГода, 12, 31);
	
	ТаблицаРегистра.ЗагрузитьЗначения(ПрочитатьКалендарныйГрафик(Объект.Ссылка, НомерТекущегоГода));
	
	Модифицированность = Ложь;
	
	Элементы.Календарь.Обновить();

КонецПроцедуры

// Процедура - обработчик события "ПриВыводеПериода" элемента формы "Календарь"
//
&НаКлиенте
Процедура КалендарьПриВыводеПериода(Элемент, ОформлениеПериода)
	
	Для Каждого СтрокаОформленияПериода Из ОформлениеПериода.Даты Цикл
		СтрокаТаблицыРегистра = ТаблицаРегистра.НайтиПоЗначению(СтрокаОформленияПериода.Дата);
		
		Если СтрокаТаблицыРегистра = Неопределено Тогда
			СтрокаОформленияПериода.ЦветТекста = WebЦвета.Красный;
		Иначе
			СтрокаОформленияПериода.ЦветТекста = WebЦвета.Черный;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Процедура - обработчик события "Выбор" элемента формы "Календарь"
//
&НаКлиенте
Процедура КалендарьВыбор(Элемент, ВыбраннаяДата)
	
	СтрокаТаблицыРегистра = ТаблицаРегистра.НайтиПоЗначению(ВыбраннаяДата);
	
	Если СтрокаТаблицыРегистра = Неопределено Тогда
		ТаблицаРегистра.Добавить(ВыбраннаяДата);
	Иначе
		ТаблицаРегистра.Удалить(СтрокаТаблицыРегистра);
	КонецЕсли;
	
	Если Не Модифицированность Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
	Элемент.Обновить();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
