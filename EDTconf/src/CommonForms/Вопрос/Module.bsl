////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Параметры.Заголовок) Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Таймаут = Параметры.Таймаут;
	Элементы.ТекстСообщения.Заголовок = Параметры.ТекстСообщения;
	ДобавитьКомандыИКнопкиНаФорму(Параметры.Кнопки);
	УстановитьКнопкуПоУмолчанию(Параметры.КнопкаПоУмолчанию);
	
	Если НЕ ПустаяСтрока(Параметры.КнопкаТаймаута) Тогда
		Для Каждого Элемент Из СоответствиеКнопокИВозвращаемыхЗначений Цикл
			Если Элемент.Значение = Параметры.КнопкаТаймаута Тогда
				КомандаТаймаута = Элемент.Ключ;
				Команда = Команды.Найти(КомандаТаймаута);
				ЗаголовокКомандыТаймаута = Команда.Заголовок;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Элементы.БольшеНеЗадаватьЭтотВопрос.Видимость = ПравоДоступа("СохранениеДанныхПользователя", Метаданные);
	
	//// сброс размеров и положения формы 
	ОчиститьНастройкиФормы();
	
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Таймаут > 0 Тогда
		Если КомандаТаймаута <> "" Тогда
			Элементы[КомандаТаймаута].Заголовок = ПолучитьЗаголовокКнопкиТаймаута(ЗаголовокКомандыТаймаута, Таймаут);
		КонецЕсли;
		ПодключитьОбработчикОжидания("Таймер", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура Подключаемый_ОбработчикКоманды(Команда)
	
	Закрыть(Новый Структура("БольшеНеЗадаватьЭтотВопрос, Значение",
        БольшеНеЗадаватьЭтотВопрос,
        КодВозвратаДиалогаПоЗначению(СоответствиеКнопокИВозвращаемыхЗначений.Получить(Команда.Имя))));
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Добавляет команды и соответствующие им кнопки на форму.
//
// Параметры:
//  Кнопки - Строка / CписокЗначений - набор кнопок
//           если строка - строковый идентификатор в формате "РежимДиалогаВопрос.<одно из значений РежимДиалогаВопрос>",
//           например "РежимДиалогаВопрос.ДаНет"
//           если CписокЗначений - для каждой записи,
//           Значение - значение возвращаемое формой при нажатии кнопки
//           Представление - заголовок кнопки
//
&НаСервере
Процедура ДобавитьКомандыИКнопкиНаФорму(Кнопки)
	
	Если ТипЗнч(Кнопки) = Тип("Строка") Тогда
		КнопкиСписокЗначений = СтандартныйНабор(Кнопки);
	Иначе
		КнопкиСписокЗначений = Кнопки;
	КонецЕсли;
	
	СоответствиеКнопокЗначениям = Новый Соответствие;
	
	Индекс = 0;
	
	Для Каждого ЭлементОписаниеКнопки Из КнопкиСписокЗначений Цикл
		Индекс = Индекс + 1;
		ИмяКоманды = "Команда" + Строка(Индекс);
		Команда = Команды.Добавить(ИмяКоманды);
		Команда.Действие  = "Подключаемый_ОбработчикКоманды";
		Команда.Заголовок = ЭлементОписаниеКнопки.Представление;
		Команда.ИзменяетСохраняемыеДанные = Ложь;
		
		Кнопка= Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), Элементы.ФормаКоманднаяПанель);
		Кнопка.ТолькоВоВсехДействиях = Ложь;
		Кнопка.ИмяКоманды = ИмяКоманды;
		
		СоответствиеКнопокЗначениям.Вставить(ИмяКоманды, ЭлементОписаниеКнопки.Значение);
	КонецЦикла;
	
	СоответствиеКнопокИВозвращаемыхЗначений = Новый ФиксированноеСоответствие(СоответствиеКнопокЗначениям);
	
КонецПроцедуры

&НаКлиенте
Процедура Таймер()
	
	Если Таймаут = 0 Тогда
		Закрыть(Новый Структура("БольшеНеЗадаватьЭтотВопрос, Значение",
		                        Ложь,
		                        КодВозвратаДиалога.Таймаут) );
	Иначе
		Таймаут = Таймаут - 1;
		Если КомандаТаймаута <> "" Тогда
			Элементы[КомандаТаймаута].Заголовок = ПолучитьЗаголовокКнопкиТаймаута(ЗаголовокКомандыТаймаута, Таймаут);
		КонецЕсли;
		ПодключитьОбработчикОжидания("Таймер", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтандартныйНабор(Кнопки)
	
	Результат = Новый СписокЗначений;
	
	Если      Кнопки = "РежимДиалогаВопрос.ДаНет" Тогда
		Результат.Добавить("КодВозвратаДиалога.Да",         НСтр("ru = 'Да'"));
		Результат.Добавить("КодВозвратаДиалога.Нет",        НСтр("ru = 'Нет'"));
	ИначеЕсли Кнопки = "РежимДиалогаВопрос.ДаНетОтмена" Тогда
		Результат.Добавить("КодВозвратаДиалога.Да",         НСтр("ru = 'Да'"));
		Результат.Добавить("КодВозвратаДиалога.Нет",        НСтр("ru = 'Нет'"));
		Результат.Добавить("КодВозвратаДиалога.Отмена",     НСтр("ru = 'Отмена'"));
	ИначеЕсли Кнопки = "РежимДиалогаВопрос.ОК" Тогда
		Результат.Добавить("КодВозвратаДиалога.ОК",         НСтр("ru = 'ОК'"));
	ИначеЕсли Кнопки = "РежимДиалогаВопрос.ОКОтмена" Тогда
		Результат.Добавить("КодВозвратаДиалога.ОК",         НСтр("ru = 'ОК'"));
		Результат.Добавить("КодВозвратаДиалога.Отмена",     НСтр("ru = 'Отмена'"));
	ИначеЕсли Кнопки = "РежимДиалогаВопрос.ПовторитьОтмена" Тогда
		Результат.Добавить("КодВозвратаДиалога.Повторить",  НСтр("ru = 'Повторить'"));
		Результат.Добавить("КодВозвратаДиалога.Отмена",     НСтр("ru = 'Отмена'"));
	ИначеЕсли Кнопки = "РежимДиалогаВопрос.ПрерватьПовторитьПропустить" Тогда
		Результат.Добавить("КодВозвратаДиалога.Прервать",   НСтр("ru = 'Прервать'"));
		Результат.Добавить("КодВозвратаДиалога.Повторить",  НСтр("ru = 'Повторить'"));
		Результат.Добавить("КодВозвратаДиалога.Пропустить", НСтр("ru = 'Пропустить'"));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура УстановитьКнопкуПоУмолчанию(КнопкаПоУмолчанию)
	
	Для Каждого Элемент Из СоответствиеКнопокИВозвращаемыхЗначений Цикл
		Если Элемент.Значение = КнопкаПоУмолчанию Тогда
			Элементы[Элемент.Ключ].КнопкаПоУмолчанию = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция КодВозвратаДиалогаПоЗначению(Значение)
	
	Если ТипЗнч(Значение) <> Тип("Строка") Тогда
		Возврат Значение;
	КонецЕсли;
	
	Если      Значение = "КодВозвратаДиалога.Да" Тогда
		Результат = КодВозвратаДиалога.Да;
	ИначеЕсли Значение = "КодВозвратаДиалога.Нет" Тогда
		Результат = КодВозвратаДиалога.Нет;
	ИначеЕсли Значение = "КодВозвратаДиалога.ОК" Тогда
		Результат = КодВозвратаДиалога.ОК;
	ИначеЕсли Значение = "КодВозвратаДиалога.Отмена" Тогда
		Результат = КодВозвратаДиалога.Отмена;
	ИначеЕсли Значение = "КодВозвратаДиалога.Повторить" Тогда
		Результат = КодВозвратаДиалога.Повторить;
	ИначеЕсли Значение = "КодВозвратаДиалога.Прервать" Тогда
		Результат = КодВозвратаДиалога.Прервать;
	ИначеЕсли Значение = "КодВозвратаДиалога.Пропустить" Тогда
		Результат = КодВозвратаДиалога.Пропустить;
	Иначе
		Результат = Значение;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ПолучитьЗаголовокКнопкиТаймаута(Заголовок, ЧислоСекунд)
	
	Шаблон = НСтр("ru = '%1 (осталось %2 сек.)'");
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Заголовок, ЧислоСекунд);
	
КонецФункции

&НаСервере
Процедура ОчиститьНастройкиФормы()

	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить("ОбщаяФорма.Вопрос", "", ИмяПользователя);
	КонецЕсли;
	
КонецПроцедуры

















