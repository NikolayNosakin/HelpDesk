﻿////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает помеченные на удаление объекты. Возможен отбор по фильтру.
//
Функция ПолучитьПомеченныеНаУдаление() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	МассивПомеченные = НайтиПомеченныеНаУдаление();
	УстановитьПривилегированныйРежим(Ложь);
	
	Результат = Новый Массив;
	Для Каждого ЭлементПомеченный Из МассивПомеченные Цикл
		Если ПравоДоступа("ИнтерактивноеУдалениеПомеченных", ЭлементПомеченный.Метаданные()) Тогда
			Результат.Добавить(ЭлементПомеченный);
		КонецЕсли
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Инициализирует таблицу типов удаляемых объектов.
//
// Возвращаемое значение:
//	ТаблицаЗначений - таблица типов.
//
Функция ПолучитьТаблицуТиповУдаляемыхОбъектов()
	
	УдаляемыеТипыОбъектов = Новый ТаблицаЗначений;
	УдаляемыеТипыОбъектов.Колонки.Добавить("Тип", Новый ОписаниеТипов("Тип"));
	
	Возврат УдаляемыеТипыОбъектов;
	
КонецФункции

// Обновляет таблицу типов обновляемых объектов.
//
// Параметры:
//	Таблица - ТаблицаЗначений - таблица с типами.
//	УдаляемыеОбъекты - Массив - массив удаляемых объектов.
//
Процедура ОбновитьТаблицуТиповУдаляемыхОбъектов(Таблица, знач УдаляемыеОбъекты)
	
	Для Каждого УдаляемыйОбъект Из УдаляемыеОбъекты Цикл
		НовыйТип = Таблица.Добавить();
		НовыйТип.Тип = ТипЗнч(УдаляемыйОбъект);
	КонецЦикла;
	
	Таблица.Свернуть("Тип");
	
КонецПроцедуры

// Возвращает структуру с полями Статус и Значение по переданным параметрам.
//
// Возвращаемое значение:
//	Структура - структура статуса операции.
//
Функция ЗаполнитьСтатусОперации(знач Значение, знач Статус = Истина)
	
	Возврат Новый Структура("Статус, Значение", Статус, Значение);
	
КонецФункции

// Получает массив помеченных для удаления объектов.
//
// Параметры:
//	СписокПомеченныхНаУдаление - ДеревоЗначений - дерево помеченных на удаление объектов.
//	РежимУдаления - Строка - режим удаоения.
// 
// Возвращаемое значение:
//	Массив- массив помеченных на удаление объектов.
//
Функция ПолучитьМассивПомеченныхОбъектовНаУдаление(СписокПомеченныхНаУдаление, РежимУдаления)
	
	Удаляемые = Новый Массив;
	
	Если РежимУдаления = "Полный" Тогда
		// При полном удалении получаем весь список помеченных на удаление
		Удаляемые = ПолучитьПомеченныеНаУдаление();
	Иначе
		// Заполняем массив ссылками на выбранные элементы, помеченные на удаление
		КоллекцияСтрокМетаданных = СписокПомеченныхНаУдаление.ПолучитьЭлементы();
		Для Каждого СтрокаОбъектаМетаданных Из КоллекцияСтрокМетаданных Цикл
			КоллекцияСтрокСсылок = СтрокаОбъектаМетаданных.ПолучитьЭлементы();
			Для Каждого СтрокаСсылки Из КоллекцияСтрокСсылок Цикл
				Если СтрокаСсылки.Пометка Тогда
					Удаляемые.Добавить(СтрокаСсылки.Значение);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Удаляемые;

КонецФункции	

// Выполняет процесс по удалению объектов.
//
// Параметры:
//	ПараметрыУдаления - Структура - параметры, необходимые для удаления.
//	АдресХранилища - Строка - адрес внутреннего хранилища.
//
Процедура УдалитьПомеченныеОбъекты(ПараметрыУдаления, АдресХранилища) Экспорт
	
	// Извлекаем параметры
	СписокПомеченныхНаУдаление	= ПараметрыУдаления.СписокПомеченныхНаУдаление;
	РежимУдаления				= ПараметрыУдаления.РежимУдаления;
	ТипыУдаленныхОбъектов		= ПараметрыУдаления.ТипыУдаленныхОбъектов;
	
	Удаляемые = ПолучитьМассивПомеченныхОбъектовНаУдаление(СписокПомеченныхНаУдаление, РежимУдаления);
	КоличествоУдаляемых = Удаляемые.Количество();
	
	// Выполняем удаление
	Результат = ВыполнитьУдаление(Удаляемые, ТипыУдаленныхОбъектов);
	
	// Добавляем параметры 
	Если ТипЗнч(Результат.Значение) = Тип("Структура") Тогда 
		КоличествоНеУдаленныхОбъектов = Результат.Значение.НеУдаленные.Количество();
	Иначе	
		КоличествоНеУдаленныхОбъектов = 0;
	КонецЕсли;	
	Результат.Вставить("КоличествоНеУдаленныхОбъектов", КоличествоНеУдаленныхОбъектов);
	Результат.Вставить("КоличествоУдаляемых",			КоличествоУдаляемых);
	Результат.Вставить("ТипыУдаленныхОбъектов",			ТипыУдаленныхОбъектов);
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

// Выполняет удаление объектов.
//
// Параметры:
//	Удаляемые - Массив - массив помеченных на удаление.
//	ТипыУдаленныхОбъектовМассив - Массив - массив типов удаленных объектов. 
//
// Возвращаемое значение:
//	Структура - структура с результатом удаления.
//
Функция ВыполнитьУдаление(Знач Удаляемые, ТипыУдаленныхОбъектовМассив) 
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для выполнения операции.'");
	КонецЕсли;
	
	Попытка
		ОбщегоНазначения.ЗаблокироватьИБ();
	Исключение
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось установить монопольный режим (%1)'"),
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат ЗаполнитьСтатусОперации(Сообщение, Ложь);
	КонецПопытки;
	
	ТипыУдаленныхОбъектов = ПолучитьТаблицуТиповУдаляемыхОбъектов();
	ОбновитьТаблицуТиповУдаляемыхОбъектов(ТипыУдаленныхОбъектов, Удаляемые);
	
	Найденные = Новый ТаблицаЗначений;
	НеУдаленные = Новый Массив;
	
	Найденные.Колонки.Добавить("Ссылка");
	Найденные.Колонки.Добавить("Данные");
	Найденные.Колонки.Добавить("Метаданные");
	
	УдаляемыеОбъекты = Новый Массив;
	Для Каждого СсылкаНаОбъект Из Удаляемые Цикл
		УдаляемыеОбъекты.Добавить(СсылкаНаОбъект);
	КонецЦикла;
	
	ИсключенияПоискаСсылок = ОбщегоНазначения.ПолучитьОбщийСписокИсключенийПоискаСсылок();
	ИзмеренияРегистров       = Новый Соответствие;
	ВедущиеИзмеренияОбъектов = Новый Соответствие;
	НаборыЗаписей            = Новый Соответствие;

	Пока УдаляемыеОбъекты.Количество() > 0 Цикл
		НайденныеДанные = Новый ТаблицаЗначений;
		
		// Попытка удалить с контролем ссылочной целостности.
		Попытка
			УстановитьПривилегированныйРежим(Истина);
			УдалитьОбъекты(УдаляемыеОбъекты, Истина, НайденныеДанные);
			УстановитьПривилегированныйРежим(Ложь);
		Исключение
			СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ОбщегоНазначения.РазблокироватьИБ();
			Возврат ЗаполнитьСтатусОперации(СообщениеОбОшибке, Ложь);
		КонецПопытки;
		
		КоличествоУдаляемыхОбъектов = УдаляемыеОбъекты.Количество();
		
		// Перемещение удаляемых объектов в список не удаленных
		// и добавление в список найденных зависимых объектов
		// с учетом исключения поиска ссылок.
		Для Каждого СтрокаТаблицы Из НайденныеДанные Цикл
			
			ПолноеИмяЗависимогоОбъекта = СтрокаТаблицы.Метаданные.ПолноеИмя();
			
			// Если найденный зависимый объект в списке исключений, тогда продолжить.
			Если ИсключенияПоискаСсылок.Найти(ПолноеИмяЗависимогоОбъекта) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			// Если найденный зависимый объект - запись регистра и удаляемый объект
			// находится в измерении этого регистра у которого установлен флажок Ведущее,
			// тогда продолжить.
			
			ВедущиеИзмерения = ВедущиеИзмеренияОбъектов[ПолноеИмяЗависимогоОбъекта];
			Если ВедущиеИзмерения = Неопределено Тогда
				// Заполнение измерений.
				ВедущиеИзмерения = Новый Соответствие;
				ВедущиеИзмеренияОбъектов.Вставить(ПолноеИмяЗависимогоОбъекта, ВедущиеИзмерения);
				
				Если ОбщегоНазначения.ЭтоРегистр(СтрокаТаблицы.Метаданные) Тогда
					Измерения = Новый Массив;
					ИзмеренияРегистров.Вставить(ПолноеИмяЗависимогоОбъекта, Измерения);
					Если ОбщегоНазначения.ЭтоРегистрСведений(СтрокаТаблицы.Метаданные) Тогда
						Для каждого Измерение Из СтрокаТаблицы.Метаданные.Измерения Цикл
							Если Измерение.Ведущее Тогда
								ВедущиеИзмерения.Вставить(Измерение.Имя, Истина);
							КонецЕсли;
							Измерения.Добавить(Измерение.Имя);
						КонецЦикла;
					Иначе
						Для каждого Измерение Из СтрокаТаблицы.Метаданные.Измерения Цикл
							ВедущиеИзмерения.Вставить(Измерение.Имя, Истина);
							Измерения.Добавить(Измерение.Имя);
						КонецЦикла;
					КонецЕсли;
					НаборЗаписей = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
						ПолноеИмяЗависимогоОбъекта).СоздатьНаборЗаписей();
					НаборыЗаписей.Вставить(ПолноеИмяЗависимогоОбъекта, НаборЗаписей);
				КонецЕсли;
			КонецЕсли;
			
			Если ВедущиеИзмерения.Количество() > 0 Тогда
				УдаляемыйОбъектВВедущемИзмерении = Ложь;
				
				ИзмеренияРегистра = ИзмеренияРегистров[ПолноеИмяЗависимогоОбъекта];
				НаборЗаписей      = НаборыЗаписей[ПолноеИмяЗависимогоОбъекта];
				Для каждого Измерение Из ИзмеренияРегистра Цикл
					НаборЗаписей.Отбор[Измерение].Установить(СтрокаТаблицы.Данные[Измерение]);
				КонецЦикла;
				НаборЗаписей.Прочитать();
				
				Если НаборЗаписей.Количество() > 0 Тогда
					Запись = НаборЗаписей[0];
					Для каждого ВедущееИзмерение Из ВедущиеИзмерения Цикл
						
						Если Запись[ВедущееИзмерение.Ключ] = СтрокаТаблицы.Ссылка Тогда
							УдаляемыйОбъектВВедущемИзмерении = Истина;
							Прервать;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
				
				Если УдаляемыйОбъектВВедущемИзмерении Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			// Сокращение удаляемых объектов.
			Индекс = УдаляемыеОбъекты.Найти(СтрокаТаблицы.Ссылка);
			Если Индекс <> Неопределено Тогда
				УдаляемыеОбъекты.Удалить(Индекс);
			КонецЕсли;
			
			// Добавление не удаленных объектов.
			Если НеУдаленные.Найти(СтрокаТаблицы.Ссылка) = Неопределено Тогда
				НеУдаленные.Добавить(СтрокаТаблицы.Ссылка);
			КонецЕсли;
			
			// Добавление найденных зависимых объектов.
			НоваяСтрока = Найденные.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			
		КонецЦикла;
		
		// Удаление без контроля, если состав удаляемых объектов не был изменён на этом шаге цикла.
		Если КоличествоУдаляемыхОбъектов = УдаляемыеОбъекты.Количество() Тогда
			Попытка
				// Удаление без контроля ссылочной целостности.
				УстановитьПривилегированныйРежим(Истина);
				УдалитьОбъекты(УдаляемыеОбъекты, Ложь);
				УстановитьПривилегированныйРежим(Ложь);
			Исключение
				СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ОбщегоНазначения.РазблокироватьИБ();
				Возврат ЗаполнитьСтатусОперации(СообщениеОбОшибке, Ложь);
			КонецПопытки;
			
			// Удаление всего, что возможно, завершено - выход из цикла.
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого НеУдаленныйОбъект Из НеУдаленные Цикл
		НайденныеСтроки = ТипыУдаленныхОбъектов.НайтиСтроки(Новый Структура("Тип", ТипЗнч(НеУдаленныйОбъект)));
		Если НайденныеСтроки.Количество() > 0 Тогда
			ТипыУдаленныхОбъектов.Удалить(НайденныеСтроки[0]);
		КонецЕсли;
	КонецЦикла;
	
	ТипыУдаленныхОбъектовМассив = ТипыУдаленныхОбъектов.ВыгрузитьКолонку("Тип");
	
	ОбщегоНазначения.РазблокироватьИБ();
	
	Возврат ЗаполнитьСтатусОперации(Новый Структура("Найденные, НеУдаленные", Найденные, НеУдаленные));
	
КонецФункции
