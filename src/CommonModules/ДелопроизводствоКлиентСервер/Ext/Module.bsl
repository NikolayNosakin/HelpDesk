﻿/////////////////////////////////////////////////////////////////////////////////////////
// ПРОВЕРКА ТИПОВ ЗНАЧЕНИЙ

// Возвращает Истина, если переданное значение является
// ссылкой на ВнутренниеДокументы или Объектом типа ВнутренниеДокументы
Функция ЭтоВнутреннийДокумент(Значение) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает Истина, если переданное значение является
// ссылкой на ВходящиеДокументы или Объектом типа ВходящиеДокументы
Функция ЭтоВходящийДокумент(Значение) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает Истина, если переданное значение является
// ссылкой на ИсходящиеДокументы или Объектом типа ИсходящиеДокументы
Функция ЭтоИсходящийДокумент(Значение) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает Истина, если переданное значение является
// ссылкой на *Документы или Объектом типа *Документы
Функция ЭтоДокумент(Значение) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает Истина, если переданное значение является
// ссылкой на ВнутренниеДокументы или Объектом типа ВнутренниеДокументы
// и у вида документа установлен признак того, что это комплект
Функция ЭтоКомплект(Значение) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает Истина, если переданное значение является
// ссылкой на Файлы или Объектом типа Файлы
Функция ЭтоФайл(Значение) Экспорт
	
	#Если Сервер Тогда
		Возврат ТипЗнч(Значение) = Тип("СправочникСсылка.Файлы")
			Или ТипЗнч(Значение) = Тип("СправочникОбъект.Файлы");
	#Иначе
		Возврат ТипЗнч(Значение) = Тип("СправочникСсылка.Файлы");
	#КонецЕсли
	
КонецФункции

// Возвращает Истина, если переданное значение является
// ссылкой на ШаблоныВнутреннихДокументов или Объектом типа ШаблоныВнутреннихДокументов
Функция ЭтоШаблонВнутреннегоДокумента(Значение) Экспорт
	
Возврат Ложь;
	
КонецФункции

// Возвращает Истина, если переданное значение является
// ссылкой на ШаблоныВходящихДокументов или Объектом типа ШаблоныВходящихДокументов
Функция ЭтоШаблонВходящегоДокумента(Значение) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает Истина, если переданное значение является
// ссылкой на ШаблоныИсходящихДокументов или Объектом типа ШаблоныИсходящихДокументов
Функция ЭтоШаблонИсходящегоДокумента(Значение) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает Истина, если переданное значение является
// ссылкой на шаблон документа или Объектом типа шаблон документа
Функция ЭтоШаблонДокумента(Значение) Экспорт
	
	Возврат Ложь;	
	
КонецФункции

// Возвращает Истина, если переданное значение является
// ссылкой на ЗадачаИсполнителя или Объектом типа ЗадачаИсполнителя
Функция ЭтоЗадачаИсполнителя(Значение) Экспорт
	
	#Если Сервер Тогда
		Возврат ТипЗнч(Значение) = Тип("ЗадачаСсылка.ЗадачаИсполнителя")
			Или ТипЗнч(Значение) = Тип("ЗадачаОбъект.ЗадачаИсполнителя");
	#Иначе
		Возврат ТипЗнч(Значение) = Тип("ЗадачаСсылка.ЗадачаИсполнителя");
	#КонецЕсли
	
КонецФункции

// Возвращает Истина, если переданное значение является
// ссылкой на Корреспонденты или Объектом типа Корреспонденты
Функция ЭтоКорреспондент(Значение) Экспорт
	
	#Если Сервер Тогда
		Возврат ТипЗнч(Значение) = Тип("СправочникСсылка.Контрагенты")
			Или ТипЗнч(Значение) = Тип("СправочникОбъект.Контрагенты");
	#Иначе
		Возврат ТипЗнч(Значение) = Тип("СправочникСсылка.Контрагенты");
	#КонецЕсли
	
КонецФункции

// Сформировать заголовок группы Файлы
Функция КоличествоФайловВЗаголовок(КоличествоФайлов) Экспорт
	
	Заголовок = НСтр("ru = 'Файлы'");
	
	Если КоличествоФайлов <> 0 Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Файлы (%1)'"),
			КоличествоФайлов);
	КонецЕсли;
	
	Возврат Заголовок;
	
КонецФункции

// Получает строковое строку из регистрационного номера и даты регистрации
Функция ПредставлениеНомераИДаты(РегистрационныйНомер, ДатаРегистрации) Экспорт
	
	Если ЗначениеЗаполнено(РегистрационныйНомер) И ЗначениеЗаполнено(ДатаРегистрации) Тогда
		
		ПредставлениеНомераИДаты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '№ %1 от %2'"),
			РегистрационныйНомер,
			Формат(ДатаРегистрации, "ДФ=dd.MM.yyyy"));
		
	ИначеЕсли ЗначениеЗаполнено(РегистрационныйНомер) Тогда
		
		ПредставлениеНомераИДаты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '№ %1'"),
			РегистрационныйНомер);
		
	Иначе
		
		ПредставлениеНомераИДаты = "";
	
	КонецЕсли;
	
	Возврат ПредставлениеНомераИДаты;
	
КонецФункции

// Возвращает Истина, если переданное значение является
// ссылкой на *Документы
Функция ЭтоСсылкаНаДокумент(Ссылка) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Подпиь к количеству лет по склонениям
Функция ПодписьЛет(Количество) Экспорт
	
	Если Количество > 10 И Количество < 20 Тогда
		Возврат НСтр("ru = 'лет'");
	Иначе
		Срок = Количество - Цел(Количество / 10) * 10;
		Если Срок = 0 Тогда
			Возврат НСтр("ru = 'лет'");
		ИначеЕсли Срок = 1 Тогда
			Возврат НСтр("ru = 'год'");
		ИначеЕсли Срок < 5 Тогда
			Возврат НСтр("ru = 'года'");
		Иначе
			Возврат НСтр("ru = 'лет'");
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// Строковое описание разности дат в днях с учетом склонений
Функция РазностьДатВДнях(Дата1, Дата2) Экспорт
	
	ИспользоватьДатуИВремяВСрокахЗадач = РаботаСБизнесПроцессами.ПолучитьИспользованиеДатыИВремениВСрокахЗадач();
	
	Если ИспользоватьДатуИВремяВСрокахЗадач Тогда
		ЧислоЧасов = Окр((Дата1 - Дата2) / (60*60));
		ЧислоДней = Окр(ЧислоЧасов / 24);
		ЧислоЧасов = ЧислоЧасов - ЧислоДней * 24;
	Иначе
		ЧислоЧасов = 0;
		ЧислоДней = (НачалоДня(Дата1) - НачалоДня(Дата2)) / (60*60*24);
	КонецЕсли;
		
	Если ЧислоЧасов < 0 Тогда
		ЧислоДней = ЧислоДней - 1;
		ЧислоЧасов = ЧислоЧасов + 24;
	КонецЕсли;
	ПодписьДней = ПолучитьПодписьДней(ЧислоДней);
	ПодписьЧасов = ПолучитьПодписьЧасов(ЧислоЧасов);
	
	Если ИспользоватьДатуИВремяВСрокахЗадач Тогда
		Если ЧислоДней > 0 И ЧислоЧасов > 0 Тогда
			Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"%1 %2 и %3 %4",
				Строка(ЧислоДней),
				ПодписьДней,
				Строка(ЧислоЧасов),
				ПодписьЧасов);
		ИначеЕсли ЧислоДней > 0 Тогда
			Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"%1 %2",
				Строка(ЧислоДней),
				ПодписьДней);
		ИначеЕсли ЧислоЧасов > 0 Тогда
			Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"%1 %2",
				Строка(ЧислоЧасов),
				ПодписьЧасов);
		Иначе
			Возврат НСтр("ru = 'Менее 1 часа'");
		КонецЕсли;
	Иначе
		Если ЧислоДней > 0 Тогда
			Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"%1 %2",
				Строка(ЧислоДней),
				ПодписьДней);
		Иначе
			Возврат НСтр("ru = 'Менее 1 дня'");
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// Подпиь к количеству дней по склонениям
Функция ПолучитьПодписьДней(ЧислоДней) Экспорт
	
	Если ЧислоДней > 10 И ЧислоДней < 20 Тогда
		Подпись = НСтр("ru = 'дней'");
	Иначе
		ПоследниеДвеЦифры = ЧислоДней - Цел(ЧислоДней / 100) * 100;
		ПоследняяЦифра = ЧислоДней - Цел(ЧислоДней / 10) * 10;
		
		Если ПоследняяЦифра = 0 Тогда
			Подпись = НСтр("ru = 'дней'");
		ИначеЕсли ПоследниеДвеЦифры > 10 И ПоследниеДвеЦифры < 20 Тогда
			Подпись = Нстр("ru = 'дней'");
		ИначеЕсли ПоследниеДвеЦифры < 10 Или ПоследниеДвеЦифры > 20 Тогда
			Если ПоследняяЦифра = 1 Тогда
				Подпись = Нстр("ru = 'день'");
			ИначеЕсли ПоследняяЦифра < 5 Тогда
				Подпись = НСтр("ru = 'дня'");
			Иначе
				Подпись = НСтр("ru = 'дней'");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Подпись;
	
КонецФункции

// Подпиь к количеству рабочих дней по склонениям
Функция ПолучитьПодписьРабочихДней(ЧислоДней) Экспорт
	
	Если ЧислоДней > 10 И ЧислоДней < 20 Тогда
		Подпись = НСтр("ru = 'рабочих дней'");
	Иначе
		ПоследниеДвеЦифры = ЧислоДней - Цел(ЧислоДней / 100) * 100;
		ПоследняяЦифра = ЧислоДней - Цел(ЧислоДней / 10) * 10;
		
		Если ПоследняяЦифра = 0 Тогда
			Подпись = НСтр("ru = 'рабочих дней'");
		ИначеЕсли ПоследниеДвеЦифры > 10 И ПоследниеДвеЦифры < 20 Тогда
			Подпись = Нстр("ru = 'рабочих дней'");
		ИначеЕсли ПоследниеДвеЦифры < 10 Или ПоследниеДвеЦифры > 20 Тогда
			Если ПоследняяЦифра = 1 Тогда
				Подпись = Нстр("ru = 'рабочий день'");
			ИначеЕсли ПоследняяЦифра < 5 Тогда
				Подпись = НСтр("ru = 'рабочих дня'");
			Иначе
				Подпись = НСтр("ru = 'рабочих дней'");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Подпись;
	
КонецФункции

// Подпиь к количеству часов по склонениям
Функция ПолучитьПодписьЧасов(ЧислоЧасов) Экспорт
	
	Если ЧислоЧасов > 10 И ЧислоЧасов < 20 Тогда
		Подпись = НСтр("ru = 'часов'");
	Иначе
		Срок = ЧислоЧасов - Цел(ЧислоЧасов / 10) * 10;
		Если Срок = 0 Тогда
			Подпись = НСтр("ru = 'часов'");
		ИначеЕсли Срок = 1 Тогда
			Подпись = Нстр("ru = 'час'");
		ИначеЕсли Срок < 5 Тогда
			Подпись = НСтр("ru = 'часа'");
		Иначе
			Подпись = НСтр("ru = 'часов'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат Подпись;
	
КонецФункции

// Подпиь к количеству минут по склонениям
Функция ПолучитьПодписьМинут(ЧислоМинут) Экспорт
	
	Если ЧислоМинут > 10 И ЧислоМинут < 20 Тогда
		Подпись = НСтр("ru = 'минут'");
	Иначе
		Срок = ЧислоМинут - Цел(ЧислоМинут / 10) * 10;
		Если Срок = 0 Тогда
			Подпись = НСтр("ru = 'минут'");
		ИначеЕсли Срок = 1 Тогда
			Подпись = НСтр("ru = 'минута'");
		ИначеЕсли Срок < 5 Тогда
			Подпись = НСтр("ru = 'минуты'");
		Иначе
			Подпись = НСтр("ru = 'минут'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат Подпись;
	
КонецФункции

// Подпиь к количеству месяцев по склонениям
Функция ПолучитьПодписьМесяцев(ЧислоМесяцев) Экспорт
	
	Если ЧислоМесяцев > 10 И ЧислоМесяцев < 20 Тогда
		Подпись = НСтр("ru = 'месяцев'");
	Иначе
		Срок = ЧислоМесяцев - Цел(ЧислоМесяцев / 10) * 10;
		Если Срок = 0 Тогда
			Подпись = НСтр("ru = 'месяцев'");
		ИначеЕсли Срок = 1 Тогда
			Подпись = НСтр("ru = 'месяц'");
		ИначеЕсли Срок < 5 Тогда
			Подпись = НСтр("ru = 'месяца'");
		Иначе
			Подпись = НСтр("ru = 'месяцев'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат Подпись;
	
КонецФункции

// Подпиь к количеству недель по склонениям
Функция ПолучитьПодписьНедель(ЧислоНедель) Экспорт
	
	Если ЧислоНедель > 10 И ЧислоНедель < 20 Тогда
		Подпись = НСтр("ru = 'недель'");
	Иначе
		Срок = ЧислоНедель - Цел(ЧислоНедель / 10) * 10;
		Если Срок = 0 Тогда
			Подпись = НСтр("ru = 'недель'");
		ИначеЕсли Срок = 1 Тогда
			Подпись = НСтр("ru = 'неделя'");
		ИначеЕсли Срок < 5 Тогда
			Подпись = НСтр("ru = 'недели'");
		Иначе
			Подпись = НСтр("ru = 'недель'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат Подпись;
	
КонецФункции

// Возвращает Истина, если переданное значение является
// ссылкой на Мероприятия или Объектом типа Мероприятия
Функция ЭтоМероприятие(Значение) Экспорт
	Возврат Ложь;	
КонецФункции

// Возвращает Истина, если переданное значение является
// ссылкой на Проекты или Объектом типа Проекты
Функция ЭтоПроект(Значение) Экспорт
	
	#Если Сервер Тогда
		Возврат ТипЗнч(Значение) = Тип("СправочникСсылка.Проекты")
			Или ТипЗнч(Значение) = Тип("СправочникОбъект.Проекты");
	#Иначе
		Возврат ТипЗнч(Значение) = Тип("СправочникСсылка.Проекты");
	#КонецЕсли
	
КонецФункции

// Возвращает Истина, если переданное значение является
// ссылкой на ПроектныеЗадачи или Объектом типа ПроектныеЗадачи
Функция ЭтоПроектнаяЗадача(Значение) Экспорт
	
	#Если Сервер Тогда
		Возврат ТипЗнч(Значение) = Тип("СправочникСсылка.ПроектныеЗадачи")
			Или ТипЗнч(Значение) = Тип("СправочникОбъект.ПроектныеЗадачи");
	#Иначе
		Возврат ТипЗнч(Значение) = Тип("СправочникСсылка.ПроектныеЗадачи");
	#КонецЕсли
	
КонецФункции

