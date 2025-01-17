﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Заполнение вспомогательных данных.
	
	ЗапретРедактированияРолей = ПользователиПереопределяемый.ЗапретРедактированияРолей();
	АвторизованПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь();
	
	// Заполнение списка выбора языка.
	Если Метаданные.Языки.Количество() < 2 Тогда
		Элементы.ПользовательИнфБазыЯзык.Видимость = Ложь;
	Иначе
		Для каждого МетаданныеЯзыка ИЗ Метаданные.Языки Цикл
			
			Элементы.ПользовательИнфБазыЯзык.СписокВыбора.Добавить(
				МетаданныеЯзыка.Имя, МетаданныеЯзыка.Синоним);
		КонецЦикла;
	КонецЕсли;
	
	// Подготовка к интерактивным действиям с учетом сценариев открытия формы.
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		// Создание нового элемента.
		Если Параметры.ГруппаНовогоВнешнегоПользователя
		         <> Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
			
			ГруппаНовогоВнешнегоПользователя = Параметры.ГруппаНовогоВнешнегоПользователя;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			// Копирование элемента.
			ЗначениеКопирования = Параметры.ЗначениеКопирования;
			Объект.ОбъектАвторизации = Неопределено;
			Объект.Наименование      = "";
			Объект.Код               = "";
			Объект.УдалитьПароль     = "";
			ПрочитатьПользователяИБ(ЗначениеЗаполнено(
				Параметры.ЗначениеКопирования.ИдентификаторПользователяИБ));
		Иначе
			// Добавление элемента.
			Если Параметры.Свойство("ОбъектАвторизацииНовогоВнешнегоПользователя") Тогда
				
				Объект.ОбъектАвторизации = Параметры.ОбъектАвторизацииНовогоВнешнегоПользователя;
				ОбъектАвторизацииЗаданПриОткрытии = ЗначениеЗаполнено(Объект.ОбъектАвторизации);
				ОбъектАвторизацииПриИзмененииНаКлиентеНаСервере(ЭтотОбъект, Объект);
				
			ИначеЕсли ЗначениеЗаполнено(ГруппаНовогоВнешнегоПользователя) Тогда
				
				ТипОбъектовАвторизации = ОбщегоНазначения.ПолучитьЗначениеРеквизита(
					ГруппаНовогоВнешнегоПользователя, "ТипОбъектовАвторизации");
				
				Объект.ОбъектАвторизации = ТипОбъектовАвторизации;
				Элементы.ОбъектАвторизации.ВыбиратьТип = ТипОбъектовАвторизации = Неопределено;
			КонецЕсли;
			
			// Чтение начальных значений свойств пользователя ИБ.
			ПрочитатьПользователяИБ();
		КонецЕсли;
	Иначе
		// Открытие существующего элемента.
		ПрочитатьПользователяИБ();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ОбработатьИнтерфейсРолей("НастроитьИнтерфейсРолейПриСозданииФормы", Истина);
	
	ОпределитьДействияВФорме();
	
	ОпределитьНесоответствияПользователяСПользователемИБ();
	
	// Установка постоянной доступности свойств.
	Элементы.СвойстваПользователяИБ.Видимость =
		ЗначениеЗаполнено(ДействияВФорме.СвойстваПользователяИБ);
	
	Элементы.ОтображениеРолей.Видимость =
		ЗначениеЗаполнено(ДействияВФорме.Роли);
	
	Элементы.УстановитьРолиНепосредственно.Видимость =
		ЗначениеЗаполнено(ДействияВФорме.Роли) И НЕ ПользователиПереопределяемый.ЗапретРедактированияРолей();
	
	Элементы.УстановитьРолиНепосредственно.Доступность = ДействияВФорме.Роли = "Редактирование";
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь() Тогда
		Элементы.Недействителен.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ТолькоПросмотр
		=   ТолькоПросмотр
		ИЛИ ДействияВФорме.Роли <> "Редактирование"
		    И НЕ (    ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех"
		          ИЛИ ДействияВФорме.СвойстваПользователяИБ = "РедактированиеСвоих")
		    И ДействияВФорме.СвойстваЭлемента <> "Редактирование";
	
	Если НЕ ПользователиСлужебныйПовтИсп.АутентификацияOpenIDНастраивается() Тогда
		Элементы.ПользовательИнфБазыАутентификацияOpenID.Видимость = Ложь;
		Элементы.ПользовательИнфБазыАутентификацияСтандартная.Видимость = Ложь;
		Элементы.СвойстваПараметрыАутентификации1СПредприятия.Отображение = ОтображениеОбычнойГруппы.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьСвойств();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ТекущееПредставлениеОбъектаАвторизации = Строка(Объект.ОбъектАвторизации);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ)
	
	ОчиститьСообщения();
	
	Если ДействияВФорме.Роли = "Редактирование"
	   И Объект.УстановитьРолиНепосредственно
	   И ПользовательИнфБазыРоли.Количество() = 0 Тогда
		
		Ответ = Вопрос(
			НСтр("ru = 'Пользователю информационной базы не установлено ни одной роли. Продолжить?'"),
			РежимДиалогаВопрос.ДаНет,
			,
			,
			НСтр("ru = 'Запись пользователя информационной базы'"));
		
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ЗначениеКопирования", ЗначениеКопирования);
	
	// Автообновление наименования внешнего пользователя.
	ТекущееПредставлениеОбъектаАвторизации = Строка(ТекущийОбъект.ОбъектАвторизации);
	Объект.Наименование        = ТекущееПредставлениеОбъектаАвторизации;
	ТекущийОбъект.Наименование = ТекущееПредставлениеОбъектаАвторизации;
	
	// Восстановление действий в форме, если они изменены на клиенте.
	ОпределитьДействияВФорме();
	
	Если ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех"
	 ИЛИ ДействияВФорме.СвойстваПользователяИБ = "РедактированиеСвоих" Тогда
		
		ОписаниеПользователяИБ = ОписаниеПользователяИБ();
		ОписаниеПользователяИБ.Удалить("ПодтверждениеПароля");
		
		Если ДоступКИнформационнойБазеРазрешен Тогда
			ОписаниеПользователяИБ.Вставить("Действие", "Записать");
		Иначе
			ОписаниеПользователяИБ.Вставить("Действие", "Удалить");
		КонецЕсли;
		
		ТекущийОбъект.ДополнительныеСвойства.Вставить(
			"ОписаниеПользователяИБ", ОписаниеПользователяИБ);
	КонецЕсли;
	
	Если ДействияВФорме.СвойстваЭлемента <> "Редактирование" Тогда
		
		ЗаполнитьЗначенияСвойств(
			ТекущийОбъект,
			ОбщегоНазначения.ПолучитьЗначенияРеквизитов(
				ТекущийОбъект.Ссылка,
				"ПометкаУдаления"));
	КонецЕсли;
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить(
		"ГруппаНовогоВнешнегоПользователя", ГруппаНовогоВнешнегоПользователя);
	
	УстановитьПривилегированныйРежим(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить(
		ТекущийОбъект.ДополнительныеСвойства.ОписаниеПользователяИБ.РезультатДействия);
	
	ПрочитатьПользователяИБ();
	
	ОпределитьНесоответствияПользователяСПользователемИБ(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ВнешниеПользователи", Новый Структура, Объект.Ссылка);
	
	Если ПараметрыЗаписи.Свойство("ДобавленПользовательИБ") Тогда
		Оповестить("ДобавленПользовательИБ", ПараметрыЗаписи.ДобавленПользовательИБ, ЭтотОбъект);
		
	ИначеЕсли ПараметрыЗаписи.Свойство("ИзмененПользовательИБ") Тогда
		Оповестить("ИзмененПользовательИБ", ПараметрыЗаписи.ИзмененПользовательИБ, ЭтотОбъект);
		
	ИначеЕсли ПараметрыЗаписи.Свойство("УдаленПользовательИБ") Тогда
		Оповестить("УдаленПользовательИБ", ПараметрыЗаписи.УдаленПользовательИБ, ЭтотОбъект);
		
	ИначеЕсли ПараметрыЗаписи.Свойство("ОчищенаСвязьСНесуществущимПользователемИБ") Тогда
		
		Оповестить(
			"ОчищенаСвязьСНесуществущимПользователемИБ",
			ПараметрыЗаписи.ОчищенаСвязьСНесуществущимПользователемИБ, ЭтотОбъект);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ГруппаНовогоВнешнегоПользователя) Тогда
		ОповеститьОбИзменении(ГруппаНовогоВнешнегоПользователя);
		
		Оповестить(
			"Запись_ГруппыВнешнихПользователей",
			Новый Структура,
			ГруппаНовогоВнешнегоПользователя);
		
		ГруппаНовогоВнешнегоПользователя = Неопределено;
	КонецЕсли;
	
	УстановитьДоступностьСвойств();
	
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекстОшибки = "";
	Если ПользователиСлужебный.ОбъектАвторизацииИспользуется(
	         Объект.ОбъектАвторизации, Объект.Ссылка, , , ТекстОшибки) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки, , "Объект.ОбъектАвторизации", , Отказ);
	КонецЕсли;
	
	Если ДоступКИнформационнойБазеРазрешен Тогда
		
		ПользователиСлужебный.ПроверитьОписаниеПользователяИБ(
			ОписаниеПользователяИБ(), Отказ);
			
		ТекстСообщения = "";
		Если ПользователиСлужебный.ТребуетсяСоздатьПервогоАдминистратора( , ТекстСообщения) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения, , "ДоступКИнформационнойБазеРазрешен", , Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОбработатьИнтерфейсРолей("НастроитьИнтерфейсРолейПриЗагрузкеНастроек", Настройки);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОбъектАвторизацииПриИзменении(Элемент)
	
	ОбъектАвторизацииПриИзмененииНаКлиентеНаСервере(ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступКИнформационнойБазеРазрешенПриИзменении(Элемент)
	
	Если НЕ ПользовательИБСуществует
	   И ДоступКИнформационнойБазеРазрешен Тогда
		
		ПользовательИнфБазыИмя =
			ПользователиСлужебныйКлиентСервер.ПолучитьКраткоеИмяПользователяИБ(
				ТекущееПредставлениеОбъектаАвторизации);
	КонецЕсли;
	
	УстановитьДоступностьСвойств();
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательИнфБазыАутентификацияСтандартнаяПриИзменении(Элемент)
	
	УстановитьДоступностьСвойств();
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	ПользовательИнфБазыПароль = Пароль;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРолиНепосредственноПриИзменении(Элемент)
	
	Если НЕ Объект.УстановитьРолиНепосредственно Тогда
		ПрочитатьРолиПользователяИБ();
		ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект);
	КонецЕсли;
	
	УстановитьДоступностьСвойств();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Роли

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей

&НаКлиенте
Процедура РолиПометкаПриИзменении(Элемент)
	
	Если Элементы.Роли.ТекущиеДанные <> Неопределено Тогда
		ОбработатьИнтерфейсРолей("ОбновитьСоставРолей");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей

&НаКлиенте
Процедура ПоказатьТолькоВыбранныеРоли(Команда)
	
	ОбработатьИнтерфейсРолей("ТолькоВыбранныеРоли");
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаРолейПоПодсистемам(Команда)
	
	ОбработатьИнтерфейсРолей("ГруппировкаПоПодсистемам");
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьРоли(Команда)
	
	ОбработатьИнтерфейсРолей("ОбновитьСоставРолей", "ВключитьВсе");
	
	ПользователиСлужебныйКлиент.РазвернутьПодсистемыРолей(ЭтотОбъект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьРоли(Команда)
	
	ОбработатьИнтерфейсРолей("ОбновитьСоставРолей", "ИсключитьВсе");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОпределитьДействияВФорме()
	
	ДействияВФорме = Новый Структура;
	
	// "", "Просмотр",     "Редактирование".
	ДействияВФорме.Вставить("Роли",                   "");
	
	// "", "ПросмотрВсех", "РедактированиеВсех", "РедактированиеСвоих".
	ДействияВФорме.Вставить("СвойстваПользователяИБ", "");
	
	// "", "Просмотр",     "Редактирование".
	ДействияВФорме.Вставить("СвойстваЭлемента",       "");
	
	Если Пользователи.ЭтоПолноправныйПользователь()
	 ИЛИ ПравоДоступа("Добавление", Метаданные.Справочники.Пользователи) Тогда
		// Администратор.
		ДействияВФорме.Роли                   = "Редактирование";
		ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех";
		ДействияВФорме.СвойстваЭлемента       = "Редактирование";
		
	ИначеЕсли РольДоступна("ДобавлениеИзменениеВнешнихПользователей") Тогда
		// Менеджер внешних пользователей.
		ДействияВФорме.Роли                   = "";
		ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех";
		ДействияВФорме.СвойстваЭлемента       = "Просмотр";
		
	ИначеЕсли Объект.Ссылка = ПользователиКлиентСервер.АвторизованныйПользователь() Тогда
		// Свои свойства.
		ДействияВФорме.Роли                   = "";
		ДействияВФорме.СвойстваПользователяИБ = "РедактированиеСвоих";
		ДействияВФорме.СвойстваЭлемента       = "Просмотр";
	Иначе
		// Читатель внешних пользователей
		ДействияВФорме.Роли                   = "";
		ДействияВФорме.СвойстваПользователяИБ = "";
		ДействияВФорме.СвойстваЭлемента       = "Просмотр";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)
	   И НЕ ЗначениеЗаполнено(Объект.ОбъектАвторизации) Тогда
		
		ДействияВФорме.СвойстваЭлемента       = "Редактирование";
	КонецЕсли;
	
	ПользователиПереопределяемый.ИзменитьДействияВФорме(Объект.Ссылка, ДействияВФорме);
	
	// Проверка имен действий в форме.
	Если Найти(", Просмотр, Редактирование,", ", " + ДействияВФорме.Роли + ",") = 0 Тогда
		ДействияВФорме.Роли = "";
		
	ИначеЕсли ПользователиПереопределяемый.ЗапретРедактированияРолей() Тогда
		ДействияВФорме.Роли = "Просмотр";
	КонецЕсли;
	
	Если Найти(", ПросмотрВсех, РедактированиеВсех, РедактированиеСвоих,",
	           ", " + ДействияВФорме.СвойстваПользователяИБ + ",") = 0 Тогда
		
		ДействияВФорме.СвойстваПользователяИБ = "";
	КонецЕсли;
	
	Если Найти(", Просмотр, Редактирование,", ", " + ДействияВФорме.СвойстваЭлемента + ",") = 0 Тогда
		ДействияВФорме.СвойстваЭлемента = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОписаниеПользователяИБ()
	
	ПользовательИнфБазыПолноеИмя = Объект.Наименование;
	
	Если ДействияВФорме.СвойстваПользователяИБ = "РедактированиеВсех" Тогда
		Результат = Пользователи.НовоеОписаниеПользователяИБ();
		Пользователи.СкопироватьСвойстваПользователяИБ(
			Результат,
			ЭтотОбъект,
			,
			"УникальныйИдентификатор,
			|Роли",
			"ПользовательИнфБазы");

	Иначе
		// РедактированиеСвоих.
		Результат = Новый Структура;
		Результат.Вставить("Пароль", ПользовательИнфБазыПароль);
		Результат.Вставить("Язык",   ПользовательИнфБазыЯзык);
	КонецЕсли;
	Результат.Вставить("ПодтверждениеПароля", ПодтверждениеПароля);
	
	Если ДействияВФорме.Роли = "Редактирование"
	   И Объект.УстановитьРолиНепосредственно Тогда
		
		ТекущиеРоли = ПользовательИнфБазыРоли.Выгрузить(, "Роль").ВыгрузитьКолонку("Роль");
		Результат.Вставить("Роли", ТекущиеРоли);
	КонецЕсли;
	
	Если НЕ ПользователиСлужебныйПовтИсп.АутентификацияOpenIDНастраивается() Тогда
		Результат.Вставить("АутентификацияСтандартная", Истина);
	КонецЕсли;
	
	Результат.Вставить("ПоказыватьВСпискеВыбора", Ложь);
	Результат.Вставить("РежимЗапуска", "Авто");
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбъектАвторизацииПриИзмененииНаКлиентеНаСервере(Форма, Объект)
	
	Если Объект.ОбъектАвторизации = Неопределено Тогда
		Объект.ОбъектАвторизации = Форма.ТипОбъектовАвторизации;
	КонецЕсли;
	
	Если Форма.ТекущееПредставлениеОбъектаАвторизации <> Строка(Объект.ОбъектАвторизации) Тогда
		
		Форма.ТекущееПредставлениеОбъектаАвторизации = Строка(Объект.ОбъектАвторизации);
		
		Если НЕ Форма.ПользовательИБСуществует
		   И Форма.ДоступКИнформационнойБазеРазрешен Тогда
			
			Форма.ПользовательИнфБазыИмя =
				ПользователиСлужебныйКлиентСервер.ПолучитьКраткоеИмяПользователяИБ(
					Форма.ТекущееПредставлениеОбъектаАвторизации);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработка пользователя ИБ.

&НаСервере
Процедура ПрочитатьРолиПользователяИБ()
	
	СвойстваПользователяИБ = Неопределено;
	
	Пользователи.ПрочитатьПользователяИБ(
		Объект.ИдентификаторПользователяИБ, СвойстваПользователяИБ);
	
	ОбработатьИнтерфейсРолей("ЗаполнитьРоли", СвойстваПользователяИБ.Роли);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьПользователяИБ(ПриКопированииЭлемента = Ложь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Пароль              = "";
	ПодтверждениеПароля = "";
	ПрочитанныеСвойства               = Неопределено;
	ОписаниеПользователяИБ            = Пользователи.НовоеОписаниеПользователяИБ();
	ПользовательИБСуществует          = Ложь;
	ДоступКИнформационнойБазеРазрешен = Ложь;
	
	// Заполнение начальных значений свойств пользователяИБ.
	ОписаниеПользователяИБ.Роли = Новый Массив;
	ОписаниеПользователяИБ.АутентификацияСтандартная = Истина;
	
	Если ПриКопированииЭлемента Тогда
		
		Если Пользователи.ПрочитатьПользователяИБ(
		         Параметры.ЗначениеКопирования.ИдентификаторПользователяИБ,
		         ПрочитанныеСвойства) Тогда
			
			// Установка связи пользователем ИБ.
			ДоступКИнформационнойБазеРазрешен = Истина;
			
			// Копирование свойств и ролей пользователяИБ.
			ЗаполнитьЗначенияСвойств(
				ОписаниеПользователяИБ,
				ПрочитанныеСвойства,
				"АутентификацияOpenID,
				|АутентификацияСтандартная,
				|ЗапрещеноИзменятьПароль,
				|Язык,
				|Роли");
		КонецЕсли;
		Объект.ИдентификаторПользователяИБ = Неопределено;
	Иначе
		Если Пользователи.ПрочитатьПользователяИБ(
		       Объект.ИдентификаторПользователяИБ, ПрочитанныеСвойства) Тогда
			
			ПользовательИБСуществует          = Истина;
			ДоступКИнформационнойБазеРазрешен = Истина;
			
			ЗаполнитьЗначенияСвойств(
				ОписаниеПользователяИБ,
				ПрочитанныеСвойства,
				"Имя,
				|АутентификацияOpenID,
				|АутентификацияСтандартная,
				|ЗапрещеноИзменятьПароль,
				|Язык,
				|Роли");
			
			Если ПрочитанныеСвойства.ПарольУстановлен Тогда
				Пароль              = "**********";
				ПодтверждениеПароля = "**********";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Пользователи.СкопироватьСвойстваПользователяИБ(
		ЭтотОбъект,
		ОписаниеПользователяИБ,
		,
		"УникальныйИдентификатор,
		|Роли",
		"ПользовательИнфБазы");
	
	ОбработатьИнтерфейсРолей("ЗаполнитьРоли", ОписаниеПользователяИБ.Роли);
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьНесоответствияПользователяСПользователемИБ(ПараметрыЗаписи = Неопределено)
	
	// Определение связи с несуществующим пользователем ИБ.
	ЕстьНоваяСвязьСНесуществующимПользователемИБ =
		НЕ ПользовательИБСуществует И ЗначениеЗаполнено(Объект.ИдентификаторПользователяИБ);
	
	Если ПараметрыЗаписи <> Неопределено
	   И ЕстьСвязьСНесуществующимПользователемИБ
	   И НЕ ЕстьНоваяСвязьСНесуществующимПользователемИБ Тогда
		
		ПараметрыЗаписи.Вставить("ОчищенаСвязьСНесуществущимПользователемИБ", Объект.Ссылка);
	КонецЕсли;
	ЕстьСвязьСНесуществующимПользователемИБ = ЕстьНоваяСвязьСНесуществующимПользователемИБ;
	
	Если ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех" Тогда
		// Связь не может быть изменена.
		Элементы.СвязьОбработкаНесоответствия.Видимость = Ложь;
	Иначе
		Элементы.СвязьОбработкаНесоответствия.Видимость = ЕстьСвязьСНесуществующимПользователемИБ;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Начальное заполнение, проверка заполнения, доступность свойств

&НаКлиенте
Процедура УстановитьДоступностьСвойств()
	
	Элементы.ОбъектАвторизации.ТолькоПросмотр
		=   ДействияВФорме.СвойстваЭлемента <> "Редактирование"
		ИЛИ ОбъектАвторизацииЗаданПриОткрытии
		ИЛИ   ЗначениеЗаполнено(Объект.Ссылка)
		    И ЗначениеЗаполнено(Объект.ОбъектАвторизации);
	
	Элементы.ДоступКИнформационнойБазеРазрешен.ТолькоПросмотр =
		ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех";
	
	Элементы.СвойстваПользователяИБ.ТолькоПросмотр =
		ДействияВФорме.СвойстваПользователяИБ =  "ПросмотрВсех";
	
	Элементы.Пароль.ТолькоПросмотр =
		ПользовательИнфБазыЗапрещеноИзменятьПароль И НЕ АвторизованПолноправныйПользователь;
	
	Элементы.ПодтверждениеПароля.ТолькоПросмотр =
		ПользовательИнфБазыЗапрещеноИзменятьПароль И НЕ АвторизованПолноправныйПользователь;
	
	Элементы.ПользовательИнфБазыИмя.ТолькоПросмотр =
		ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех";
		
	Элементы.ПользовательИнфБазыЗапрещеноИзменятьПароль.ТолькоПросмотр =
		ДействияВФорме.СвойстваПользователяИБ <> "РедактированиеВсех";
	
	ОбработатьИнтерфейсРолей(
		"УстановитьТолькоПросмотрРолей",
		    ЗапретРедактированияРолей
		ИЛИ ДействияВФорме.Роли <> "Редактирование"
		ИЛИ НЕ Объект.УстановитьРолиНепосредственно);
	
	Элементы.ОсновныеСвойства.Доступность                     = ДоступКИнформационнойБазеРазрешен;
	Элементы.РедактированиеИлиПросмотрРолей.Доступность       = ДоступКИнформационнойБазеРазрешен;
	Элементы.ПользовательИнфБазыИмя.АвтоОтметкаНезаполненного = ДоступКИнформационнойБазеРазрешен;
	
	Элементы.Пароль.Доступность                                     = ПользовательИнфБазыАутентификацияСтандартная;
	Элементы.ПодтверждениеПароля.Доступность                        = ПользовательИнфБазыАутентификацияСтандартная;
	Элементы.ПользовательИнфБазыЗапрещеноИзменятьПароль.Доступность = ПользовательИнфБазыАутентификацияСтандартная;
	
	Элементы.ДоступКИнформационнойБазеРазрешен.Доступность = Не Объект.Недействителен;
	
КонецПроцедуры

&НаКлиенте
Процедура НедействителенПриИзменении(Элемент)
	
	Если Объект.Недействителен Тогда
		ДоступКИнформационнойБазеРазрешен = Ложь;
	КонецЕсли;
	
	УстановитьДоступностьСвойств();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей

&НаСервере
Процедура ОбработатьИнтерфейсРолей(Действие, ОсновнойПараметр = Неопределено)
	
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("ОсновнойПараметр",      ОсновнойПараметр);
	ПараметрыДействия.Вставить("Форма",                 ЭтотОбъект);
	ПараметрыДействия.Вставить("КоллекцияРолей",        ПользовательИнфБазыРоли);
	ПараметрыДействия.Вставить("ТипПользователя",       Перечисления.ТипыПользователей.ВнешнийПользователь);
	ПараметрыДействия.Вставить("СкрытьРольПолныеПрава", Истина);
	
	ПользователиСлужебный.ОбработатьИнтерфейсРолей(Действие, ПараметрыДействия);
	
КонецПроцедуры
