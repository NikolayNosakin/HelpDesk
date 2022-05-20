﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	УчетнаяЗапись = ПараметрКоманды;
	
	ОчиститьСообщения();
	
	Состояние(
		НСтр("ru = 'Проверка учетной записи'"),,
		НСтр("ru = 'Выполняется проверка учетной записи. Подождите...'"));
	
	ДанныеУчетнойЗаписи = Почта.ПолучитьДанныеУчетнойЗаписи(УчетнаяЗапись);
	Если Не ДанныеУчетнойЗаписи.ИспользоватьДляОтправки И Не ДанныеУчетнойЗаписи.ИспользоватьДляПолучения Тогда
		ПоказатьПредупреждение(Неопределено, 
			НСтр("ru = 'Для проверки учетной записи необходимо установить хотя бы один из флагов
				|ИспользоватьДляОтправки или ИспользоватьДляПолучения'"));
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеУчетнойЗаписи.Пароль) Тогда
		ПарольПараметр = Неопределено;
	Иначе
		ПараметрУчетнаяЗапись = Новый Структура("УчетнаяЗапись", УчетнаяЗапись);
		ОткрытьФорму("ОбщаяФорма.ПодтверждениеПароляУчетнойЗаписи", ПараметрУчетнаяЗапись,,,,, Новый ОписаниеОповещения("ОбработкаКомандыЗавершение", ЭтотОбъект, Новый Структура("ДанныеУчетнойЗаписи, УчетнаяЗапись", ДанныеУчетнойЗаписи, УчетнаяЗапись)), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
        Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуКоманды(ДанныеУчетнойЗаписи, ПарольПараметр, УчетнаяЗапись);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКомандыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ДанныеУчетнойЗаписи = ДополнительныеПараметры.ДанныеУчетнойЗаписи;
	УчетнаяЗапись = ДополнительныеПараметры.УчетнаяЗапись;
	
	
	ПарольПараметр = Результат;
	Если ТипЗнч(ПарольПараметр) <> Тип("Строка") Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуКоманды(ДанныеУчетнойЗаписи, ПарольПараметр, УчетнаяЗапись);

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработкуКоманды(Знач ДанныеУчетнойЗаписи, Знач ПарольПараметр, Знач УчетнаяЗапись)
	
	Перем РезультатПроверки, Сообщение;
	
	Сообщение = "";
	РезультатПроверки = ПроверитьУчетнуюЗапись(
	УчетнаяЗапись,
	ПарольПараметр);
	
	Если Не РезультатПроверки.Соединение Тогда
		
		ДобавитьЗначениеКСтрокеЧерезРазделитель(
		Сообщение,
		Символы.ПС,
		НСтр("ru = 'При соединении произошла ошибка:'"));
		ДобавитьЗначениеКСтрокеЧерезРазделитель(
		Сообщение,
		Символы.ПС,
		РезультатПроверки.ОшибкаПриСоединении);
		
	Иначе
		
		ДобавитьЗначениеКСтрокеЧерезРазделитель(
		Сообщение,
		Символы.ПС,
		НСтр("ru = 'Соединение успешно установлено'"));
		
		Если ДанныеУчетнойЗаписи.ИспользоватьДляОтправки Тогда
			Если РезультатПроверки.Отправка Тогда
				ДобавитьЗначениеКСтрокеЧерезРазделитель(
				Сообщение,
				Символы.ПС,
				НСтр("ru = 'Проверка отправки успешно завершена'"));
			Иначе
				ДобавитьЗначениеКСтрокеЧерезРазделитель(
				Сообщение,
				Символы.ПС,
				НСтр("ru = 'Проверка отправки завершилась с ошибкой:'"));
				ДобавитьЗначениеКСтрокеЧерезРазделитель(
				Сообщение,
				Символы.ПС,
				РезультатПроверки.ОшибкаПриОтправке);
			КонецЕсли;
		КонецЕсли;
		
		Если ДанныеУчетнойЗаписи.ИспользоватьДляПолучения Тогда
			Если РезультатПроверки.Получение Тогда
				ДобавитьЗначениеКСтрокеЧерезРазделитель(
				Сообщение,
				Символы.ПС,
				НСтр("ru = 'Проверка получения успешно завершена'"));
			Иначе
				ДобавитьЗначениеКСтрокеЧерезРазделитель(
				Сообщение,
				Символы.ПС,
				НСтр("ru = 'Проверка получения завершилась с ошибкой:'"));
				ДобавитьЗначениеКСтрокеЧерезРазделитель(
				Сообщение,
				Символы.ПС,
				РезультатПроверки.ОшибкаПриПолучении);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ПоказатьПредупреждение(Неопределено, Сообщение);

КонецПроцедуры

// Служебная функция используется для проверки учетной записи электронной почты.
//
&НаСервере
Функция ПроверитьУчетнуюЗапись(УчетнаяЗапись, Пароль) Экспорт
	
	Результат = Новый Структура("Соединение, ОшибкаПриСоединении, Отправка, ОшибкаПриОтправке, Получение, ОшибкаПриПолучении");
	
	ДанныеУчетнойЗаписи = Почта.ПолучитьДанныеУчетнойЗаписи(УчетнаяЗапись);
	
	// Установка соединения
	СообщениеОбОшибке = "";
	Соединение = Почта.ИнтернетПочтаУстановитьСоединение(УчетнаяЗапись, Пароль, СообщениеОбОшибке);
	Если Соединение = Неопределено Тогда
		Результат.Соединение = Ложь;
		Результат.ОшибкаПриСоединении = СообщениеОбОшибке;
		Возврат Результат;
	КонецЕсли;
	
	Результат.Соединение = Истина;
	
	Если ДанныеУчетнойЗаписи.ИспользоватьДляОтправки Тогда
		
		Попытка
			
			ОтправитьТестовоеСообщение(Соединение, ДанныеУчетнойЗаписи.АдресЭлектроннойПочты, ДанныеУчетнойЗаписи.Наименование);
			Результат.Отправка = Истина;
			
		Исключение
			
			Результат.Отправка = Ложь;
			Результат.ОшибкаПриОтправке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			
		КонецПопытки;
		
	КонецЕсли;
	
	Если ДанныеУчетнойЗаписи.ИспользоватьДляПолучения Тогда
		
		Попытка
			
			// Получение идентификаторов всех сообщений в почтовом ящике
			СообщениеОбОшибке = "";
			Идентификаторы = Почта.ПолучитьИдентификаторыВходящихСообщений(Соединение,,, СообщениеОбОшибке);
			Если Идентификаторы = Неопределено Тогда
				ВызватьИсключение СообщениеОбОшибке;
			КонецЕсли;
			
			Результат.Получение = Истина;
			
		Исключение
			
			Результат.Получение = Ложь;
			Результат.ОшибкаПриПолучении = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			
		КонецПопытки;
	КонецЕсли;
	
	Соединение.Отключиться();
	
	Возврат Результат;
	
КонецФункции

// Отправляет тестовое сообщение.
//
&НаСервере
Процедура ОтправитьТестовоеСообщение(Соединение, АдресЭлектроннойПочты, НаименованиеУчетнойЗаписи)
	
	ПараметрыОтправки = Почта.СформироватьСтруктуруПараметровОтправки();
	
	СтруктураАдреса = Почта.СформироватьСтруктуруПочтовогоАдреса(
		АдресЭлектроннойПочты, // Адрес
		""); // ОтображаемоеИмя
	
	ПараметрыОтправки.Отправитель = СтруктураАдреса;
	ПараметрыОтправки.ОбратныйАдрес.Добавить(СтруктураАдреса);
	ПараметрыОтправки.Получатели.Добавить(СтруктураАдреса);
	
	ПараметрыОтправки.Тема = НСтр("ru = 'Тестовое письмо (1С:Поддержка пользователей)'");
	
	ТекстПисьма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Это письмо отправлено из конфигурации ""1С:Поддержка пользователей"" для проверки учетной записи %1.
			|Не отвечайте на это письмо'"),
			ВКавычках(НаименованиеУчетнойЗаписи));
	
	СтруктураТекста = Почта.СформироватьСтруктуруТекстаПочтовогоСообщения(
		Перечисления.ТипыТекстовПочтовыхСообщений.ПростойТекст, // ТипТекста
		ТекстПисьма, // Текст
		""); // Кодировка
	
	ПараметрыОтправки.Тексты.Добавить(СтруктураТекста);
	
	СообщениеОбОшибке = "";
	Если Не Почта.ОтправитьСообщение(
		Соединение,
		ПараметрыОтправки,
		СообщениеОбОшибке) Тогда
		ВызватьИсключение СообщениеОбОшибке;
	КонецЕсли;
	
КонецПроцедуры
