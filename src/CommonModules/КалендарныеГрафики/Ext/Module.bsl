﻿////////////////////////////////////////////////////////////////////////////////
// ФУНЦИИ БИБЛИОТЕКИ

// Функция возвращает массив дат, которые отличается указанной даты на количество дней,
// входящих в указанный график
//
// Параметры
//	Календарь		- календарь, который необходимо использовать, тип СправочникСсылка.Календари
//	ДатаОт			- дата, от которой нужно рассчитать количество дней, тип Дата
//	МассивДней		- массив с количеством дней, на которые нужно увеличить дату начала, тип Массив,Число
//	РассчитыватьСледующуюДатуОтПредыдущей	- нужно ли рассчитывать следующую дату от предыдущей или
//											  все даты рассчитываются от переданной даты
//
// Возвращаемое значение
//	Массив		- массив дат, увеличенных на количество дней, входящих в график
//
Функция ПолучитьМассивДатПоКалендарю(Знач Календарь, Знач ДатаОт, Знач МассивДней, Знач РассчитыватьСледующуюДатуОтПредыдущей = Ложь) Экспорт
	
	ДатаОт = НачалоДня(ДатаОт);
	
	ТаблицаДат = Новый ТаблицаЗначений;
	ТаблицаДат.Колонки.Добавить("ИндексСтроки", Новый ОписаниеТипов("Число"));
	ТаблицаДат.Колонки.Добавить("КоличествоДней", Новый ОписаниеТипов("Число"));
	
	КоличествоДней = 0;
	НомерСтроки = 0;
	Для Каждого СтрокаДней Из МассивДней Цикл
		КоличествоДней = КоличествоДней + СтрокаДней;
		
		Строка = ТаблицаДат.Добавить();
		Строка.ИндексСтроки			= НомерСтроки;
		Если РассчитыватьСледующуюДатуОтПредыдущей Тогда
			Строка.КоличествоДней	= КоличествоДней;
		Иначе
			Строка.КоличествоДней	= СтрокаДней;
		КонецЕсли;
			
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Календарь",	Календарь);
	Запрос.УстановитьПараметр("ДатаОт",		ДатаОт);
	Запрос.УстановитьПараметр("Таблица",	ТаблицаДат);
	
	// Алгоритм работает следующим образом:
	//  Получаем для ДатаОт каким днем с начала года эта дата является
	//  К этому дню прибавляем количество дней с начала года, которое должно быть у конечной даты
	//  Получаем максимальный номер дня в году для этого года
	//  Проверяем, не превышает ли полученное число количество дней
	//  Если превышает, используем следующий год, если нет, то текущий
	//  Ищем, минимальную дату, которая соответствует нужному нам дню в году
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДат.ИндексСтроки,
	|	ТаблицаДат.КоличествоДней
	|ПОМЕСТИТЬ ВТ_ТаблицаДат
	|ИЗ
	|	&Таблица КАК ТаблицаДат
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ГрафикЗаГод.КоличествоДнейВГрафикеСНачалаГода) КАК КоличествоДнейВсего
	|ПОМЕСТИТЬ ВТ_КоличествоРабочихДнейВГоду
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК ГрафикЗаГод
	|ГДЕ
	|	ГрафикЗаГод.Календарь = &Календарь
	|	И ГрафикЗаГод.Год = ГОД(&ДатаОт)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГрафикЗаГод.Год,
	|	ГрафикЗаГод.КоличествоДнейВГрафикеСНачалаГода КАК КоличествоДнейВГрафикеСНачалаГода,
	|	КоличествоРабочихДнейВГоду.КоличествоДнейВсего
	|ПОМЕСТИТЬ ВТ_КалендарныйГрафик
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК ГрафикЗаГод
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_КоличествоРабочихДнейВГоду КАК КоличествоРабочихДнейВГоду
	|		ПО (ГрафикЗаГод.Календарь = &Календарь)
	|			И (ГрафикЗаГод.ДатаГрафика = &ДатаОт)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	КоличествоДнейВГрафикеСНачалаГода
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КалендарныйГрафик.ИндексСтроки,
	|	КалендарныйГрафик.КоличествоДней,
	|	ЕСТЬNULL(КалендарныйГрафик.ДатаПоКалендарю, НЕОПРЕДЕЛЕНО) КАК ДатаПоКалендарю
	|ИЗ
	|	(ВЫБРАТЬ
	|		ГрафикЗаГодДатаОт.ИндексСтроки КАК ИндексСтроки,
	|		ГрафикЗаГодДатаОт.КоличествоДней КАК КоличествоДней,
	|		МИНИМУМ(ГрафикЗаГод.ДатаГрафика) КАК ДатаПоКалендарю
	|	ИЗ
	|		(ВЫБРАТЬ
	|			ТаблицаДат.ИндексСтроки КАК ИндексСтроки,
	|			ТаблицаДат.КоличествоДней КАК КоличествоДней,
	|			ВЫБОР
	|				КОГДА КалендарныйГрафик.КоличествоДнейВсего ЕСТЬ NULL 
	|						ИЛИ КалендарныйГрафик.КоличествоДнейВсего >= КалендарныйГрафик.КоличествоДнейВГрафикеСНачалаГода + ТаблицаДат.КоличествоДней
	|					ТОГДА ГОД(&ДатаОт)
	|				ИНАЧЕ ГОД(&ДатаОт) + 1
	|			КОНЕЦ КАК ГодДатыОкончания,
	|			КалендарныйГрафик.КоличествоДнейВГрафикеСНачалаГода + ТаблицаДат.КоличествоДней - ВЫБОР
	|				КОГДА КалендарныйГрафик.КоличествоДнейВсего < КалендарныйГрафик.КоличествоДнейВГрафикеСНачалаГода + ТаблицаДат.КоличествоДней
	|					ТОГДА КалендарныйГрафик.КоличествоДнейВсего
	|				ИНАЧЕ 0
	|			КОНЕЦ КАК КоличествоДнейДляДатыПо
	|		ИЗ
	|			ВТ_ТаблицаДат КАК ТаблицаДат
	|				ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КалендарныйГрафик КАК КалендарныйГрафик
	|				ПО (ИСТИНА)) КАК ГрафикЗаГодДатаОт
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КалендарныеГрафики КАК ГрафикЗаГод
	|			ПО (ГрафикЗаГод.Календарь = &Календарь)
	|				И ГрафикЗаГодДатаОт.КоличествоДнейДляДатыПо = ГрафикЗаГод.КоличествоДнейВГрафикеСНачалаГода
	|				И ГрафикЗаГодДатаОт.ГодДатыОкончания = ГрафикЗаГод.Год
	|				И (ГрафикЗаГод.ДатаГрафика >= &ДатаОт)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ГрафикЗаГодДатаОт.ИндексСтроки,
	|		ГрафикЗаГодДатаОт.КоличествоДней) КАК КалендарныйГрафик
	|
	|УПОРЯДОЧИТЬ ПО
	|	КалендарныйГрафик.ИндексСтроки";
	Выборка = Запрос.Выполнить().Выбрать();
	
	МассивДат = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ДатаПоКалендарю = Неопределено Тогда
			СообщениеОбОшибке = НСтр("ru = 'В календаре ''%1'' с даты %2 нет указанного количества рабочих дней!'");
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				СообщениеОбОшибке,
				Календарь, Формат(ДатаОт, "ДЛФ=D"));
		КонецЕсли;
		
		МассивДат.Добавить(Выборка.ДатаПоКалендарю);
	КонецЦикла;
	
	Возврат МассивДат;
	
КонецФункции

// Функция возвращает дату, которая отличается указанной даты на количество дней,
// входящих в указанный график
//
// Параметры
//	Календарь		- календарь, который необходимо использовать, тип СправочникСсылка.Календари
//	ДатаОт			- дата, от которой нужно рассчитать количество дней, тип Дата
//	КоличествоДней	- количество дней, на которые нужно увеличить дату начала, тип Число
//
// Возвращаемое значение
//	Дата			- дата, увеличенная на количество дней, входящих в график
//
Функция ПолучитьДатуПоКалендарю(Знач Календарь, Знач ДатаОт, Знач КоличествоДней) Экспорт
	
	ДатаОт = НачалоДня(ДатаОт);
	
	Если КоличествоДней = 0 Тогда
		Возврат ДатаОт;
	КонецЕсли;
	
	МассивДней = Новый Массив;
	МассивДней.Добавить(КоличествоДней);
	
	МассивДат = ПолучитьМассивДатПоКалендарю(Календарь, ДатаОт, МассивДней);
	
	Возврат МассивДат[0];
	
КонецФункции

// Функция определяет количество дней, входящих в календарь, для указанного периода
//
// Параметры
//	Календарь		- календарь, который необходимо использовать, тип СправочникСсылка.Календари
//	ДатаНачала		- дата начала периода
//	ДатаОкончания	- дата окончания периода
//
// Возвращаемое значение
//	Число		- количество дней между датами начала и окончания
//
Функция ПолучитьРазностьДатПоКалендарю(Знач Календарь, Знач ДатаНачала, Знач ДатаОкончания) Экспорт
	
	ДатаНачала		= НачалоДня(ДатаНачала);
	ДатаОкончания	= НачалоДня(ДатаОкончания);
	
	Если ДатаНачала = ДатаОкончания Тогда
		Возврат 0;
	КонецЕсли;
	
	РазныеГода = Год(ДатаНачала) <> Год(ДатаОкончания);
	
	Запрос = Новый Запрос;
	
	МассивДатНачала = Новый Массив;
	МассивДатНачала.Добавить(ДатаНачала);
	Если РазныеГода Тогда
		МассивДатНачала.Добавить(НачалоДня(КонецГода(ДатаНачала)));
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Календарь",			Календарь);
	Запрос.УстановитьПараметр("МассивДатНачала",	МассивДатНачала);
	Запрос.УстановитьПараметр("ГодДатыНачала",		Год(ДатаНачала));
	
	Запрос.УстановитьПараметр("ДатаОкончания",		ДатаОкончания);
	Запрос.УстановитьПараметр("ГодДатыОкончания",	Год(ДатаОкончания));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КалендарныеГрафики.КоличествоДнейВГрафикеСНачалаГода КАК КоличествоДней,
	|	КалендарныеГрафики.ДатаГрафика КАК ДатаГрафика
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Календарь = &Календарь
	|	И (КалендарныеГрафики.Год = &ГодДатыНачала
	|				И КалендарныеГрафики.ДатаГрафика В (&МассивДатНачала)
	|			ИЛИ КалендарныеГрафики.Год = &ГодДатыОкончания
	|				И КалендарныеГрафики.ДатаГрафика = &ДатаОкончания)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаГрафика";
	ТаблицаДней = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаДней.Количество() < ?(РазныеГода, 3, 2) Тогда
		СообщениеОбОшибке = НСтр("ru = 'Не заполнен календарь ""%1"" за период %2!'");
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			СообщениеОбОшибке,
			Календарь, ПредставлениеПериода(ДатаНачала, КонецДня(ДатаОкончания)));
	КонецЕсли;
	
	КоличествоДнейДатыНачала = ТаблицаДней[0].КоличествоДней;
	КоличествоДнейДатыОкончания = ТаблицаДней[?(РазныеГода, 2, 1)].КоличествоДней + ?(РазныеГода, ТаблицаДней[1].КоличествоДней, 0);
	
	Возврат КоличествоДнейДатыОкончания - КоличествоДнейДатыНачала;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБНОВЛЕНИЕ ИНФОРМАЦИОННОЙ БАЗЫ

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.6.2";
	Обработчик.Процедура = "КалендарныеГрафики.СоздатьПроизводственныйКалендарьНа2010Год";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.1.6";
	Обработчик.Процедура = "КалендарныеГрафики.СоздатьПроизводственныйКалендарьНа2011Год";
	
КонецПроцедуры

// Процедура заполняет регистр сведений Календарные графики за указанный год
//
// Параметры
//	НомерГода		- число, номер года, за который необходимо заполнить регистр
//	РабочиеДни		- массив, дни, приходящиеся на выходные, которые следует считать рабочими
//	ПраздничныеДни	- массив, дни, приходящиеся на рабочие, которые следует считать выходными
//
// Возвращаемое значение
//	Нет
//
Процедура ЗаполнитьКалендарныйГрафик(НомерГода, РабочиеДни, ПраздничныеДни)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Календари.Ссылка
	|ИЗ
	|	Справочник.Календари КАК Календари
	|ГДЕ
	|	Календари.Наименование = ""Производственный календарь""";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ПроизводственныйКалендарь = Выборка.Ссылка;
		
	Иначе
		ПроизводственныйКалендарь = Справочники.Календари.СоздатьЭлемент();
		ПроизводственныйКалендарь.Наименование = "Производственный календарь";
		ПроизводственныйКалендарь.Записать();
		
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.КалендарныеГрафики.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Календарь.Установить(ПроизводственныйКалендарь.Ссылка);
	НаборЗаписей.Отбор.Год.Установить(НомерГода);
	
	КоличествоРабочихДнейСНачалаГода = 0;
	
	Для НомерМесяца = 1 По 12 Цикл
		Для НомерДня = 1 По День(КонецМесяца(Дата(НомерГода, НомерМесяца, 1))) Цикл
			ДатаГрафика = Дата(НомерГода, НомерМесяца, НомерДня);
			
			ДеньВключенВГрафик = ПраздничныеДни.Найти(ДатаГрафика) = Неопределено
				И (РабочиеДни.Найти(ДатаГрафика) <> Неопределено ИЛИ ДеньНедели(ДатаГрафика) <= 5);
			
			Если ДеньВключенВГрафик Тогда
				КоличествоРабочихДнейСНачалаГода = КоличествоРабочихДнейСНачалаГода + 1;
			КонецЕсли;
			
			Строка = НаборЗаписей.Добавить();
			Строка.Календарь							= ПроизводственныйКалендарь.Ссылка;
			Строка.Год									= НомерГода;
			Строка.ДатаГрафика							= ДатаГрафика;
			Строка.ДеньВключенВГрафик					= ДеньВключенВГрафик;
			Строка.КоличествоДнейВГрафикеСНачалаГода	= КоличествоРабочихДнейСНачалаГода;
		КонецЦикла;
	КонецЦикла;
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

// Процедура создает в справочнике Календари календарь на 2010 год, соответствующий производственному
// календарю Российской Федерации, если в справочнике нет ни одного календаря за этот год
//
Процедура СоздатьПроизводственныйКалендарьНа2010Год() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КалендарныеГрафики.Календарь
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Год = 2010";
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	// Записываем данные за 2010 год
	
	РабочиеДни = Новый Массив;
	ПраздничныеДни = Новый Массив;
	
	// праздники РФ
	ПраздничныеДни.Добавить(Дата(2010, 1, 1));
	ПраздничныеДни.Добавить(Дата(2010, 1, 2));
	ПраздничныеДни.Добавить(Дата(2010, 1, 3));
	ПраздничныеДни.Добавить(Дата(2010, 1, 4));
	ПраздничныеДни.Добавить(Дата(2010, 1, 5));
	ПраздничныеДни.Добавить(Дата(2010, 1, 7));
	ПраздничныеДни.Добавить(Дата(2010, 2, 23));
	ПраздничныеДни.Добавить(Дата(2010, 3, 8));
	ПраздничныеДни.Добавить(Дата(2010, 5, 1));
	ПраздничныеДни.Добавить(Дата(2010, 5, 9));
	ПраздничныеДни.Добавить(Дата(2010, 6, 12));
	ПраздничныеДни.Добавить(Дата(2010, 11, 4));
	
	// Переносы праздников с выходных дней
	ПраздничныеДни.Добавить(Дата(2010, 1, 6));
	ПраздничныеДни.Добавить(Дата(2010, 1, 8));
	ПраздничныеДни.Добавить(Дата(2010, 2, 22));
	РабочиеДни.Добавить(Дата(2010, 2, 27));
	ПраздничныеДни.Добавить(Дата(2010, 5, 3));
	ПраздничныеДни.Добавить(Дата(2010, 5, 10));
	ПраздничныеДни.Добавить(Дата(2010, 6, 14));
	ПраздничныеДни.Добавить(Дата(2010, 11, 5));
	РабочиеДни.Добавить(Дата(2010, 11, 7));
	
	ЗаполнитьКалендарныйГрафик(2010, РабочиеДни, ПраздничныеДни);
	
КонецПроцедуры

// Процедура создает в справочнике Календари календарь на 2011 год, соответствующий производственному
// календарю Российской Федерации, если в справочнике нет ни одного календаря за этот год
//
Процедура СоздатьПроизводственныйКалендарьНа2011Год() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КалендарныеГрафики.Календарь
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Год = 2011";
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	// Записываем данные за 2011 год
	
	РабочиеДни = Новый Массив;
	ПраздничныеДни = Новый Массив;
	
	// праздники РФ
	ПраздничныеДни.Добавить(Дата(2011, 1, 1));
	ПраздничныеДни.Добавить(Дата(2011, 1, 2));
	ПраздничныеДни.Добавить(Дата(2011, 1, 3));
	ПраздничныеДни.Добавить(Дата(2011, 1, 4));
	ПраздничныеДни.Добавить(Дата(2011, 1, 5));
	ПраздничныеДни.Добавить(Дата(2011, 1, 7));
	ПраздничныеДни.Добавить(Дата(2011, 2, 23));
	ПраздничныеДни.Добавить(Дата(2011, 3, 8));
	ПраздничныеДни.Добавить(Дата(2011, 5, 1));
	ПраздничныеДни.Добавить(Дата(2011, 5, 9));
	ПраздничныеДни.Добавить(Дата(2011, 6, 12));
	ПраздничныеДни.Добавить(Дата(2011, 11, 4));
	
	// Переносы праздников с выходных дней
	ПраздничныеДни.Добавить(Дата(2011, 1, 6));
	ПраздничныеДни.Добавить(Дата(2011, 1, 10));
	ПраздничныеДни.Добавить(Дата(2011, 5, 2));
	ПраздничныеДни.Добавить(Дата(2011, 6, 13));
	
	ЗаполнитьКалендарныйГрафик(2011, РабочиеДни, ПраздничныеДни);
	
КонецПроцедуры

// Процедура создает в справочнике Календари календарь на 2012 год, соответствующий производственному
// календарю Российской Федерации, если в справочнике нет ни одного календаря за этот год
//
Процедура СоздатьПроизводственныйКалендарьНа2012Год() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КалендарныеГрафики.Календарь
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Год = 2012";
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	// Записываем данные за 2012 год
	РабочиеДни = Новый Массив;
	ПраздничныеДни = Новый Массив;
	
	// праздники РФ
	ПраздничныеДни.Добавить(Дата(2012, 1, 1));
	ПраздничныеДни.Добавить(Дата(2012, 1, 2));
	ПраздничныеДни.Добавить(Дата(2012, 1, 3));
	ПраздничныеДни.Добавить(Дата(2012, 1, 4));
	ПраздничныеДни.Добавить(Дата(2012, 1, 5));
	ПраздничныеДни.Добавить(Дата(2012, 1, 7));
	ПраздничныеДни.Добавить(Дата(2012, 2, 23));
	ПраздничныеДни.Добавить(Дата(2012, 3, 8));
	ПраздничныеДни.Добавить(Дата(2012, 5, 1));
	ПраздничныеДни.Добавить(Дата(2012, 5, 9));
	ПраздничныеДни.Добавить(Дата(2012, 6, 12));
	ПраздничныеДни.Добавить(Дата(2012, 11, 4));
	
	// Переносы праздников с выходных дней
	ПраздничныеДни.Добавить(Дата(2012, 1, 6));
	ПраздничныеДни.Добавить(Дата(2012, 1, 9));
	ПраздничныеДни.Добавить(Дата(2012, 3, 9));
	ПраздничныеДни.Добавить(Дата(2012, 4, 30));
	ПраздничныеДни.Добавить(Дата(2012, 6, 11));
	ПраздничныеДни.Добавить(Дата(2012, 11, 5));
	ПраздничныеДни.Добавить(Дата(2012, 12, 31));
	
	РабочиеДни.Добавить(Дата(2012, 3, 11));
	РабочиеДни.Добавить(Дата(2012, 4, 28));
	РабочиеДни.Добавить(Дата(2012, 6, 9));
	РабочиеДни.Добавить(Дата(2012, 12, 29));
	
	ЗаполнитьКалендарныйГрафик(2012, РабочиеДни, ПраздничныеДни);
	
КонецПроцедуры
