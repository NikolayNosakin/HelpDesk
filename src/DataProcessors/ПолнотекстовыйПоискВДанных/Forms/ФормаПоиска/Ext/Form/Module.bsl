﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнициализироватьРеквизиты();
	УстановитьВидимостьДоступностьЭлементов();
	
	Если Параметры.Свойство("СтрокаПоиска", СтрокаПоиска) И Не ПустаяСтрока(СтрокаПоиска) Тогда
		НайтиНаСервере(0);
	КонецЕсли;
	
	Если Объект.РезультатовНаСтранице < 1 Тогда
		Объект.РезультатовНаСтранице = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьРеквизиты()
	
	ЗагрузитьНастройкиПоиска();
	ПоказаныРезультатыСПо = "";
	ТекущаяПозиция = 0;
	КоличествоРезультатов = 0;
	ПолноеКоличество = 0;
	ЭтоФайловаяБаза = ПолучитьЭтоФайловаяБаза();
	ИскатьТолькоВРазделах = ЕстьОтмеченныеРазделыСервер();
	
	СохранениеВводимыхЗначений.ЗагрузитьСписокВыбора(ЭтотОбъект, "СтрокаПоиска");
	HTMLТекст = ПолучитьПустойДокументHTML();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиПоиска()
	
	НастройкиПоУмолчанию = ПолнотекстовыйПоискСерверПереопределяемый.ПолучитьНастройкиПоискаПоУмолчанию();
	НастройкиПоУмолчанию.Свойство("ВыделятьСловаЦветом", Объект.ВыделятьСловаЦветом);
	НастройкиПоУмолчанию.Свойство("ИскатьСочетанияСлов", Объект.ИскатьСочетанияСлов);
	НастройкиПоУмолчанию.Свойство("ИскатьСловаСОшибками",Объект.ИскатьСловаСОшибками);
	НастройкиПоУмолчанию.Свойство("ПорогНечеткости",Объект.ПорогНечеткости);
	НастройкиПоУмолчанию.Свойство("РезультатовНаСтранице", Объект.РезультатовНаСтранице);
	НастройкиПоУмолчанию.Свойство("ОтображатьТекстовоеОписание", Объект.ОтображатьТекстовоеОписание);
	НастройкиПоУмолчанию.Свойство("ОтображатьДополнительнуюИнформацию", Объект.ОтображатьДополнительнуюИнформацию);
	НастройкиПоУмолчанию.Свойство("РазделыПоиска", Объект.РазделыПоиска);
	
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПолнотекстовогоПоиска",);
	Если ТипЗнч(Настройки) = Тип("Структура") Тогда
		Настройки.Свойство("ВыделятьСловаЦветом", Объект.ВыделятьСловаЦветом);
		Настройки.Свойство("ИскатьСочетанияСлов", Объект.ИскатьСочетанияСлов);
		Настройки.Свойство("ИскатьСловаСОшибками",Объект.ИскатьСловаСОшибками);
		Настройки.Свойство("ПорогНечеткости",Объект.ПорогНечеткости);
		Настройки.Свойство("РезультатовНаСтранице", Объект.РезультатовНаСтранице);
		Настройки.Свойство("ОтображатьТекстовоеОписание", Объект.ОтображатьТекстовоеОписание);
		Настройки.Свойство("ОтображатьДополнительнуюИнформацию", Объект.ОтображатьДополнительнуюИнформацию);
		Настройки.Свойство("РасширенныйПоиск", Объект.РасширенныйПоиск);
		
		Если Настройки.Свойство("СтандартныеРазделыПоиска")
			И ТипЗнч(Настройки.СтандартныеРазделыПоиска) = Тип("СписокЗначений") Тогда
			ПомеченныеРазделы = Новый Массив;
			Для каждого Элемент Из Настройки.СтандартныеРазделыПоиска Цикл
				Если Элемент.Пометка Тогда
					ПомеченныеРазделы.Добавить(Элемент.Представление);
				КонецЕсли;
			КонецЦикла;
			Для каждого Элемент Из Объект.РазделыПоиска Цикл
				Элемент.Пометка = (ПомеченныеРазделы.Найти(Элемент.Представление) <> Неопределено);
			КонецЦикла;
		КонецЕсли;
		Если Настройки.Свойство("ДополнительныеРазделыПоиска")
			И ТипЗнч(Настройки.ДополнительныеРазделыПоиска) = Тип("СписокЗначений") Тогда
			Для каждого Элемент Из Настройки.ДополнительныеРазделыПоиска Цикл
				Объект.РазделыПоиска.Добавить(Элемент.Значение, Элемент.Представление, Элемент.Пометка);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНастройкиПоУмолчанию()
	
	НастройкиПоУмолчанию.Свойство("ВыделятьСловаЦветом", Объект.ВыделятьСловаЦветом);
	НастройкиПоУмолчанию.Свойство("ИскатьСочетанияСлов", Объект.ИскатьСочетанияСлов);
	НастройкиПоУмолчанию.Свойство("ИскатьСловаСОшибками",Объект.ИскатьСловаСОшибками);
	НастройкиПоУмолчанию.Свойство("ПорогНечеткости",Объект.ПорогНечеткости);
	НастройкиПоУмолчанию.Свойство("ОтображатьТекстовоеОписание", Объект.ОтображатьТекстовоеОписание);
	НастройкиПоУмолчанию.Свойство("ОтображатьДополнительнуюИнформацию", Объект.ОтображатьДополнительнуюИнформацию);
	Для каждого РазделыПоискаСтрока Из Объект.РазделыПоиска Цикл
		РазделыПоискаСтрока.Пометка = Ложь;
	КонецЦикла;
	ИскатьТолькоВРазделах = Ложь;
	ПриИзмененииНастроек();
	
КонецПроцедуры

&НаКлиенте
Функция ТекущиеНастройкиЕстьНастройкиПоУмолчанию()
	
	Если ТипЗнч(НастройкиПоУмолчанию) <> Тип("Структура") Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Не ЕстьОтмеченныеРазделы()
	И Объект.ВыделятьСловаЦветом = НастройкиПоУмолчанию.ВыделятьСловаЦветом
	И Объект.ИскатьСочетанияСлов = НастройкиПоУмолчанию.ИскатьСочетанияСлов
	И Объект.ИскатьСловаСОшибками = НастройкиПоУмолчанию.ИскатьСловаСОшибками
	И Объект.ПорогНечеткости = НастройкиПоУмолчанию.ПорогНечеткости
	И Объект.ОтображатьТекстовоеОписание = НастройкиПоУмолчанию.ОтображатьТекстовоеОписание
	И Объект.ОтображатьДополнительнуюИнформацию = НастройкиПоУмолчанию.ОтображатьДополнительнуюИнформацию;
	
КонецФункции

&НаСервере
Функция ТекущиеНастройкиЕстьНастройкиПоУмолчаниюСервер()
	
	Если ТипЗнч(НастройкиПоУмолчанию) <> Тип("Структура") Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Не ЕстьОтмеченныеРазделыСервер()
	И Объект.ВыделятьСловаЦветом = НастройкиПоУмолчанию.ВыделятьСловаЦветом
	И Объект.ИскатьСочетанияСлов = НастройкиПоУмолчанию.ИскатьСочетанияСлов
	И Объект.ИскатьСловаСОшибками = НастройкиПоУмолчанию.ИскатьСловаСОшибками
	И Объект.ПорогНечеткости = НастройкиПоУмолчанию.ПорогНечеткости
	И Объект.ОтображатьТекстовоеОписание = НастройкиПоУмолчанию.ОтображатьТекстовоеОписание
	И Объект.ОтображатьДополнительнуюИнформацию = НастройкиПоУмолчанию.ОтображатьДополнительнуюИнформацию;
	
КонецФункции

&НаСервере
Функция ПолучитьЭтоФайловаяБаза()
	
	СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
	Возврат ОбщегоНазначения.ИнформационнаяБазаФайловая(СтрокаСоединения);
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Если Объект.РасширенныйПоиск Тогда
		Элементы.ГруппаРасширенныйПоиск.Видимость = Истина;
		Элементы.РасширенныйПоиск.Заголовок = НСтр("ru = 'Скрыть расширенный поиск'");
	Иначе
		Элементы.ГруппаРасширенныйПоиск.Видимость = Ложь;
		Элементы.РасширенныйПоиск.Заголовок = НСтр("ru = 'Расширенный поиск'");
	КонецЕсли;
	
	Элементы.ДекорацияВнимание.Видимость = Не ТекущиеНастройкиЕстьНастройкиПоУмолчаниюСервер();
	
	Элементы.Далее.Доступность = (ПолноеКоличество > ТекущаяПозиция + КоличествоРезультатов);
	Элементы.Назад.Доступность = (ТекущаяПозиция > 0);
	
	ОбновитьАктуальностьИндекса();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьАктуальностьИндекса()
	
	Если ЭтоФайловаяБаза Тогда
		Элементы.ГруппаОбновлениеИндекса.Видимость = Истина;
		Попытка
			ИндексАктуален = ПолнотекстовыйПоиск.ИндексАктуален();
			Если ИндексАктуален Тогда
				Элементы.ГруппаОбновлениеИндекса.Видимость = Ложь;
				Элементы.ОбновитьИндекс.Доступность = Ложь;
			Иначе
				Элементы.ГруппаОбновлениеИндекса.Видимость = Истина;
				Элементы.ОбновитьИндекс.Доступность = Истина;
				ДатаАктуальностиИндекса = ПолнотекстовыйПоиск.ДатаАктуальности();
				Если ДатаАктуальностиИндекса = '00010101000000' Тогда
					СостояниеИндекса = НСтр("ru = 'Требуется обновление индекса'");
				Иначе
					СостояниеИндекса = НСтр("ru = 'Последнее обновление индекса: '") + Строка(ДатаАктуальностиИндекса);
				КонецЕсли;
			КонецЕсли;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	Иначе
		Элементы.ГруппаОбновлениеИндекса.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПриИзмененииНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;	

	СохранитьНастройкиПоиска(ЭтотОбъект.ИмяФормы);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиПоиска(ИмяФормы)
	
	Настройки = Новый Структура;
	Настройки.Вставить("ВыделятьСловаЦветом", Объект.ВыделятьСловаЦветом);
	Настройки.Вставить("ИскатьСочетанияСлов", Объект.ИскатьСочетанияСлов);
	Настройки.Вставить("ИскатьСловаСОшибками", Объект.ИскатьСловаСОшибками);
	Настройки.Вставить("ПорогНечеткости", Объект.ПорогНечеткости);
	Настройки.Вставить("РезультатовНаСтранице", Объект.РезультатовНаСтранице);
	Настройки.Вставить("ОтображатьТекстовоеОписание", Объект.ОтображатьТекстовоеОписание);
	Настройки.Вставить("ОтображатьДополнительнуюИнформацию", Объект.ОтображатьДополнительнуюИнформацию);
	Настройки.Вставить("РасширенныйПоиск", Объект.РасширенныйПоиск);
	
	ДополнительныеРазделыПоиска = Новый СписокЗначений;
	СтандартныеРазделыПоиска = Новый СписокЗначений;
	Для каждого Элемент Из Объект.РазделыПоиска Цикл
		Если ПолнотекстовыйПоискСерверПереопределяемый.ЭтоСтандартныйРазделПоиска(Элемент.Представление) Тогда
			СтандартныеРазделыПоиска.Добавить(Элемент.Значение, Элемент.Представление, Элемент.Пометка);
		Иначе
			ДополнительныеРазделыПоиска.Добавить(Элемент.Значение, Элемент.Представление, Элемент.Пометка);
		КонецЕсли;
	КонецЦикла;
	Настройки.Вставить("СтандартныеРазделыПоиска", СтандартныеРазделыПоиска);
	Настройки.Вставить("ДополнительныеРазделыПоиска", ДополнительныеРазделыПоиска);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиПолнотекстовогоПоиска",, Настройки);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПустойДокументHTML(ВыводитьСправку = Ложь, Сообщение = "")
	
	Если Не ВыводитьСправку Тогда
		Возврат ПолучитьПустойHTMLТекст();
	КонецЕсли;
	
	Текст = Обработки.ПолнотекстовыйПоискВДанных.ПолучитьМакет("НичегоНеНайдено").ПолучитьТекст();
	Результат = СтрЗаменить(Текст, "%Сообщение%", Сообщение);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьДокументHTMLНичегоНеНайдено()
	
	Возврат Обработки.ПолнотекстовыйПоискВДанных.ПолучитьМакет("НичегоНеНайдено").ПолучитьТекст();
	
КонецФункции

&НаСервере
Функция ПолучитьПустойHTMLТекст()
	
	Результат =
		"<html>
		|<head>
		|<meta http-equiv=""Content-Style-Type"" content=""text/css"">
		//|<meta http-equiv=""X-UA-Compatible"" content=""IE=EmulateIE7"" />
		|<meta name=""format-detection"" content=""telephone=no"" />
		|</head>
		|<body topmargin=0 leftmargin=0 scroll=auto>
		|<table border=""0"" width=""100%"" cellspacing=""0"">
		|</table>
		|</body>
		|</html>";
		
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ДалееВыполнить(Команда)
	
	НайтиНаКлиенте(1);
	
КонецПроцедуры

&НаКлиенте
Процедура НазадВыполнить(Команда)
	
	НайтиНаКлиенте(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИндекс(Команда)
	
	Состояние(НСтр("ru = 'Идет обновление полнотекстового индекса...
		|Пожалуйста, подождите.'"));
	
	ОбновитьИндексНаСервере();
	
	Состояние(НСтр("ru = 'Обновление полнотекстового индекса завершено.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиКоманда(Команда)
	
	НайтиНаКлиенте(0);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗначениеПоиска(Значение)
	
	Попытка
		СтандартнаяОбработка = Истина;
		Если СтандартнаяОбработка = Истина Тогда
			ОткрытьЗначение(Значение);
		КонецЕсли;
	Исключение
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При попытке открытия значения произошла ошибка:
				|%1'"),
			ОписаниеОшибки());
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗначенияДляОткрытия(Объект)
	
	Результат = Новый Массив;
	
	// Объект ссылочного типа
	Если ОбщегоНазначения.ЗначениеСсылочногоТипа(Объект) Тогда
		Результат.Добавить(Объект);
		Возврат Результат;
	КонецЕсли;
	
	МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(Объект));
	ИмяМетаданного = МетаданныеОбъекта.Имя;
	
	ПолноеИмяОбъекта = ВРег(Метаданные.НайтиПоТипу(ТипЗнч(Объект)).ПолноеИмя());
	ЭтоРегистрСведений = (Найти(ПолноеИмяОбъекта, "РЕГИСТРСВЕДЕНИЙ.") > 0);
	
	Если Не ЭтоРегистрСведений Тогда // Регистр бухгалтерии или накопления или расчета
		Регистратор = Объект["Регистратор"];
		Результат.Добавить(Регистратор);
		Возврат Результат;
	КонецЕсли;
	
	// Ниже - это уже регистр сведений
	Если МетаданныеОбъекта.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору Тогда
		Регистратор = Объект["Регистратор"];
		Результат.Добавить(Регистратор);
		Возврат Результат;
	КонецЕсли;
	
	// Независимый регистр сведений
	// Сперва - основные типы
	Для Каждого Измерение Из МетаданныеОбъекта.Измерения Цикл
		Если Измерение.Ведущее Тогда 
			ЗначениеИзмерения = Объект[Измерение.Имя];
			Если ОбщегоНазначения.ЗначениеСсылочногоТипа(ЗначениеИзмерения) Тогда
				Результат.Добавить(ЗначениеИзмерения);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Результат.Количество() = 0 Тогда
		// Теперь - любые типы
		Для Каждого Измерение Из МетаданныеОбъекта.Измерения Цикл
			Если Измерение.Ведущее Тогда 
				ЗначениеИзмерения = Объект[Измерение.Имя];
				Результат.Добавить(ЗначениеИзмерения);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Нет ни одного ведущего измерения - вернем сам ключ регистра сведений
	Если Результат.Количество() = 0 Тогда
		Результат.Добавить(Объект);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОбновитьИндексНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	ПолнотекстовыйПоиск.ОбновитьИндекс(Ложь, Ложь);
	ИндексАктуален = ПолнотекстовыйПоиск.ИндексАктуален();
	Элементы.ГруппаОбновлениеИндекса.Видимость = Не ИндексАктуален;
	Элементы.ОбновитьИндекс.Доступность = Не ИндексАктуален;
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиНаКлиенте(Направление)
		
	Попытка
		
		Если ПустаяСтрока(СтрокаПоиска) Тогда
			Возврат;
		КонецЕсли;
		
		Если ЭтоНавигационнаяСсылка(СтрокаПоиска) Тогда
			ПерейтиПоНавигационнойСсылке(СтрокаПоиска);
			СтрокаПоиска = "";
			Возврат;
		КонецЕсли;
		
		Если Направление = 0 Тогда
			
			Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Выполняется поиск ""%1""...'"),
				СтрокаПоиска));
			
		КонецЕсли;
		
		СохранениеВводимыхЗначенийКлиент.ОбновитьСписокВыбора(ЭтотОбъект, "СтрокаПоиска");
		
		НайтиНаСервере(Направление);
		Если Направление = 0 И СлишкомМногоРезультатов Тогда
			Предупреждение(НСтр("ru = 'Найдено слишком много результатов, уточните запрос.'"));
		КонецЕсли;
		
	Исключение
		ПоказатьПредупреждение(Неопределено,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки
	
КонецПроцедуры

&НаСервере
Процедура НайтиНаСервере(Направление)
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		HTMLТекст = ПолучитьПустойДокументHTML();
		УстановитьВидимостьДоступностьЭлементов();
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрокаПоиска = ПолучитьСтрокуПоиска();
	СписокПоиска = ПолнотекстовыйПоиск.СоздатьСписок(ТекущаяСтрокаПоиска, Объект.РезультатовНаСтранице);
	СписокПоиска.ОбластьПоиска = ПолучитьОбластьПоиска();
	СписокПоиска.ПорогНечеткости = ?(Объект.ИскатьСловаСОшибками, Объект.ПорогНечеткости, 0);
	СписокПоиска.ПолучатьОписание = Объект.ОтображатьТекстовоеОписание;
	
	ВремяНачалаПоиска = ТекущаяДата();
	
	Если Направление = 0 Тогда
		СписокПоиска.ПерваяЧасть();
	ИначеЕсли Направление = -1 Тогда
		СписокПоиска.ПредыдущаяЧасть(ТекущаяПозиция);
	ИначеЕсли Направление = 1 Тогда
		СписокПоиска.СледующаяЧасть(ТекущаяПозиция);
	КонецЕсли;
	
	СлишкомМногоРезультатов = СписокПоиска.СлишкомМногоРезультатов();
	КоличествоРезультатов = СписокПоиска.Количество();
	ТекущаяПозиция = СписокПоиска.НачальнаяПозиция();
	ПолноеКоличество = СписокПоиска.ПолноеКоличество();
	
	Длительность = ТекущаяДата() - ВремяНачалаПоиска;
	ОписаниеСобытия = НСтр("ru='Строка поиска: '") + ТекущаяСтрокаПоиска;
	ДополнительныеСведения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Полное число результатов:%1  Размер порции:%2  Номер страницы:%3  Слишком много результатов:%4'"),
		ПолноеКоличество,
		Объект.РезультатовНаСтранице,
		ТекущаяПозиция / Объект.РезультатовНаСтранице + 1,
		Строка(СлишкомМногоРезультатов));
	
	Если ПолноеКоличество = 0 Тогда
		HTMLТекст = ПолучитьДокументHTMLНичегоНеНайдено();
	Иначе
		HTMLТекст = ПолучитьHTMLТекст(СписокПоиска);
	КонецЕсли;
	
	РезультатыПоиска = Новый СписокЗначений;
	РезультатыПоиска.Очистить();
	Для каждого Результат Из СписокПоиска Цикл
		СтруктураРезультата = Новый Структура;
		СтруктураРезультата.Вставить("Значение", Результат.Значение);
		СтруктураРезультата.Вставить("ЗначенияДляОткрытия", ПолучитьЗначенияДляОткрытия(Результат.Значение));
		РезультатыПоиска.Добавить(СтруктураРезультата);
	КонецЦикла;
	
	Если КоличествоРезультатов <> 0 Тогда
		ПоказаныРезультатыСПо = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Показаны %1 - %2 из %3'"),
			Строка(ТекущаяПозиция + 1),
			Строка(ТекущаяПозиция + КоличествоРезультатов),
			Строка(ПолноеКоличество));
		
	Иначе
		ПоказаныРезультатыСПо = НСтр("ru = 'Ничего не найдено'");
	КонецЕсли;
		
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

// Возвращает строку поиска с учетом опции "Искать сочетания слов"
//
&НаСервере
Функция ПолучитьСтрокуПоиска()
	
	СтрокаПоиска = СокрЛП(СтрокаПоиска);
	
	Если ПолнотекстовыйПоискКлиентСервер.СтрокаПоискаСодержитСпецСимволы(СтрокаПоиска) Или Объект.ИскатьСловаСОшибками Тогда
		Результат = СтрокаПоиска;
	ИначеЕсли (Найти(СтрокаПоиска," ") = 0) И (Прав(СтрокаПоиска, 1) <> "*") Тогда // Всего 1 слово
		Результат = СтрокаПоиска + "*";
	ИначеЕсли Объект.ИскатьСочетанияСлов = 1 Тогда // Все слова в заданной последовательности
		Результат = """" + СтрокаПоиска + """";
	ИначеЕсли Объект.ИскатьСочетанияСлов = 2 Тогда // Любое из указанных слов
		Разделители = Новый Массив;
		Разделители.Добавить(" ");
		Разделители.Добавить(Символы.Таб);
		Разделители.Добавить(Символы.ВТаб);
		Разделители.Добавить(Символы.НПП);
		Результат = ЗаменитьРазделители(СтрокаПоиска, Разделители, " OR ");
	Иначе
		Результат = СтрокаПоиска;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьHTMLТекст(СписокПоиска)
	
	ТекущаяПозиция = СписокПоиска.НачальнаяПозиция();
	
	XML = СписокПоиска.ПолучитьОтображение(ВидОтображенияПолнотекстовогоПоиска.XML);
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	Пока XML.Прочитать() Цикл
		ЗаписьXML.ЗаписатьТекущий(XML);
	КонецЦикла;
	XMLСтрока = ЗаписьXML.Закрыть();
	
	Преобразование = Новый ПреобразованиеXSL;
	CurPosition = Формат(1 + ТекущаяПозиция, "ЧН=; ЧГ=0");
	spanClass = ?(Объект.ВыделятьСловаЦветом, "color", "bold");
	
	ШаблонПреобразования = 
	
	"<?xml version=""1.0""?>
	|<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform"">
	|<xsl:output method = ""html""/>
	
	|<xsl:template match=""/"">
	|<html>
	|<head>
	|<style type=""text/css"">
	|	body {margin: 1;}
	|	tr {font-family: Arial,sans-serif; font-size: 14px; vertical-align: top}
	|	td.index {width: 30px;}
	|	div.presentation {font-size: 14px;}
	|	div.textPortion {font-size: 13px;}
	|	div.description {font-size: 13px; color: #A0A000;}
	|	span.bold {font-weight: bold;}
	|	span.color {background-color: #FFFFA0;}
	|	a {text-decoration:none;}
	|</style>	
	|</head>
	|<body>
	|<table border=""0"" width=""100%"" cellspacing=""0"">
	|<xsl:apply-templates select=""//item""/>
	|</table>
	|</body>
	|</html>		
	|</xsl:template>
	
	|<xsl:template match=""item"">
	|<xsl:variable name=""url"" select=""normalize-space(concat('./',index))""/>
	|<tr>
	|<td class='index'>
	|<xsl:value-of select=""index+" + CurPosition + """/>.
	|</td>
	|<td>
	|<div class='presentation'>
	|<a id=""FullTextSearchListItem"" href=""{$url}""><xsl:value-of select=""metadata""/>: <xsl:value-of select=""presentation""/></a>
	|</div>
	|<xsl:apply-templates select=""textPortion""/>
	|"
	+ ?(Объект.ОтображатьДополнительнуюИнформацию, "
	|<div class='description'>
	|%<xsl:value-of select=""index""/>%
	|</div>"
	,
	""
	) + "
	|</td>
	|</tr>
	|</xsl:template>
	
	|<xsl:template match=""textPortion"">
	|<div class='textPortion'>
	|<xsl:apply-templates/>
	|</div>
	|</xsl:template>
	
	|<xsl:template match=""foundWord"">
	|<span class = """ + spanClass + """><xsl:value-of select="".""/></span>
	|</xsl:template>
	
	|</xsl:stylesheet>";
	
	Преобразование.ЗагрузитьИзСтроки(ШаблонПреобразования);
	HTMLРезультат = Преобразование.ПреобразоватьИзСтроки(XMLСтрока);
	
	Если Объект.ОтображатьДополнительнуюИнформацию Тогда
		Для К = 0 По КоличествоРезультатов - 1 Цикл
			СтрокаЗамены = "%" + Формат(К, "ЧН=; ЧГ=0") + "%";
			ПапкиКатегорииСтр = ПолнотекстовыйПоискСерверПереопределяемый.ПолучитьДополнительнуюИнформациюПоОбъекту(СписокПоиска[К].Значение);
			Если Найти(HTMLРезультат, СтрокаЗамены) = 0 Тогда
				Сообщить(HTMLРезультат);
				Сообщить(СтрокаЗамены);
			КонецЕсли;
			HTMLРезультат = СтрЗаменить(HTMLРезультат, СтрокаЗамены, ПапкиКатегорииСтр);
		КонецЦикла;
	КонецЕсли;
	
	Возврат HTMLРезультат;
	
КонецФункции

&НаСервере
Функция ЗаменитьРазделители(Строка, Разделители, НовыйРазделитель)
	
	Результат = Строка;
	
	СтрокаЗамены = "%~%";
	ДлинаСтрокиЗамены = СтрДлина(СтрокаЗамены);
	Для каждого Разделитель Из Разделители Цикл
		Результат = СтрЗаменить(Результат, Разделитель, СтрокаЗамены);
	КонецЦИкла;
	Пока Найти(Результат, СтрокаЗамены + СтрокаЗамены) > 0 Цикл
		Результат = СтрЗаменить(Результат, СтрокаЗамены + СтрокаЗамены, СтрокаЗамены);
	КонецЦикла;
	Если Прав(Результат, ДлинаСтрокиЗамены) = СтрокаЗамены Тогда
		Результат = Сред(Результат, 1, СтрДлина(Результат) - ДлинаСтрокиЗамены);
	КонецЕсли;
	Если Лев(Результат, ДлинаСтрокиЗамены) = СтрокаЗамены Тогда
		Результат = Сред(Результат, 1 + ДлинаСтрокиЗамены);
	КонецЕсли;
	Результат = СтрЗаменить(Результат, СтрокаЗамены, НовыйРазделитель);
	
	Возврат Результат;
	
КонецФункции

// Возвращает массив метаданных, соответтсвующий выбранным разделам поиска
//
&НаСервере
Функция ПолучитьОбластьПоиска()
	
	Результат = Новый Массив;
	
	Если Объект.РазделыПоиска.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для каждого СтрокаРазделыПоиска Из Объект.РазделыПоиска Цикл
		Если СтрокаРазделыПоиска.Пометка Тогда
			Для каждого Раздел Из СтрокаРазделыПоиска.Значение Цикл
				Мета = Вычислить(Раздел);
				Если Результат.Найти(Мета) = Неопределено Тогда
					Результат.Добавить(Мета);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ЕстьОтмеченныеРазделыСервер()
	
	Для каждого СтрокаРазделыПоиска Из Объект.РазделыПоиска Цикл
		Если СтрокаРазделыПоиска.Пометка Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Функция ЕстьОтмеченныеРазделы()
	
	Для каждого СтрокаРазделыПоиска Из Объект.РазделыПоиска Цикл
		Если СтрокаРазделыПоиска.Пометка Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	ПриИзмененииНастроек();
	НайтиНаКлиенте(0);
	ТекущийЭлемент = Элементы.СтрокаПоиска;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтрокаПоиска = ВыбранноеЗначение;
	ПриИзмененииНастроек();
	НайтиНаКлиенте(0);
	
КонецПроцедуры

&НаКлиенте
Процедура HTMLТекстПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ЭлементHTML = ДанныеСобытия.Anchor;
	
	Если ЭлементHTML = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭлементHTML.id = "FullTextSearchListItem" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ЧастьURL = ЭлементHTML.pathName;
		Позиция = СтроковыеФункцииКлиентСервер.НайтиСимволСКонца(ЧастьURL, "/");
		Если Позиция <> 0 Тогда
			ЧастьURL = Сред(ЧастьURL, Позиция + 1);
		КонецЕсли;
		
		НомерВСписке = Число(ЧастьURL);
		СтруктураРезультата = РезультатыПоиска[НомерВСписке].Значение;
		ВыбраннаяСтрока = СтруктураРезультата.Значение;
		МассивОбъектов = СтруктураРезультата.ЗначенияДляОткрытия;
		
		Если МассивОбъектов.Количество() = 1 Тогда
			ОткрытьЗначениеПоиска(МассивОбъектов[0]);
		ИначеЕсли МассивОбъектов.Количество() > 0 Тогда
			Список = Новый СписокЗначений;
			Для Каждого ЭлементМассива Из МассивОбъектов Цикл
				Список.Добавить(ЭлементМассива);
			КонецЦикла;
			ВыбранныйОбъект = Неопределено;

			ПоказатьВыборИзСписка(Новый ОписаниеОповещения("HTMLТекстПриНажатииЗавершение", ЭтотОбъект), Список, Элементы.HTMLТекст);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура HTMLТекстПриНажатииЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	ВыбранныйОбъект = ВыбранныйЭлемент;
	Если ВыбранныйОбъект <> Неопределено Тогда
		ОткрытьЗначениеПоиска(ВыбранныйОбъект.Значение);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ЭтоНавигационнаяСсылка(Ссылка)
	
	Возврат (Найти(Ссылка, "e1cib/data/") > 0);
	
КонецФункции

&НаКлиенте
Процедура РасширенныйПоиск(Команда)
	
	Объект.РасширенныйПоиск = Не Объект.РасширенныйПоиск;
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиHTML(Команда)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.ДобавитьСтроку(HTMLТекст);
	ТекстовыйДокумент.Показать();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРазделыПоиска(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РазделыПоиска", Объект.РазделыПоиска);
	Результат = Неопределено;

	ОткрытьФорму("Обработка.ПолнотекстовыйПоискВДанных.Форма.НастройкаСпискаРазделов", ПараметрыОткрытия,,,,, Новый ОписаниеОповещения("НастроитьРазделыПоискаЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРазделыПоискаЗавершение(Результат1, ДополнительныеПараметры) Экспорт
	
	Результат = Результат1;
	Если ТипЗнч(Результат) = Тип("СписокЗначений") Тогда
		Объект.РазделыПоиска = Результат;
	КонецЕсли;
	ИскатьТолькоВРазделах = ЕстьОтмеченныеРазделы();

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИсторию(Команда)
	
	СохранениеВводимыхЗначенийКлиент.ОчиститьСписокВыбора(ЭтотОбъект, "СтрокаПоиска");
	
КонецПроцедуры

&НаКлиенте
Процедура ИскатьТолькоВРазделахПриИзменении(Элемент)
	
	Для каждого СтрокаРазделыПоиска Из Объект.РазделыПоиска Цикл
		СтрокаРазделыПоиска.Пометка = ИскатьТолькоВРазделах;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПоискаРазделыПоискаПометкаПриИзменении(Элемент)
	
	ИскатьТолькоВРазделах = ЕстьОтмеченныеРазделы();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВниманиеНажатие(Элемент)
	
	ТекстВопроса = НСтр("ru = 'Изменены настройки поиска. Вернуть настройки по умолчанию?'");
	ПоказатьВопрос(Новый ОписаниеОповещения("ДекорацияВниманиеНажатиеЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВниманиеНажатиеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	УстановитьНастройкиПоУмолчанию();

КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииНастроек(Элемент = Неопределено)
	
	Элементы.ВыделятьСловаЦветом.Доступность = Объект.ОтображатьТекстовоеОписание;
	Элементы.ИскатьСочетанияСлов.Доступность = Не ПолнотекстовыйПоискКлиентСервер.СтрокаПоискаСодержитСпецСимволы(СтрокаПоиска);
	Если Элементы.ДекорацияВнимание.Видимость = ТекущиеНастройкиЕстьНастройкиПоУмолчанию() Тогда
		УстановитьВидимостьДоступностьЭлементов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазделыПоискаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ПриИзмененииНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатовНаСтраницеПриИзменении(Элемент)
	
	Если Объект.РезультатовНаСтранице < 1 Тогда
		Объект.РезультатовНаСтранице = 1;
	КонецЕсли;
	
КонецПроцедуры
