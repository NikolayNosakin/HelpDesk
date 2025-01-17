﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокПользователей = "";
	СписокПодсистем = "";
	
	Для каждого Подсистема из Метаданные.Подсистемы Цикл
		
		Если Не Подсистема.ВключатьВКомандныйИнтерфейс тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаПодсистемы = ДеревоПодсистем.ПолучитьЭлементы().Добавить();
		
		СтрокаПодсистемы.ПутьКПодсистеме = Подсистема.Имя;
		СтрокаПодсистемы.Название        = Подсистема.Синоним;
		
		МассивСтрок                      = Объект.Подсистемы.НайтиСтроки(Новый Структура("Подсистема", Подсистема.Имя));
		СтрокаПодсистемы.Использование = МассивСтрок.Количество() > 0;
		Если СтрокаПодсистемы.Использование тогда
			СписокПодсистем = СписокПодсистем + Подсистема.Синоним + ", ";
			СтрокаПодсистемы.Предопределенная = МассивСтрок[0].Предопределенная;
		КонецЕсли;
		
		ДобавитьДеревоПодсистем(Подсистема, СтрокаПодсистемы, СписокПодсистем);
		
	КонецЦикла;
	
	ВиртуальныеПодсистемы = ВариантыОтчетов.ПолучитьВиртуальныеПодсистемы("");
	
	Для каждого Подсистема из ВиртуальныеПодсистемы Цикл
		
		СтрокаПодсистемы = ДеревоПодсистем.Строки.Добавить();
		
		СтрокаПодсистемы.ПутьКПодсистеме = Подсистема.Значение;
		СтрокаПодсистемы.Название        = Подсистема.Представлени;
		
		МассивСтрок                      = Объект.Подсистемы.НайтиСтроки(Новый Структура("Подсистема", Подсистема.Значение));
		СтрокаПодсистемы.Использование = МассивСтрок.Количество() > 0;
		Если СтрокаПодсистемы.Использование тогда
			СписокПодсистем = СписокПодсистем + Подсистема.Синоним + ", ";
			СтрокаПодсистемы.Предопределенная = МассивСтрок[0].Предопределенная;
		КонецЕсли;
		
		ДобавитьДеревоВиртуальныхПодсистем(Подсистема.Значение, СтрокаПодсистемы, СписокПодсистем);
		
	КонецЦикла;
	
	БыстрыйДоступ = ПредставлениеНастроекБыстрогоДоступа(ЭтотОбъект);
	Разделы       = ПредставлениеРазделов(ЭтотОбъект);
	
	Если Объект.ТипВариантаОтчета = Перечисления.ТипыВариантовОтчетов.Отчет
		ИЛИ Объект.ТипВариантаОтчета = Перечисления.ТипыВариантовОтчетов.Предопределенный Тогда
		
		Элементы.Администратор.АвтоОтметкаНезаполненного = Ложь;
		Элементы.Администратор.ТолькоПросмотр = Истина;
		Элементы.Описание.ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура БыстрыйДоступНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ИсключенияБыстрогоДоступа = Новый СписокЗначений;
	Для каждого СтрокаПользователь из Объект.ИсключенияБыстрогоДоступа Цикл
		ИсключенияБыстрогоДоступа.Добавить(СтрокаПользователь.Пользователь);
	КонецЦикла;
	ПараметрыФормы = Новый Структура("БыстрыйДоступ, ИсключенияБыстрогоДоступа", Объект.БыстрыйДоступ, ИсключенияБыстрогоДоступа);
	
	Структура = Неопределено;

	
	ОткрытьФорму("Справочник.ВариантыОтчетов.Форма.НастройкаБыстрогоДоступа", ПараметрыФормы, ЭтотОбъект,,,, Новый ОписаниеОповещения("БыстрыйДоступНажатиеЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйДоступНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Структура = Результат;
	Если Структура = Неопределено тогда
		Возврат;
	КонецЕсли;
	
	Объект.БыстрыйДоступ = Структура.БыстрыйДоступ;
	
	Объект.ИсключенияБыстрогоДоступа.Очистить();
	Для Каждого ЭлементСписка Из Структура.ИсключенияБыстрогоДоступа Цикл
		Объект.ИсключенияБыстрогоДоступа.Добавить().Пользователь = ЭлементСписка.Значение;
	КонецЦикла;
	
	БыстрыйДоступ = ПредставлениеНастроекБыстрогоДоступа(ЭтотОбъект);
	Модифицированность = Истина;

КонецПроцедуры

&НаКлиенте
Процедура РазделыНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура("АдресДереваПодсистем, Подсистемы, НовыйЭлементСправочника");
	ПараметрыФормы.Подсистемы              = Объект.Подсистемы;
	ПараметрыФормы.НовыйЭлементСправочника = Объект.Ссылка.Пустая();
	
	ПодготовитьПараметрыНастройкиПодсистем(ПараметрыФормы);
	
	ВозвращаемыеПараметры = Неопределено;

	
	ОткрытьФорму("Справочник.ВариантыОтчетов.Форма.НастройкаПодсистем", ПараметрыФормы, ЭтотОбъект,,,, Новый ОписаниеОповещения("РазделыНажатиеЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

&НаКлиенте
Процедура РазделыНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВозвращаемыеПараметры = Результат;
	
	Если ВозвращаемыеПараметры <> Неопределено тогда
		Объект.Подсистемы.Очистить();
		Для каждого ОписаниеПодсистема из ВозвращаемыеПараметры.СписокПодсистем Цикл
			СтрокаПодсистемы = Объект.Подсистемы.Добавить();
			СтрокаПодсистемы.Подсистема       = ОписаниеПодсистема.Подсистема;
			СтрокаПодсистемы.Название         = ОписаниеПодсистема.Название;
			СтрокаПодсистемы.Предопределенная = ОписаниеПодсистема.Предопределенная;
		КонецЦикла;
		
		ЗафиксироватьРезультатНастройкиПодсистем(ВозвращаемыеПараметры);
		
		Разделы = ПредставлениеРазделов(ЭтотОбъект);
		
		Модифицированность = Истина;
		
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеНастроекБыстрогоДоступа(ЭтотОбъект)
	ВариантБыстрыйДоступ = ЭтотОбъект.Объект.БыстрыйДоступ;
	ВариантИсключенияБыстрогоДоступа = ЭтотОбъект.Объект.ИсключенияБыстрогоДоступа;
	
	Результат = "";
	Для Каждого СтрокаТаблицы Из ВариантИсключенияБыстрогоДоступа Цикл
		ПредставлениеСтроки = СокрЛП(Строка(СтрокаТаблицы.Пользователь));
		Если ПредставлениеСтроки <> "" Тогда
			Если Результат = "" Тогда
				Результат = ?(ВариантБыстрыйДоступ, НСтр("ru = 'Все кроме:'") +" ", "");
				Результат = Результат + ПредставлениеСтроки;
			Иначе
				Результат = Результат +", "+ ПредставлениеСтроки;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Результат = "" Тогда
		Результат = ?(ВариантБыстрыйДоступ, НСтр("ru = 'Все'"), НСтр("ru = 'Пользователи не выбраны'"));
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеРазделов(ЭтотОбъект)
	ВариантПодсистемы = ЭтотОбъект.Объект.Подсистемы;
	
	Результат = "";
	Для Каждого СтрокаТаблицы Из ВариантПодсистемы Цикл
		ПредставлениеСтроки = СокрЛП(СтрокаТаблицы.Название);
		Если ПредставлениеСтроки <> "" Тогда
			Результат = Результат + ПредставлениеСтроки + ", ";
		КонецЕсли;
	КонецЦикла;
	
	Если Результат = "" Тогда
		Результат = НСтр("ru = 'Разделы не выбраны'");
	Иначе
		Результат = Лев(Результат, СтрДлина(Результат)-2);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаСервере
Процедура ДобавитьДеревоПодсистем(Подсистема, СтрокаПодсистемы, СписокПодсистем)
	
	Для каждого ПодсистемаПодчиненная из Подсистема.Подсистемы Цикл
		
		Если Не ПодсистемаПодчиненная.ВключатьВКомандныйИнтерфейс тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаПодсистемыПодчиненой               = СтрокаПодсистемы.ПолучитьЭлементы().Добавить();
		СтрокаПодсистемыПодчиненой.Название      = ПодсистемаПодчиненная.Синоним;
		МассивСтрок                              = Объект.Подсистемы.НайтиСтроки(
			Новый Структура("Подсистема", СтрокаПодсистемы.ПутьКПодсистеме + "\" + ПодсистемаПодчиненная.Имя));
		СтрокаПодсистемыПодчиненой.Использование = МассивСтрок.Количество() > 0;
		Если СтрокаПодсистемыПодчиненой.Использование тогда
			СписокПодсистем = СписокПодсистем + ПодсистемаПодчиненная.Синоним + ", ";
			СтрокаПодсистемыПодчиненой.Предопределенная = МассивСтрок[0].Предопределенная;
		КонецЕсли;
		СтрокаПодсистемыПодчиненой.ПутьКПодсистеме = СтрокаПодсистемы.ПутьКПодсистеме + "\" + ПодсистемаПодчиненная.Имя;
		ДобавитьДеревоПодсистем(ПодсистемаПодчиненная, СтрокаПодсистемыПодчиненой, СписокПодсистем);
		
	КонецЦикла;
	
	ВиртуальныеПодсистемы = ВариантыОтчетов.ПолучитьВиртуальныеПодсистемы(СтрокаПодсистемы.ПутьКПодсистеме);
	
	Для каждого ПодсистемаПодчиненная из ВиртуальныеПодсистемы Цикл
		
		СтрокаПодсистемыПодчиненой               = СтрокаПодсистемы.ПолучитьЭлементы().Добавить();
		СтрокаПодсистемыПодчиненой.Название      = ПодсистемаПодчиненная.Представление;
		МассивСтрок                              = Объект.Подсистемы.НайтиСтроки(
			Новый Структура("Подсистема", ПодсистемаПодчиненная.Значение));
		СтрокаПодсистемыПодчиненой.Использование = МассивСтрок.Количество() > 0;
		Если СтрокаПодсистемыПодчиненой.Использование тогда
			СписокПодсистем = СписокПодсистем + ПодсистемаПодчиненная.Представление + ", ";
			СтрокаПодсистемыПодчиненой.Предопределенная = МассивСтрок[0].Предопределенная;
		КонецЕсли;
		СтрокаПодсистемыПодчиненой.ПутьКПодсистеме = ПодсистемаПодчиненная.Значение;
		ДобавитьДеревоВиртуальныхПодсистем(ПодсистемаПодчиненная.Значение, СтрокаПодсистемыПодчиненой, СписокПодсистем);
		
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ДобавитьДеревоВиртуальныхПодсистем(Подсистема, СтрокаПодсистемы, СписокПодсистем)
	
	ВиртуальныеПодсистемы = ВариантыОтчетов.ПолучитьВиртуальныеПодсистемы(Подсистема);
	
	Для каждого ПодсистемаПодчиненная из ВиртуальныеПодсистемы Цикл
		
		СтрокаПодсистемыПодчиненой               = СтрокаПодсистемы.ПолучитьЭлементы().Добавить();
		СтрокаПодсистемыПодчиненой.Название      = ПодсистемаПодчиненная.Представление;
		МассивСтрок                              = Объект.Подсистемы.НайтиСтроки(
			Новый Структура("Подсистема", ПодсистемаПодчиненная.Значение));
		СтрокаПодсистемыПодчиненой.Использование = МассивСтрок.Количество() > 0;
		Если СтрокаПодсистемыПодчиненой.Использование тогда
			СписокПодсистем = СписокПодсистем + ПодсистемаПодчиненная.Представление + ", ";
			СтрокаПодсистемыПодчиненой.Предопределенная = МассивСтрок[0].Предопределенная;
		КонецЕсли;
		СтрокаПодсистемыПодчиненой.ПутьКПодсистеме = ПодсистемаПодчиненная.Значение;
		ДобавитьДеревоВиртуальныхПодсистем(ПодсистемаПодчиненная.Значение, СтрокаПодсистемыПодчиненой, СписокПодсистем);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьПараметрыНастройкиПодсистем(ПараметрыФормы)
	
	ДеревоЗначений = ДанныеФормыВЗначение(ДеревоПодсистем, Тип("ДеревоЗначений"));
	ПараметрыФормы.АдресДереваПодсистем = ПоместитьВоВременноеХранилище(ДеревоЗначений, ЭтотОбъект.УникальныйИдентификатор);
	
КонецПроцедуры 

&НаСервере
Процедура ЗафиксироватьРезультатНастройкиПодсистем(ВозвращаемыеПараметры)
	
	ДеревоЗначений = ПолучитьИзВременногоХранилища(ВозвращаемыеПараметры.АдресДереваПодсистем);
	ЗначениеВРеквизитФормы(ДеревоЗначений, "ДеревоПодсистем");
	УдалитьИзВременногоХранилища(ВозвращаемыеПараметры.АдресДереваПодсистем);
	
КонецПроцедуры 

