
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропуск инициализации, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("_Владелец", Свойство)
	   И ЗначениеЗаполнено(Свойство) Тогда
		
		Параметры.Отбор.Удалить("_Владелец");
		Параметры.Отбор.Вставить("Владелец", Свойство);
		
	ИначеЕсли Параметры.Отбор.Свойство("Владелец")
	        И ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
		
		Свойство = Параметры.Отбор.Владелец;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Свойство) Тогда
		Элементы.Свойство.Видимость = Истина;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Иначе
		Элементы.Список.РежимВыбора = Ложь;
	КонецЕсли;
	
	УстановитьЗаголовок();
	
	ПриИзмененииСвойства();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ДополнительныеРеквизитыИСведения"
	   И Источник = Свойство Тогда
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияПриИзмененииСвойства", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СвойствоПриИзменении(Элемент)
	
	ПриИзмененииСвойства();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если НЕ Копирование
	   И Элементы.Список.Отображение = ОтображениеТаблицы.Список Тогда
		
		Родитель = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьЗаголовок()
	
	СтрокаЗаголовка = "";
	
	Если ЗначениеЗаполнено(Свойство) Тогда
		СтрокаЗаголовка = СтрПолучитьСтроку(ОбщегоНазначения.ПолучитьЗначениеРеквизита(
			Свойство, "СклоненияПредмета"), 2);
	КонецЕсли;
	
	Если ПустаяСтрока(СтрокаЗаголовка) Тогда
		
		Если ЗначениеЗаполнено(Свойство) Тогда
			Если НЕ Параметры.РежимВыбора Тогда
				СтрокаЗаголовка = НСтр("ru = 'Значения свойства %1'");
			Иначе
				СтрокаЗаголовка = НСтр("ru = 'Выберите значение свойства %1'");
			КонецЕсли;
			
			СтрокаЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				СтрокаЗаголовка, Строка(Свойство));
		
		ИначеЕсли Параметры.РежимВыбора Тогда
			СтрокаЗаголовка = НСтр("ru = 'Выберите значение свойства'");
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(СтрокаЗаголовка) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = СтрокаЗаголовка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияПриИзмененииСвойства()
	
	ПриИзмененииСвойства();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииСвойства()
	
	Если ЗначениеЗаполнено(Свойство) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			Список.Отбор, "Владелец", Свойство);
		
		ТипЗначения = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Свойство, "ТипЗначения");
		
		Если ТипЗнч(ТипЗначения) = Тип("ОписаниеТипов")
		   И ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия")) Тогда
			
			Элементы.Список.ИзменятьСоставСтрок = Истина;
		Иначе
			Элементы.Список.ИзменятьСоставСтрок = Ложь;
		КонецЕсли;
		
		Элементы.Список.Отображение = ОтображениеТаблицы.ИерархическийСписок;
		Элементы.Владелец.Видимость = Ложь;
		Элементы.Список.Шапка = Ложь;
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
			Список.Отбор, "Владелец");
		
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		Элементы.Список.ИзменятьСоставСтрок = Ложь;
		Элементы.Владелец.Видимость = Истина;
		Элементы.Список.Шапка = Истина;
	КонецЕсли;
	
КонецПроцедуры
