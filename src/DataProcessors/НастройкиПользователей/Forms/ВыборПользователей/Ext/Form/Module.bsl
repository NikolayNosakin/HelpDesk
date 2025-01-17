﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ТипПользователя = Тип("СправочникСсылка.Пользователи") Тогда
		ВсеПользователи = Справочники.ГруппыПользователей.ВсеПользователи;
	Иначе
		ВсеПользователи = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи;
	КонецЕсли;
	
	РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ИспользоватьГруппы = ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей");
	ПользовательИсточник = Параметры.Пользователь;
	ТипПользователя = Параметры.ТипПользователя;
	ЗаполнитьСписокПользователей(ТипПользователя, ИспользоватьГруппы);
	
	КопироватьВсе = Параметры.КопироватьВсе;
	Если Параметры.ОчисткаНастроек Тогда
		ОчисткаНастроек = Параметры.ОчисткаНастроек;
		Заголовок = НСтр("ru='Выбор пользователей для очистки настроек'");
		Элементы.Надпись.Заголовок = НСтр("ru='Выберите пользователей, которым необходимо очистить настройки'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	ПараметрыОтбора = Новый Структура("Пометка", Истина);
	СписокПомеченныхПользователей = Новый СписокЗначений;
	Настройки.Удалить("СписокВсехПользователей");
	МассивПомеченныхПользователей = СписокВсехПользователей.НайтиСтроки(ПараметрыОтбора);
	
	Для Каждого СтрокаМассива Из МассивПомеченныхПользователей Цикл
		СписокПомеченныхПользователей.Добавить(СтрокаМассива.Пользователь);
	КонецЦикла;
	
	Настройки.Вставить("ПомеченныеПользователи", СписокПомеченныхПользователей);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Настройки);
	ПомеченныеПользователи = Настройки.Получить("ПомеченныеПользователи");
	
	Для Каждого СтрокаПомеченныеПользователи Из ПомеченныеПользователи Цикл
		
		ПользовательСсылка = СтрокаПомеченныеПользователи.Значение;
		
		Для Каждого СтрокаСпискаВсехПользователей Из СписокВсехПользователей Цикл
			Если СтрокаСпискаВсехПользователей.Пользователь = ПользовательСсылка Тогда
				СтрокаСпискаВсехПользователей.Пометка = Истина;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьЗаголовкиГруппПриПереключенииФлажка();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ГруппыПользователейПриАктивизацииСтроки(Элемент)
	
	ВыбраннаяГруппа = Элемент.ТекущиеДанные;
	Если ВыбраннаяГруппа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПрименитьФильтрГрупп(ВыбраннаяГруппа);
	Если ИспользоватьГруппы Тогда
		
		Если ВыбраннаяГруппа.Группа = ВсеПользователи Тогда
			Элементы.ГруппаПоказыватьПользователейДочернихГрупп.ТекущаяСтраница = Элементы.ГруппаНельзяУстановитьСвойство;
		Иначе
			Элементы.ГруппаПоказыватьПользователейДочернихГрупп.ТекущаяСтраница = Элементы.ГруппаУстановитьСвойство;
		КонецЕсли;
		
	Иначе
		Элементы.ГруппаПоказыватьПользователейДочернихГрупп.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПользователейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.Пользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПользователейДочернихГруппПриИзменении(Элемент)
	
	ВыделеннаяГруппаПользователей = Элементы.ГруппыПользователей.ТекущиеДанные;
	ПрименитьФильтрГрупп(ВыделеннаяГруппаПользователей);
	
	// Обновление заголовков групп
	ОчиститьЗаголовкиГрупп();
	ОбновитьЗаголовкиГруппПриПереключенииФлажка();
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиФлажокПриИзменении(Элемент)
	
	СтрокаСпискаПользователей = Элемент.Родитель.Родитель.ТекущиеДанные;
	СтрокаСпискаПользователей.Пометка = Не СтрокаСпискаПользователей.Пометка;
	ПоменятьПометку(СтрокаСпискаПользователей, Не СтрокаСпискаПользователей.Пометка);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	
	ПользователиПриемник = Новый Массив;
	Для Каждого Элемент Из СписокПользователей Цикл
		
		Если Элемент.Пометка Тогда
			ПользователиПриемник.Добавить(Элемент.Пользователь);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПользователиПриемник.Количество() = 0 Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Необходимо отметить одного или несколько пользователей.'"));
		Возврат;
	КонецЕсли;
	
	
	Результат = Новый Структура("ПользователиПриемник, КопироватьВсе, ОчисткаНастроек", 
		ПользователиПриемник, КопироватьВсе, ОчисткаНастроек);
	Оповестить("ВыборПользователя", Результат);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьВсе(Команда)
	
	Для Каждого СтрокаСпискаПользователей Из СписокПользователей Цикл
		ПоменятьПометку(СтрокаСпискаПользователей, Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьВыбранные(Команда)
	
	ВыделенныеЭлементы = Элементы.СписокПользователей.ВыделенныеСтроки;
	
	Если ВыделенныеЭлементы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Элемент Из ВыделенныеЭлементы Цикл
		СтрокаСпискаПользователей = СписокПользователей.НайтиПоИдентификатору(Элемент);
		ПоменятьПометку(СтрокаСпискаПользователей, Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометкуСоВсех(Команда)
	
	Для Каждого СтрокаСпискаПользователей Из СписокПользователей Цикл
		ПоменятьПометку(СтрокаСпискаПользователей, Ложь);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометкуВыбранных(Команда)
	
	ВыделенныеЭлементы = Элементы.СписокПользователей.ВыделенныеСтроки;
	
	Если ВыделенныеЭлементы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Элемент Из ВыделенныеЭлементы Цикл
		СтрокаСпискаПользователей = СписокПользователей.НайтиПоИдентификатору(Элемент);
		ПоменятьПометку(СтрокаСпискаПользователей, Ложь);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПользователяИлиГруппу(Команда)
	
	ТекущееЗначение = ТекущийЭлемент.ТекущиеДанные;
	
	Если ТипЗнч(ТекущееЗначение) = Тип("ДанныеФормыЭлементКоллекции") Тогда
		
		ПоказатьЗначение(Неопределено, ТекущееЗначение.Пользователь);
		
	ИначеЕсли ТипЗнч(ТекущееЗначение) = Тип("ДанныеФормыЭлементДерева") Тогда
		
		ПоказатьЗначение(Неопределено, ТекущееЗначение.Группа);
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура АктивныеПользователи(Команда)
	
	СтандартныеПодсистемыКлиентПереопределяемый.ОткрытьСписокАктивныхПользователей();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбновитьЗаголовкиГруппПриПереключенииФлажка()
	
	Для Каждого ГруппаПользователей Из ГруппыПользователей.ПолучитьЭлементы() Цикл
		
		Для Каждого СтрокаСпискаПользователей Из СписокВсехПользователей Цикл
			
			Если СтрокаСпискаПользователей.Пометка Тогда
				ЗначениеПометки = Истина;
				СтрокаСпискаПользователей.Пометка = Ложь;
				ОбновитьЗаголовокГруппы(ЭтотОбъект, ГруппаПользователей, СтрокаСпискаПользователей, ЗначениеПометки);
				СтрокаСпискаПользователей.Пометка = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЗаголовкиГрупп()
	
	Для Каждого ГруппаПользователей Из ГруппыПользователей.ПолучитьЭлементы() Цикл
		ОчиститьЗаголовокГруппы(ГруппаПользователей);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЗаголовокГруппы(ГруппаПользователей)
	
	ГруппаПользователей.ПомеченоПользователей = 0;
	ПодчиненныеГруппы = ГруппаПользователей.ПолучитьЭлементы();
	
	Для Каждого ПодчиненнаяГруппа Из ПодчиненныеГруппы Цикл
	
		ОчиститьЗаголовокГруппы(ПодчиненнаяГруппа);
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоменятьПометку(СтрокаСпискаПользователей, ЗначениеПометки)
	
	Если ИспользоватьГруппы Тогда
		
		ОбновитьЗаголовкиГрупп(ЭтотОбъект, СтрокаСпискаПользователей, ЗначениеПометки);
		
		СтрокаСпискаПользователей.Пометка = ЗначениеПометки;
		Отбор = Новый Структура("Пользователь", СтрокаСпискаПользователей.Пользователь); 
		НайденныеПользователи = СписокВсехПользователей.НайтиСтроки(Отбор);
		Для Каждого НайденныйПользователь Из НайденныеПользователи Цикл
			НайденныйПользователь.Пометка = ЗначениеПометки;
		КонецЦикла;
	Иначе
		СтрокаСпискаПользователей.Пометка = ЗначениеПометки; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗаголовкиГрупп(Форма, СтрокаСпискаПользователей, ЗначениеПометки)
	
	Для Каждого ГруппаПользователей Из Форма.ГруппыПользователей.ПолучитьЭлементы() Цикл
		
		ОбновитьЗаголовокГруппы(Форма, ГруппаПользователей, СтрокаСпискаПользователей, ЗначениеПометки);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗаголовокГруппы(Форма, ГруппаПользователей, СтрокаСпискаПользователей, ЗначениеПометки)
	
	ПользовательСсылка = СтрокаСпискаПользователей.Пользователь;
	Если Форма.ПоказыватьПользователейДочернихГрупп 
		Или Форма.ВсеПользователи = ГруппаПользователей.Группа Тогда
		Состав = ГруппаПользователей.ПолныйСостав;
	Иначе
		Состав = ГруппаПользователей.Состав;
	КонецЕсли;
	ПомеченныйПользователь = Состав.НайтиПоЗначению(ПользовательСсылка);
	
	Если ПомеченныйПользователь <> Неопределено И ЗначениеПометки <> СтрокаСпискаПользователей.Пометка Тогда
		ПомеченоПользователей = ГруппаПользователей.ПомеченоПользователей;
		ГруппаПользователей.ПомеченоПользователей = ?(ЗначениеПометки, ПомеченоПользователей + 1, ПомеченоПользователей - 1);
		ГруппаПользователей.НаименованиеГруппыИПомеченоПользователей = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1 (%2)'"),
			Строка(ГруппаПользователей.Группа), ГруппаПользователей.ПомеченоПользователей);
	КонецЕсли;
	
	// Обновить заголовки у всех подчиненных групп рекурсивно
	ПодчиненныеГруппы = ГруппаПользователей.ПолучитьЭлементы();
	Для Каждого ПодчиненнаяГруппа Из ПодчиненныеГруппы Цикл
		ОбновитьЗаголовокГруппы(Форма, ПодчиненнаяГруппа, СтрокаСпискаПользователей, ЗначениеПометки);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьФильтрГрупп(ТекущаяГруппа)
	
	СписокПользователей.Очистить();
	Если ТекущаяГруппа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПоказыватьПользователейДочернихГрупп Тогда
		СоставГруппы = ТекущаяГруппа.ПолныйСостав;
	Иначе
		СоставГруппы = ТекущаяГруппа.Состав;
	КонецЕсли;
	Для Каждого Элемент Из СписокВсехПользователей Цикл
		Если Не СоставГруппы.НайтиПоЗначению(Элемент.Пользователь) = Неопределено
			Или ВсеПользователи = ТекущаяГруппа.Группа Тогда
			СтрокаСписокПользователей = СписокПользователей.Добавить();
			СтрокаСписокПользователей.Пользователь = Элемент.Пользователь;
			СтрокаСписокПользователей.Пометка = Элемент.Пометка;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПользователей(ТипПользователя, ИспользоватьГруппы);
	
	ДеревоГрупп = РеквизитФормыВЗначение("ГруппыПользователей");
	СписокВсехПользователейТаблица = РеквизитФормыВЗначение("СписокВсехПользователей");
	СписокПользователейТаблица = РеквизитФормыВЗначение("СписокПользователей");
	Обработка = РеквизитФормыВЗначение("Объект");
	
	Если ТипПользователя = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		ПользовательВнешний = Истина;
	Иначе 
		ПользовательВнешний = Ложь;
	КонецЕсли;
	
	Если ИспользоватьГруппы Тогда
		Обработка.ЗаполнитьДеревоГрупп(ДеревоГрупп, ПользовательВнешний);
		СписокВсехПользователейТаблица = Обработка.ПользователиДляКопирования(
			ПользовательИсточник, СписокВсехПользователейТаблица, ПользовательВнешний);
	Иначе
		СписокПользователейТаблица = Обработка.ПользователиДляКопирования(
			ПользовательИсточник, СписокПользователейТаблица, ПользовательВнешний);
	КонецЕсли;
	
	ДеревоГрупп.Строки.Сортировать("Группа Возр");
	СтрокаДляПеремещения = ДеревоГрупп.Строки.Найти(ВсеПользователи, "Группа");
	
	Если Не СтрокаДляПеремещения = Неопределено Тогда
		ИндексСтроки = ДеревоГрупп.Строки.Индекс(СтрокаДляПеремещения);
		ДеревоГрупп.Строки.Сдвинуть(ИндексСтроки, -ИндексСтроки);
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ДеревоГрупп, "ГруппыПользователей");
	ЗначениеВРеквизитФормы(СписокПользователейТаблица, "СписокПользователей");
	ЗначениеВРеквизитФормы(СписокВсехПользователейТаблица, "СписокВсехПользователей");
	
КонецПроцедуры




