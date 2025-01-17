﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с файлами".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Определяет, можно ли занять файл и, если нет, то формирует строку ошибки
//
Функция МожноЛиЗанятьФайл(ДанныеФайла, СтрокаОшибки = "") Экспорт
	
	Если ДанныеФайла.ПометкаУдаления = Истина Тогда
		СтрокаОшибки =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		  НСтр("ru = 'Нельзя занять файл ""%1"", т.к. он помечен на удаление.'"),
		  Строка(ДанныеФайла.Ссылка));
		Возврат Ложь;
	КонецЕсли;
	
	
	Если ДанныеФайла.Редактирует.Пустая()
		Или ДанныеФайла.РедактируетТекущийПользователь Тогда 
		
		Возврат Истина;
		
	Иначе
		
		СтрокаОшибки =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		  НСтр("ru = 'Файл ""%1"" уже занят для редактирования пользователем ""%2"" с %3.'"),
		  Строка(ДанныеФайла.Ссылка), Строка(ДанныеФайла.Редактирует),
		  Формат(ДанныеФайла.ДатаЗаема, "ДФ='dd.MM.yyyy hh:mm'"));
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

// создает элемент справочника Файлы
Функция СоздатьЭлементСправочникаФайлы(ВыбранныйФайл, МассивСтруктурВсехФайлов, Владелец, 
	ИдентификаторФормы, Комментарий, ХранитьВерсии, ДобавленныеФайлы,
	АдресВременногоХранилищаФайла, АдресВременногоХранилищаТекста,
	Пользователь = Неопределено,
	Кодировка = Неопределено) Экспорт
	
	ИмяБезРасширения = ВыбранныйФайл.ИмяБезРасширения;
	Расширение = ВыбранныйФайл.Расширение;
	
	Расширение = ФайловыеФункцииСлужебныйКлиентСервер.РасширениеБезТочки(ВыбранныйФайл.Расширение);
	ВремяИзменения = ВыбранныйФайл.ПолучитьВремяИзменения();
	ВремяИзмененияУниверсальное = ВыбранныйФайл.ПолучитьУниверсальноеВремяИзменения();
	Размер = ВыбранныйФайл.Размер();
	
	// Создадим карточку Файла в БД
	ДокСсылка = РаботаСФайламиВызовСервера.СоздатьФайлСВерсией(
		Владелец,
		ИмяБезРасширения,
		Расширение,
		ВремяИзменения,
		ВремяИзмененияУниверсальное,
		Размер,
		АдресВременногоХранилищаФайла,
		АдресВременногоХранилищаТекста,
		Ложь,  // это не веб клиент
		Пользователь,
		Комментарий,
		Ложь,
		Кодировка);
	
	УдалитьИзВременногоХранилища(АдресВременногоХранилищаФайла);
	Если Не ПустаяСтрока(АдресВременногоХранилищаТекста) Тогда
		УдалитьИзВременногоХранилища(АдресВременногоХранилищаТекста);
	КонецЕсли;
	
	ДобавленныйФайлИПуть = Новый Структура("ФайлСсылка, Путь", ДокСсылка, ВыбранныйФайл.Путь);	
	ДобавленныеФайлы.Добавить(ДобавленныйФайлИПуть);
	
	Запись = Новый Структура;
	Запись.Вставить("ИмяФайла", ВыбранныйФайл.ПолноеИмя);
	Запись.Вставить("Файл", ДокСсылка);
	МассивСтруктурВсехФайлов.Добавить(Запись);

КонецФункции

// Получает имя сканированного файла, вида ДМ-00000012, где ДМ - префикс базы
Функция ПолучитьИмяСканированногоФайла(НомерФайла, ПрефиксБазы) Экспорт
	
	ИмяФайла = "";
	Если НЕ ПустаяСтрока(ПрефиксБазы) Тогда
		ИмяФайла = ПрефиксБазы + "-";
	КонецЕсли;
	
	ИмяФайла = ИмяФайла + Формат(НомерФайла, "ЧЦ=9; ЧВН=; ЧГ=0");
	
	Возврат ИмяФайла;
	
КонецФункции	

/////////////////////////////////////////////////////////////////////////////////////////
// Работа с кодировками

// Функция возвращает таблицу имен кодировок
// Возвращаемое значение:
// Результат (СписокЗначений)
// - Значение (Строка) - например "ibm852"
// - Представление (Строка) - например "ibm852 (Центральноевропейская DOS)"
//
Функция ПолучитьСписокКодировок() Экспорт

	СписокКодировок = Новый СписокЗначений;
	
	СписокКодировок.Добавить("ibm852",			"IBM852 (Центральноевропейская DOS)");
	СписокКодировок.Добавить("ibm866",			"IBM866 (Кириллица DOS)");
	СписокКодировок.Добавить("iso-8859-1",		"ISO-8859-1 (Западноевропейская ISO)");
	СписокКодировок.Добавить("iso-8859-2",		"ISO-8859-2 (Центральноевропейская ISO)");
	СписокКодировок.Добавить("iso-8859-3",		"ISO-8859-3 (Латиница 3 ISO)");
	СписокКодировок.Добавить("iso-8859-4",		"ISO-8859-4 (Балтийская ISO)");
	СписокКодировок.Добавить("iso-8859-5",		"ISO-8859-5 (Кириллица ISO)");
	СписокКодировок.Добавить("iso-8859-7",		"ISO-8859-7 (Греческая ISO)");
	СписокКодировок.Добавить("iso-8859-9",		"ISO-8859-9 (Турецкая ISO)");
	СписокКодировок.Добавить("iso-8859-15",		"ISO-8859-15 (Латиница 9 ISO)");
	СписокКодировок.Добавить("koi8-r",			"KOI8-R (Кириллица KOI8-R)");
	СписокКодировок.Добавить("koi8-u",			"KOI8-U (Кириллица KOI8-U)");
	СписокКодировок.Добавить("us-ascii",		"US-ASCII США");
	СписокКодировок.Добавить("utf-8",			"UTF-8 (Юникод UTF-8)");
	СписокКодировок.Добавить("windows-1250",	"Windows-1250 (Центральноевропейская Windows)");
	СписокКодировок.Добавить("windows-1251",	"windows-1251 (Кириллица Windows)");
	СписокКодировок.Добавить("windows-1252",	"Windows-1252 (Западноевропейская Windows)");
	СписокКодировок.Добавить("windows-1253",	"Windows-1253 (Греческая Windows)");
	СписокКодировок.Добавить("windows-1254",	"Windows-1254 (Турецкая Windows)");
	СписокКодировок.Добавить("windows-1257",	"Windows-1257 (Балтийская Windows)");
	
	Возврат СписокКодировок;

КонецФункции

// Преобразует дату в универсальное время и возвращает его
Функция ПолучитьУниверсальноеВремя(Дата) Экспорт
	
	УниверсальноеВремя = Дата('00010101');
	
	#Если Сервер Тогда
		ЧасовойПояс = ЧасовойПояс();
		Если ПолучитьДопустимыеЧасовыеПояса().Найти(ЧасовойПояс) = Неопределено Тогда
			// Если на компьютере установлен некорректный часовой пояс, то считаем, что GMT 0:00.
			УниверсальноеВремя = Дата;
		Иначе
			УниверсальноеВремя = УниверсальноеВремя(Дата, ЧасовойПояс);
		КонецЕсли;
	#Иначе
		УниверсальноеВремя = УниверсальноеВремя(Дата);
	#КонецЕсли
	
	Возврат УниверсальноеВремя;
	
КонецФункции	

