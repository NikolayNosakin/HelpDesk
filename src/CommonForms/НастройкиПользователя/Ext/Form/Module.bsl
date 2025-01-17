﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьПроверкуПравДоступа("СохранениеДанныхПользователя", Метаданные);
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	ЗапрашиватьПодтверждениеПриЗавершенииПрограммы = СтандартныеПодсистемыСервер.ЗапрашиватьПодтверждениеПриЗавершенииПрограммы();
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.Пользователи
	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	// Конец СтандартныеПодсистемы.Пользователи
	
	// СтандартныеПодсистемы.РаботаСФайлами
	СпрашиватьРежимРедактированияПриОткрытииФайла = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов", 
		"СпрашиватьРежимРедактированияПриОткрытииФайла",
		Истина
	);
	
	ДействиеПоДвойномуЩелчкуМыши = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиОткрытияФайлов", 
		"ДействиеПоДвойномуЩелчкуМыши",
		Перечисления.ДействияСФайламиПоДвойномуЩелчку.ОткрыватьФайл
	);
	
	СпособСравненияВерсийФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиСравненияФайлов", 
		"СпособСравненияВерсийФайлов",
		Перечисления.СпособыСравненияВерсийФайлов.ПустаяСсылка()
	);
	
	ПоказыватьПодсказкиПриРедактированииФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", 
		"ПоказыватьПодсказкиПриРедактированииФайлов",
		Ложь
	);
	
	ПоказыватьИнформациюЧтоФайлНеБылИзменен = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", 
		"ПоказыватьИнформациюЧтоФайлНеБылИзменен",
		Ложь
	);
	
	ПоказыватьЗанятыеФайлыПриЗавершенииРаботы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", 
		"ПоказыватьЗанятыеФайлыПриЗавершенииРаботы",
		Истина
	);
	
	ПоказыватьКолонкуРазмер = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", 
		"ПоказыватьКолонкуРазмер",
		Ложь
	);
	
	// Заполняем настройки открытия файлов
	СтрокаНастройки = НастройкиОткрытияФайлов.Добавить();
	СтрокаНастройки.ТипФайла = Перечисления.ТипыФайловДляВстроенногоРедактора.ТекстовыеФайлы;
	
	СтрокаНастройки.Расширение =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиОткрытияФайлов\ТекстовыеФайлы",
			"Расширение",
			"TXT XML INI");
	
	СтрокаНастройки.СпособОткрытия =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиОткрытияФайлов\ТекстовыеФайлы",
			"СпособОткрытия",
			Перечисления.СпособыОткрытияФайлаНаПросмотр.ВоВстроенномРедакторе);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// Работа с почтой
	ИспользоватьВстроеннуюПочту = РегистрыСведений.ИспользованиеПочты.ПолучитьИспользованиеВстроеннойПочты();
	НачальноеЗначениеИспользоватьВстроеннуюПочту = ИспользоватьВстроеннуюПочту;
	Элементы.НастройкиВстроеннойПочты.Доступность = ИспользоватьВстроеннуюПочту;

	ОрганизацияПоУмолчанию = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", 
		"ОрганизацияПоУмолчанию",
		Справочники.Организации.ОрганизацияПоУмолчанию);
	ОсновнойИсполнитель = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", 
		"ОсновнойИсполнитель",
		Справочники.Пользователи.ПустаяСсылка());
	ОсновнойТипЗаявки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", 
		"ОсновнойТипЗаявки",
		Справочники.ТипыЗаявок.ПустаяСсылка());	
	ОсновнойКонтрагент = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПрограммы", 
		"ОсновнойКонтрагент",
		Справочники.Контрагенты.ПустаяСсылка());

	// Проект
	Проект =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиРаботыСПроектами",
			"ПроектПоУмолчанию");
	
	ВидПроекта =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиРаботыСПроектами",
			"ВидПроектаПоУмолчанию");
			
	КалендарьДляПереданныхЗадач =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиРаботыСКалендарем",
			"КалендарьДляПереданныхЗадач");
		
	// Настройки учета времени
	ВидРабот =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиУчетаВремени",
			"ВидРабот");
	
	СпособУказанияВремени =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиУчетаВремени",
			"СпособУказанияВремени");
	
	Если Не ЗначениеЗаполнено(СпособУказанияВремени) Тогда
		СпособУказанияВремени = Перечисления.СпособыУказанияВремени.Длительность;
		
		ХранилищеОбщихНастроек.Сохранить(
			"НастройкиУчетаВремени",
			"СпособУказанияВремени",
			СпособУказанияВремени);
		
	КонецЕсли;
	
	ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи =
		ХранилищеОбщихНастроек.Загрузить(
			"НастройкиУчетаВремени",
			"ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи");
	
	Если Не ЗначениеЗаполнено(ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи) Тогда
		ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи = Истина;
		
		ХранилищеОбщихНастроек.Сохранить(
			"НастройкиУчетаВремени",
			"ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи",
			ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи);
		
	КонецЕсли;
	
	УказыватьТрудозатратыПриЗаписи =
	ХранилищеОбщихНастроек.Загрузить(
	"НастройкиУчетаВремени",
	"УказыватьТрудозатратыПриЗаписи");

	Если Не ЗначениеЗаполнено(УказыватьТрудозатратыПриЗаписи) Тогда
		УказыватьТрудозатратыПриЗаписи = Ложь;
		
		ХранилищеОбщихНастроек.Сохранить(
			"НастройкиУчетаВремени",
			"УказыватьТрудозатратыПриЗаписи",
			УказыватьТрудозатратыПриЗаписи);
		
	КонецЕсли;
	
	Элементы.УчетВремени.Видимость =   Константы.ИспользоватьЕжедневныеОтчеты.Получить();
	
	Элементы.Планирование.Видимость =   Константы.ИспользоватьПланированиеЗаявок.Получить();
	
	Элементы.Проект.Доступность = ЗначениеЗаполнено(ОсновнойКонтрагент);

КонецПроцедуры 

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// Страница Общие

&НаКлиенте
Процедура СведенияОПользователе(Команда)
	
	ПоказатьЗначение(Неопределено, АвторизованныйПользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерсональнаяНастройкаПроксиСервера(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера", Новый Структура("НастройкаПроксиНаКлиенте", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширениеРаботыСФайламиНаКлиенте(Команда)
	
	НачатьУстановкуРасширенияРаботыСФайлами();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметрыСистемы(Команда)
	
	ОбновитьПовторноИспользуемыеЗначения();
	ОбновитьИнтерфейс();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Страница ИнтеграцияС1СДокументооборот

&НаКлиенте
Процедура НастроитьПараметрыАвторизацииВ1СДокументооборот(Команда)
	//ОткрытьФормуМодально("ОбщаяФорма.АвторизацияВ1СДокументооборот");
КонецПроцедуры

&НаКлиенте
Процедура НастройкаРабочегоКаталогаИнтеграции(Команда)
	//ОткрытьФорму("ОбщаяФорма.ДокументооборотНастройкаКаталогаФайлов");
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Страница РаботаСФайлами

&НаКлиенте
Процедура НастройкаРабочегоКаталога(Команда)
	
	ОткрытьФорму("ОбщаяФорма.НастройкаЛокальногоКэшаФайлов",,,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	МассивСтруктур = Новый Массив;
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МассивСтруктур.Добавить(ОписаниеНастройки(
	    "ОбщиеНастройкиПользователя",
	    "ЗапрашиватьПодтверждениеПриЗавершенииПрограммы",
	    ЗапрашиватьПодтверждениеПриЗавершенииПрограммы));
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	//Кострицын Олег-Старт  27 февраля 2019 г.
	глЗапрашиватьПодтверждениеПриЗавершенииПрограммы = ЗапрашиватьПодтверждениеПриЗавершенииПрограммы;
	//Кострицын Олег-финиш  27 февраля 2019 г.
	
	// СтандартныеПодсистемы.РаботаСФайлами
	МассивСтруктур.Добавить(ОписаниеНастройки(
	    "НастройкиОткрытияФайлов",
	    "ДействиеПоДвойномуЩелчкуМыши",
	    ДействиеПоДвойномуЩелчкуМыши));
	МассивСтруктур.Добавить(ОписаниеНастройки(
	    "НастройкиОткрытияФайлов",
	    "СпрашиватьРежимРедактированияПриОткрытииФайла",
	    СпрашиватьРежимРедактированияПриОткрытииФайла));
	МассивСтруктур.Добавить(ОписаниеНастройки(
	    "НастройкиПрограммы",
	    "ПоказыватьПодсказкиПриРедактированииФайлов",
	    ПоказыватьПодсказкиПриРедактированииФайлов));
	МассивСтруктур.Добавить(ОписаниеНастройки(
	    "НастройкиПрограммы",
	    "ПоказыватьЗанятыеФайлыПриЗавершенииРаботы",
	    ПоказыватьЗанятыеФайлыПриЗавершенииРаботы));
	МассивСтруктур.Добавить(ОписаниеНастройки(
	    "НастройкиСравненияФайлов",
	    "СпособСравненияВерсийФайлов",
	    СпособСравненияВерсийФайлов));
	МассивСтруктур.Добавить(ОписаниеНастройки(
	    "НастройкиПрограммы",
	    "ПоказыватьКолонкуРазмер",
	    ПоказыватьКолонкуРазмер));
	МассивСтруктур.Добавить(ОписаниеНастройки(
	    "НастройкиПрограммы",
	    "ПоказыватьИнформациюЧтоФайлНеБылИзменен",
	    ПоказыватьИнформациюЧтоФайлНеБылИзменен));
	// Настройки открытия файлов
	Если НастройкиОткрытияФайлов.Количество() >= 1 Тогда 
		ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиОткрытияФайлов\ТекстовыеФайлы", "Расширение", 
			НастройкиОткрытияФайлов[0].Расширение);
		ДобавитьСтруктуруНастройки(МассивСтруктур, "НастройкиОткрытияФайлов\ТекстовыеФайлы", "СпособОткрытия", 
			НастройкиОткрытияФайлов[0].СпособОткрытия);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	МассивСтруктур.Добавить(ОписаниеНастройки(
	"НастройкиПрограммы",
	"ОрганизацияПоУмолчанию",
	ОрганизацияПоУмолчанию));
	МассивСтруктур.Добавить(ОписаниеНастройки(
	"НастройкиПрограммы",
	"ОсновнойИсполнитель",
	ОсновнойИсполнитель));
	МассивСтруктур.Добавить(ОписаниеНастройки(
	"НастройкиПрограммы",
	"ОсновнойКонтрагент",
	ОсновнойКонтрагент));	
	МассивСтруктур.Добавить(ОписаниеНастройки(
	"НастройкиПрограммы",
	"ОсновнойТипЗаявки",
	ОсновнойТипЗаявки));
		
	// НастройкиУчетаВремени
	МассивСтруктур.Добавить(ОписаниеНастройки(
	"НастройкиУчетаВремени", "ВидРабот", ВидРабот));
	МассивСтруктур.Добавить(ОписаниеНастройки(
	"НастройкиУчетаВремени", "СпособУказанияВремени", СпособУказанияВремени));
	МассивСтруктур.Добавить(ОписаниеНастройки(
	"НастройкиУчетаВремени", "ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи", ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи));
	МассивСтруктур.Добавить(ОписаниеНастройки(
	"НастройкиУчетаВремени", "УказыватьТрудозатратыПриЗаписи", УказыватьТрудозатратыПриЗаписи));

	
	// Проект
	МассивСтруктур.Добавить(ОписаниеНастройки(
	"НастройкиРаботыСПроектами", "ПроектПоУмолчанию", Проект));
	МассивСтруктур.Добавить(ОписаниеНастройки(
	"НастройкиРаботыСПроектами", "ВидПроектаПоУмолчанию", ВидПроекта));
	
	МассивСтруктур.Добавить(ОписаниеНастройки(
	"НастройкиРаботыСКалендарем", "КалендарьДляПереданныхЗадач", КалендарьДляПереданныхЗадач));
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьМассивИОбновитьПовторноИспользуемыеЗначения(МассивСтруктур);
	
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ДобавитьСтруктуруНастройки(МассивСтруктур, Объект, Настройка = Неопределено, Значение)
	
	МассивСтруктур.Добавить(Новый Структура ("Объект, Настройка, Значение", Объект, Настройка, Значение));
	
КонецПроцедуры

Функция ОписаниеНастройки(Объект, Настойка, Значение)
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", Объект);
	Элемент.Вставить("Настройка", Настойка);
	Элемент.Вставить("Значение", Значение);
	
	Возврат Элемент;
	
КонецФункции

&НаКлиенте
Процедура НастройкиВстроеннойПочты(Команда)
	
	ВстроеннаяПочтаКлиент.ОткрытьФормуНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВстроеннуюПочтуПриИзменении(Элемент)
	
	УстановитьФункциональныеОпцииИспользованияПочты();
	Элементы.НастройкиВстроеннойПочты.Доступность = ИспользоватьВстроеннуюПочту;
	ОбновитьИнтерфейсКлиент();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииИспользованияПочты()
	
	РегистрыСведений.ИспользованиеПочты.УстановитьИспользованиеПочты(Ложь, ИспользоватьВстроеннуюПочту);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсКлиент()
	
	УстанавливаемыеПараметры = Новый Структура;
	УстанавливаемыеПараметры.Вставить("Пользователи", Пользователи.ТекущийПользователь());
	УстановитьПараметрыФункциональныхОпцийИнтерфейса(УстанавливаемыеПараметры);
	ОбновитьИнтерфейс();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ОтменаСервер();
	Модифицированность = Ложь;
	Закрыть(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

&НаСервере
Процедура ОтменаСервер()
	
	ИспользоватьВстроеннуюПочту = НачальноеЗначениеИспользоватьВстроеннуюПочту;
	УстановитьФункциональныеОпцииИспользованияПочты();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
   
    ЗначениеОтбора = Новый Структура("Заказчик", ОсновнойКонтрагент);
    ПараметрыВыбора = Новый Структура("Отбор", ЗначениеОтбора);
    ОткрытьФорму("Справочник.Проекты.ФормаВыбора", ПараметрыВыбора,Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновнойКонтрагентПриИзменении(Элемент)
	Элементы.Проект.Доступность = ЗначениеЗаполнено(ОсновнойКонтрагент);
КонецПроцедуры

