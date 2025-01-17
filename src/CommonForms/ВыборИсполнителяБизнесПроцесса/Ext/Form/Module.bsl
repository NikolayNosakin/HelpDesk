﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ТолькоПростыеРоли Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			СписокРоли.Отбор, "ИспользуетсяБезОбъектовАдресации", Истина,,Истина);
	КонецЕсли;	
	Если Параметры.БезВнешнихРолей = Истина Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			СписокРоли.Отбор, "ВнешняяРоль", Ложь);
	КонецЕсли;	
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(СписокПользователи, "ПустойУникальныйИдентификатор", 
		Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
	Если ТипЗнч(Параметры.Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда
		
		ТекущийЭлемент = Элементы.СписокПользователи;
		Элементы.СписокПользователи.ТекущаяСтрока = Параметры.Исполнитель;
		
	ИначеЕсли ТипЗнч(Параметры.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.Роли;
		ТекущийЭлемент = Элементы.СписокРоли;
		Элементы.СписокРоли.ТекущаяСтрока = Параметры.Исполнитель;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СписокРоли

&НаКлиенте
Процедура СписокПользователиВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРолиВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборРоли(Значение);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Пользователи Тогда 
		ОповеститьОВыборе(Элементы.СписокПользователи.ТекущаяСтрока);
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Роли Тогда 
		ВыборРоли(Элементы.СписокРоли.ТекущаяСтрока);
		
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Функция ВыборРоли(ВыбранноеЗначение)
	
	Если Не ОбщегоНазначения.ПолучитьЗначениеРеквизита(ВыбранноеЗначение, "ИспользуетсяСОбъектамиАдресации") Тогда 
		Результат = Новый Структура("РольИсполнителя, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации", 
			ВыбранноеЗначение, Неопределено, Неопределено);
	Иначе	
		Результат = ОткрытьФормуМодально("ОбщаяФорма.ВыборРолиИсполнителя", 
			Новый Структура("РольИсполнителя, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации, ВыборОбъектаАдресации", 
				ВыбранноеЗначение, Неопределено, Неопределено, Истина), 
			ЭтотОбъект);
	КонецЕсли;	
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ОповеститьОВыборе(Результат);
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗначениеПараметраКомпоновкиДанных(Знач ВладелецПараметров, Знач ИмяПараметра, Знач ЗначениеПараметра)
	
	Для каждого Параметр Из ВладелецПараметров.Параметры.Элементы Цикл
		Если Строка(Параметр.Параметр) = ИмяПараметра Тогда
			Если Параметр.Использование И Параметр.Значение = ЗначениеПараметра Тогда
				Возврат;
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ВладелецПараметров.Параметры.УстановитьЗначениеПараметра(ИмяПараметра, ЗначениеПараметра);
	
КонецПроцедуры
