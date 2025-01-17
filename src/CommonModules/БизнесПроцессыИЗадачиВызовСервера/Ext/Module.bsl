﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-процессы и задачи"
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Получить структуру с описанием формы выполнения задачи.
//
// Параметры
//  ЗадачаСсылка  – ЗадачаСсылка.ЗадачаИсполнителя – задача
//
// Возвращаемое значение:
//   Структура   – структуру с описанием формы выполнения задачи.
//
Функция ПолучитьФормуВыполненияЗадачи(Знач ЗадачаСсылка) Экспорт
	
	Если ТипЗнч(ЗадачаСсылка) <> Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неправильный тип параметра ЗадачаСсылка (передан: %1; ожидается: %2)'"),
			ТипЗнч(ЗадачаСсылка), "ЗадачаСсылка.ЗадачаИсполнителя");
		ВызватьИсключение ТекстСообщения;
		
	КонецЕсли;
	
	Реквизиты = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ЗадачаСсылка, "БизнесПроцесс,ТочкаМаршрута");
	Если Реквизиты.БизнесПроцесс = Неопределено ИЛИ Реквизиты.БизнесПроцесс.Пустая() Тогда
		Возврат Новый Структура();
	КонецЕсли;
	
	ТипБизнесПроцесса = Реквизиты.БизнесПроцесс.Метаданные();
	ПараметрыФормы = БизнесПроцессы[ТипБизнесПроцесса.Имя].ФормаВыполненияЗадачи(ЗадачаСсылка,
		Реквизиты.ТочкаМаршрута);
	Возврат ПараметрыФормы;
	
КонецФункции

// Проверяет, находится ли в ячейке отчета ссылка на задачу и в параметре
// ЗначениеРасшифровки возвращает значение расшифровки.
//
Функция ЭтоЗадачаИсполнителю(Знач Расшифровка, Знач ДанныеРасшифровкиОтчета, ЗначениеРасшифровки) Экспорт
	
	ДанныеРасшифровкиОбъект = ПолучитьИзВременногоХранилища(ДанныеРасшифровкиОтчета);
	ЗначениеРасшифровки = ДанныеРасшифровкиОбъект.Элементы[Расшифровка].ПолучитьПоля()[0].Значение;
	Возврат ТипЗнч(ЗначениеРасшифровки) = Тип("ЗадачаСсылка.ЗадачаИсполнителя");
	
КонецФункции

// Выполнить задачу ЗадачаСсылка, при необходимости выполнив обработчик
// ОбработкаВыполненияПоУмолчанию модуля менеджера бизнес-процесса, 
// к которому относится задача ЗадачаСсылка.
//
Процедура ВыполнитьЗадачу(ЗадачаСсылка, ДействиеПоУмолчанию = Ложь) Экспорт

	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Задача.ЗадачаИсполнителя");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ЗадачаСсылка);
		Блокировка.Заблокировать();
		
		ЗадачаОбъект = ЗадачаСсылка.ПолучитьОбъект();
		ЗадачаОбъект.Прочитать();
		Если ДействиеПоУмолчанию И ЗадачаОбъект.БизнесПроцесс <> Неопределено 
			И НЕ ЗадачаОбъект.БизнесПроцесс.Пустая() Тогда
			ТипБизнесПроцесса = ЗадачаОбъект.БизнесПроцесс.Метаданные();
			БизнесПроцессы[ТипБизнесПроцесса.Имя].ОбработкаВыполненияПоУмолчанию(ЗадачаСсылка,
				ЗадачаОбъект.БизнесПроцесс, ЗадачаОбъект.ТочкаМаршрута);
		КонецЕсли;
			
		ЗадачаОбъект.Выполнена = Ложь;
		ЗадачаОбъект.ВыполнитьЗадачу();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

// Перенаправить задачи МассивЗадач новому исполнителю, указанному в структуре
// ИнфоОПеренаправлении. 
//
// Параметры
//  МассивЗадач          – Массив    – массив задач для перенаправления
//  ИнфоОПеренаправлении - Структура - содержит новые значения реквизитов адресации задачи
//  ТолькоПроверка       - Булево    - если Истина, то функция не будет выполнять
//                                     физического перенаправления задач, а только 
//                                     проверит возможность перенаправления.
//  МассивПеренаправленныхЗадач - Массив – массив перенаправленных задач.
//                                         Может отличаться по составу элементов от 
//                                         массива МассивЗадач, если какие-то задачи
//                                         не удалось перенаправить.
//
// Возвращаемое значение:
//   Булево   – Истина, если перенаправление выполнено успешно.
//
Функция ПеренаправитьЗадачи(Знач МассивЗадач, Знач ИнфоОПеренаправлении, Знач ТолькоПроверка = Ложь,
	МассивПеренаправленныхЗадач = Неопределено) Экспорт
	
	Результат = Истина;
	Для Каждого Задача Из МассивЗадач Цикл
		
		ЗадачаВыполнена = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Задача.Ссылка, "Выполнена");
		Если ЗадачаВыполнена Тогда
			Результат = Ложь;
			Если ТолькоПроверка Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;	
		
		Если ТолькоПроверка Тогда
			Продолжить;
		КонецЕсли;	
		
		Если НЕ ЗначениеЗаполнено(МассивПеренаправленныхЗадач) Тогда
			МассивПеренаправленныхЗадач = Новый Массив();
		КонецЕсли;
		
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Задача.ЗадачаИсполнителя");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Задача.Ссылка);
			Блокировка.Заблокировать();
							
			// Не устанавливаем объектную блокировку на задачу Задача для того, чтобы 
			// позволить выполнять перенаправление по команде из формы этой задачи.
			ЗадачаОбъект = Задача.Ссылка.ПолучитьОбъект();
			
			УстановитьПривилегированныйРежим(Истина);
			НоваяЗадача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
			НоваяЗадача.Заполнить(ЗадачаОбъект);
			ЗаполнитьЗначенияСвойств(НоваяЗадача, ИнфоОПеренаправлении, 
				"Исполнитель,РольИсполнителя,ОсновнойОбъектАдресации,ДополнительныйОбъектАдресации");
			НоваяЗадача.Записать();
			УстановитьПривилегированныйРежим(Ложь);
		
			МассивПеренаправленныхЗадач.Добавить(НоваяЗадача.Ссылка);
			
			ЗадачаОбъект.РезультатВыполнения = ИнфоОПеренаправлении.Комментарий; 
			ЗадачаОбъект.Выполнена = Ложь;
			ЗадачаОбъект.ВыполнитьЗадачу();
		
			ПриПеренаправленииЗадачи(ЗадачаОбъект, НоваяЗадача);
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ЗаписьЖурналаРегистрации(БизнесПроцессыИЗадачиСервер.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,,, 
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Отмечает указанные бизнес-процессы как активные
//
Процедура СделатьАктивнымБизнесПроцессы(БизнесПроцессы) Экспорт
	
	НачатьТранзакцию();
	Попытка
		
		Для каждого БизнесПроцесс Из БизнесПроцессы Цикл
			
			Если ТипЗнч(БизнесПроцесс) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				Продолжить;
			КонецЕсли;	
			
			СделатьАктивнымБизнесПроцесс(БизнесПроцесс);
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(БизнесПроцессыИЗадачиСервер.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
 		ВызватьИсключение;		
	КонецПопытки;	
	
КонецПроцедуры	

// Отмечает указанный бизнес-процесс как активный
//
Процедура СделатьАктивнымБизнесПроцесс(БизнесПроцесс) Экспорт
	
	Если ТипЗнч(БизнесПроцесс) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	Объект = БизнесПроцесс.ПолучитьОбъект();
	
	Если Объект.Состояние = Перечисления.СостоянияБизнесПроцессов.Активен Тогда
		
		Если Объект.Завершен Тогда
			ВызватьИсключение НСтр("ru = 'Невозможно сделать активными завершенные бизнес-процессы.'");
		КонецЕсли;
			
		Если Не Объект.Стартован Тогда
			ВызватьИсключение НСтр("ru = 'Невозможно сделать активными не стартовавшие бизнес-процессы.'");
		КонецЕсли;
		
		ВызватьИсключение НСтр("ru = 'Бизнес-процесс уже активен.'");
	КонецЕсли;
		
	Объект.Заблокировать();
	Объект.Состояние = Перечисления.СостоянияБизнесПроцессов.Активен;
	Объект.Записать();
	
КонецПроцедуры

// Отмечает указанные бизнес-процессы как остановленные
//
Процедура ОстановитьБизнесПроцессы(БизнесПроцессы) Экспорт
	
	НачатьТранзакцию();
	Попытка 
		Для каждого БизнесПроцесс Из БизнесПроцессы Цикл
			
			Если ТипЗнч(БизнесПроцесс) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				Продолжить;
			КонецЕсли;	
			
			ОстановитьБизнесПроцесс(БизнесПроцесс);
			
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(БизнесПроцессыИЗадачиСервер.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;		
	КонецПопытки;	
	
КонецПроцедуры	

// Отмечает указанный бизнес-процесс как остановленный
//
Процедура ОстановитьБизнесПроцесс(БизнесПроцесс) Экспорт
	
	Если ТипЗнч(БизнесПроцесс) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	Объект = БизнесПроцесс.ПолучитьОбъект();
	
	Если Объект.Состояние = Перечисления.СостоянияБизнесПроцессов.Остановлен Тогда
		
		Если Объект.Завершен Тогда
			ВызватьИсключение НСтр("ru = 'Невозможно остановить завершенные бизнес-процессы.'");
		КонецЕсли;
			
		Если Не Объект.Стартован Тогда
			ВызватьИсключение НСтр("ru = 'Невозможно остановить не стартовавшие бизнес-процессы.'");
		КонецЕсли;
		
		ВызватьИсключение НСтр("ru = 'Бизнес-процесс уже остановлен.'");
	КонецЕсли;
	
	Объект.Заблокировать();
	Объект.Состояние = Перечисления.СостоянияБизнесПроцессов.Остановлен;
	Объект.Записать();
	
КонецПроцедуры

// Отмечает указанные задачи как принятые к исполнению
//
Процедура ПринятьЗадачиКИсполнению(Задачи) Экспорт
	
	НовыйМассивЗадач = Новый Массив();
	
	НачатьТранзакцию();
	Попытка
		Для каждого Задача Из Задачи Цикл
			Если ТипЗнч(Задача) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда 
				ЗадачаОбъект = Задача.ПолучитьОбъект();
				ЗадачаОбъект.Заблокировать();
				ЗадачаОбъект.ПринятаКИсполнению = Истина;
				ЗадачаОбъект.ДатаПринятияКИсполнению = ТекущаяДатаСеанса();
				Если ЗадачаОбъект.Исполнитель.Пустая() Тогда
					ЗадачаОбъект.Исполнитель = Пользователи.ТекущийПользователь();
				КонецЕсли;
				ЗадачаОбъект.Записать();
				
				НовыйМассивЗадач.Добавить(Задача);
			КонецЕсли;
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(БизнесПроцессыИЗадачиСервер.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
	Задачи = НовыйМассивЗадач;
	
КонецПроцедуры

// Отмечает указанные задачи как не принятые к исполнению
//
Процедура ОтменитьПринятиеЗадачКИсполнению(Задачи) Экспорт
	
	НовыйМассивЗадач = Новый Массив();
	
	НачатьТранзакцию();
	Попытка
		Для каждого Задача Из Задачи Цикл
			Если ТипЗнч(Задача) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда 
				ЗадачаОбъект = Задача.ПолучитьОбъект();
				ЗадачаОбъект.Заблокировать();
				ЗадачаОбъект.ПринятаКИсполнению = Ложь;
				ЗадачаОбъект.ДатаПринятияКИсполнению = "00010101000000";
				Если Не ЗадачаОбъект.РольИсполнителя.Пустая() Тогда
					ЗадачаОбъект.Исполнитель = Справочники.Пользователи.ПустаяСсылка();
				КонецЕсли;	
				ЗадачаОбъект.Записать();
				
				НовыйМассивЗадач.Добавить(Задача);
			КонецЕсли;	
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(БизнесПроцессыИЗадачиСервер.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;		
	КонецПопытки;	
	
	Задачи = НовыйМассивЗадач;
	
КонецПроцедуры

// Проверяет, является ли указанная задача ведущей.
//
// Параметры
//  ЗадачаСсылка  - задача.
//
// Возвращаемое значение:
//   Булево
//
Функция ЭтоВедущаяЗадача(ЗадачаСсылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = БизнесПроцессыИЗадачиСервер.ВыбратьБизнесПроцессыВедущейЗадачи(ЗадачаСсылка);
	Возврат НЕ Результат.Пустой();
		
КонецФункции	

// Обработчик регламентного задания УведомлениеИсполнителейОНовыхЗадачах.
//
Процедура УведомитьИсполнителейОНовыхЗадачах() Экспорт
	
	// При выполнении в регламентном задании переходим безусловно в привилегированный режим.
	Если ПустаяСтрока(ИмяПользователя()) Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	// Получаем текущее время компьютера сервера - ТекушаяДата()
	ДатаУведомления = ТекущаяДата();
	УстановитьПривилегированныйРежим(Истина);
	ДатаПоследнегоУведомления = Константы.ДатаУведомленияОНовыхЗадачах.Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	// Если оповещение ранее не производилось, или последнее оповещение происходило
	// ранее, чем за сутки, то отбираем новые задачи за последние сутки.
	Если (ДатаПоследнегоУведомления = '00010101000000') 
		Или (ДатаУведомления - ДатаПоследнегоУведомления > 24*60*60) Тогда
		ДатаПоследнегоУведомления = ДатаУведомления - 24*60*60;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(БизнесПроцессыИЗадачиСервер.СобытиеЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Информация, , ,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Начато регламентное уведомление о новых задачах за период %1 - %2'"),
			ДатаПоследнегоУведомления, ДатаУведомления));
			
	ЗадачиПоИсполнителям = ВыбратьНовыеЗадачиПоИсполнителям(ДатаПоследнегоУведомления, ДатаУведомления);
	Для Каждого СтрокаИсполнителя Из ЗадачиПоИсполнителям.Строки Цикл
		ОтправитьУведомлениеОНовыхЗадачах(СтрокаИсполнителя.Исполнитель, СтрокаИсполнителя);
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	Константы.ДатаУведомленияОНовыхЗадачах.Установить(ДатаУведомления);
	УстановитьПривилегированныйРежим(Ложь);
	
	ЗаписьЖурналаРегистрации(БизнесПроцессыИЗадачиСервер.СобытиеЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Информация, , ,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Завершено регламентное уведомление о новых задачах (уведомлено исполнителей: %1)'"),
			ЗадачиПоИсполнителям.Строки.Количество()));
	
КонецПроцедуры

// Обработчик регламентного задания МониторингЗадач.
//
Процедура ПроконтролироватьЗадачи() Экспорт
	
	// При выполнении в регламентном задании переходим безусловно в привилегированный режим.
	Если ПустаяСтрока(ИмяПользователя()) Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	ПросроченныеЗадачи = ВыбратьПросроченныеЗадачи();
	Если ПросроченныеЗадачи.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
		
	НаборПисемПоАдресатам = Новый ТаблицаЗначений;
	НаборПисемПоАдресатам.Колонки.Добавить("ПочтовыйАдрес");
	НаборПисемПоАдресатам.Колонки.Добавить("ТекстПисьма");
	НаборПисемПоАдресатам.Колонки.Добавить("КоличествоЗадач");
	НаборПисемПоАдресатам.Колонки.Добавить("ТипПисьма");
	НаборПисемПоАдресатам.Колонки.Добавить("Получатель");
	
	Для Каждого ЭлементПросроченныеЗадачи Из ПросроченныеЗадачи Цикл
		ПросроченнаяЗадача = ЭлементПросроченныеЗадачи.Ссылка;
		
		ТекстПисьма = СформироватьПредставлениеЗадачи(ЭлементПросроченныеЗадачи);
		// Задача адресована лично исполнителю?
		Если ЗначениеЗаполнено(ПросроченнаяЗадача.Исполнитель) Тогда
			ПолучательПисьма = "";
			СтандартныеПодсистемыПереопределяемый.ПолучитьАдресЭлектроннойПочты(ПросроченнаяЗадача.Исполнитель, ПолучательПисьма);
			НайтиПисьмоИДобавитьТекст(НаборПисемПоАдресатам, ПолучательПисьма, ПросроченнаяЗадача.Исполнитель, ТекстПисьма, "Исполнителю");
			ПолучательПисьма = "";
			СтандартныеПодсистемыПереопределяемый.ПолучитьАдресЭлектроннойПочты(ПросроченнаяЗадача.Автор, ПолучательПисьма);
			НайтиПисьмоИДобавитьТекст(НаборПисемПоАдресатам, ПолучательПисьма, ПросроченнаяЗадача.Автор, ТекстПисьма, "Автору");
		Иначе
			Исполнители = ВыбратьИсполнителейЗадач(ПросроченнаяЗадача);
			Координаторы = НайтиОтветственныхЗаНазначениеРолей(ПросроченнаяЗадача);
			// Есть хотя бы один исполнитель для измерений ролевой адресации задачи?
			Если Исполнители.Количество() > 0 Тогда
				// Исполнитель не выполняет свои задачи.
				Для Каждого Исполнитель Из Исполнители Цикл
					ПолучательПисьма = "";
					СтандартныеПодсистемыПереопределяемый.ПолучитьАдресЭлектроннойПочты(Исполнитель.Исполнитель, ПолучательПисьма);
					НайтиПисьмоИДобавитьТекст(НаборПисемПоАдресатам, ПолучательПисьма, Исполнитель.Исполнитель, ТекстПисьма, "Исполнителю");
				КонецЦикла;
			Иначе	// Задачу исполнять некому.
				СоздатьЗадачуПоНастройкеРолей(ПросроченнаяЗадача, Координаторы);
			КонецЕсли;
			
			Для Каждого Координатор Из Координаторы Цикл
				ПолучательПисьма = "";
				СтандартныеПодсистемыПереопределяемый.ПолучитьАдресЭлектроннойПочты(Координатор, ПолучательПисьма);
				НайтиПисьмоИДобавитьТекст(НаборПисемПоАдресатам, ПолучательПисьма, Координатор, ТекстПисьма, "Координатору");
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ПисьмоИзНабора Из НаборПисемПоАдресатам Цикл
		
		Если ПустаяСтрока(ПисьмоИзНабора.ПочтовыйАдрес) Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Уведомление не было отправлено, так как у пользователя %1 не задан адрес электронной почты.'"), 
				ПисьмоИзНабора.Получатель);
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Бизнес-процессы и задачи.Уведомление о просроченных задачах'"), 
				УровеньЖурналаРегистрации.Информация,,, ТекстСообщения);
			Продолжить;
		КонецЕсли;
		
		ПараметрыПисьма = Новый Структура;
		ПараметрыПисьма.Вставить("Кому", ПисьмоИзНабора.ПочтовыйАдрес);
		Если ПисьмоИзНабора.ТипПисьма = "Исполнителю" Тогда
			ТекстТелаПисьма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'У Вас имеются не выполненные в срок задачи:
					| 
					|%1'"), ПисьмоИзНабора.ТекстПисьма);
			ПараметрыПисьма.Вставить("Тело", ТекстТелаПисьма);
			
			ТекстТемыПисьма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'У Вас имеются не выполненные в срок задачи (%1)'"),
				Строка(ПисьмоИзНабора.КоличествоЗадач ));
			ПараметрыПисьма.Вставить("Тема", ТекстТемыПисьма);
		ИначеЕсли ПисьмоИзНабора.ТипПисьма = "Автору" Тогда
			ТекстТелаПисьма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'По созданным Вами задачам прошел крайний срок:
				   | 
				   |%1'"), ПисьмоИзНабора.ТекстПисьма);
			ПараметрыПисьма.Вставить("Тело", ТекстТелаПисьма);
			
			ТекстТемыПисьма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'По Вашим задачам истек контрольный срок (%1)'"),
				Строка(ПисьмоИзНабора.КоличествоЗадач));
			ПараметрыПисьма.Вставить("Тема", ТекстТемыПисьма);
		ИначеЕсли ПисьмоИзНабора.ТипПисьма = "Координатору" Тогда
			ТекстТелаПисьма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				 НСтр("ru = 'Прошел крайний срок по задачам:
					| 
					|%1'"), ПисьмоИзНабора.ТекстПисьма);
			ПараметрыПисьма.Вставить("Тело", ТекстТелаПисьма);
			
			ТекстТемыПисьма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Истек контрольный срок задач (%1)'"),
				Строка(ПисьмоИзНабора.КоличествоЗадач));
			ПараметрыПисьма.Вставить("Тема", ТекстТемыПисьма);
		КонецЕсли;
		
		ТекстСообщения = "";
		
		Попытка
			РаботаСПочтовымиСообщениями.ОтправитьСообщение(
				РаботаСПочтовымиСообщениями.ПолучитьСистемнуюУчетнуюЗапись(), ПараметрыПисьма);
		Исключение
			ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при отправке уведомления о просроченных задачах: %1.'"),
				ОписаниеОшибки);
			УровеньВажностиСобытия = УровеньЖурналаРегистрации.Ошибка;
		КонецПопытки;
		
		Если ПустаяСтрока(ТекстСообщения) Тогда
			Если ПараметрыПисьма.Кому.Количество() > 0 Тогда
				Кому = ? (ПустаяСтрока(ПараметрыПисьма.Кому[0].Представление),
							ПараметрыПисьма.Кому[0].Адрес,
							ПараметрыПисьма.Кому[0].Представление + " <"+ПараметрыПисьма.Кому[0].Адрес+">");
			КонецЕсли;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'Уведомление о просроченных задачах успешно отправлено на адрес %1.'"),
								Кому);
								
			УровеньВажностиСобытия = УровеньЖурналаРегистрации.Информация;
		КонецЕсли;
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Бизнес-процессы и задачи.Уведомление о просроченных задачах'"), 
			УровеньВажностиСобытия,,, ТекстСообщения);
	КонецЦикла;
	
КонецПроцедуры

// Формирует список подбора для указания исполнителя в полях 
// ввода составного типа (Пользователь и Роль)
Функция СформироватьДанныеВыбораИсполнителя(Текст) Экспорт
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Пользователи.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.Наименование ПОДОБНО &Текст
	|	И Пользователи.Недействителен = ЛОЖЬ
	|	И Пользователи.Служебный = ЛОЖЬ
	|	И Пользователи.ПометкаУдаления = ЛОЖЬ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РолиИсполнителей.Ссылка
	|ИЗ
	|	Справочник.РолиИсполнителей КАК РолиИсполнителей
	|ГДЕ
	|	РолиИсполнителей.Наименование ПОДОБНО &Текст
	|	И НЕ РолиИсполнителей.ПометкаУдаления";
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Мониторинг и контроль исполнения 

Функция ВыгрузитьИсполнителей(ТекстЗапроса, ОсновнойОбъектАдресацииСсылка, ДопОбъектАдресацииСсылка)
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Если ЗначениеЗаполнено(ДопОбъектАдресацииСсылка) Тогда
		Запрос.УстановитьПараметр("ДОА", ДопОбъектАдресацииСсылка);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОсновнойОбъектАдресацииСсылка) Тогда
		Запрос.УстановитьПараметр("ООА", ОсновнойОбъектАдресацииСсылка);
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция НайтиИсполнителейПоРолям(Знач Задача, Знач БазовыйТекстЗапроса)
	
	СписокПользователей = Новый Массив;
	
	ООА = Задача.ОсновнойОбъектАдресации;
	ДОА = Задача.ДополнительныйОбъектАдресации;
	
	Если ЗначениеЗаполнено(ДОА) Тогда
		ТекстЗапроса = БазовыйТекстЗапроса + " И ИсполнителиЗадач.ОсновнойОбъектАдресации = &ООА
		                                     |И ИсполнителиЗадач.ДополнительныйОбъектАдресации = &ДОА";
	ИначеЕсли ЗначениеЗаполнено(ООА) Тогда
		ТекстЗапроса = БазовыйТекстЗапроса + 
			" И ИсполнителиЗадач.ОсновнойОбъектАдресации = &ООА
		    |И (ИсполнителиЗадач.ДополнительныйОбъектАдресации = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ОбъектыАдресацииЗадач.ПустаяСсылка)
			|   ИЛИ ИсполнителиЗадач.ДополнительныйОбъектАдресации = Неопределено)";
	Иначе
		ТекстЗапроса = БазовыйТекстЗапроса + 
			" И (ИсполнителиЗадач.ОсновнойОбъектАдресации = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ОбъектыАдресацииЗадач.ПустаяСсылка)
			|    ИЛИ ИсполнителиЗадач.ОсновнойОбъектАдресации = Неопределено)
		    |И (ИсполнителиЗадач.ДополнительныйОбъектАдресации = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ОбъектыАдресацииЗадач.ПустаяСсылка)
			|   ИЛИ ИсполнителиЗадач.ДополнительныйОбъектАдресации = Неопределено)";
	КонецЕсли;
	
	ВыгрузкаИсполнителей = ВыгрузитьИсполнителей(ТекстЗапроса, ООА, ДОА);
	
	// Если в задаче не заполнены основной и дополнительный объекты адресации
	Если Не ЗначениеЗаполнено(ДОА) И Не ЗначениеЗаполнено(ООА) Тогда
		Для Каждого ЭлементВыгрузки Из ВыгрузкаИсполнителей Цикл
			СписокПользователей.Добавить(ЭлементВыгрузки.Исполнитель);
		КонецЦикла;
		
		Возврат СписокПользователей;
	КонецЕсли;
	
	Если ВыгрузкаИсполнителей.Количество() = 0 И ЗначениеЗаполнено(ДОА) Тогда
		ТекстЗапроса = БазовыйТекстЗапроса + " И ИсполнителиЗадач.ОсновнойОбъектАдресации = &ООА
			|И (ИсполнителиЗадач.ДополнительныйОбъектАдресации = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ОбъектыАдресацииЗадач.ПустаяСсылка)
			|   ИЛИ ИсполнителиЗадач.ДополнительныйОбъектАдресации = Неопределено)";
		ВыгрузкаИсполнителей = ВыгрузитьИсполнителей(ТекстЗапроса, ООА, Неопределено);
	КонецЕсли;
	
	Если ВыгрузкаИсполнителей.Количество() = 0 Тогда
		ТекстЗапроса = БазовыйТекстЗапроса + " И (ИсполнителиЗадач.ОсновнойОбъектАдресации = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ОбъектыАдресацииЗадач.ПустаяСсылка)
			|    ИЛИ ИсполнителиЗадач.ОсновнойОбъектАдресации = Неопределено)
			|И (ИсполнителиЗадач.ДополнительныйОбъектАдресации = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ОбъектыАдресацииЗадач.ПустаяСсылка)
			|   ИЛИ ИсполнителиЗадач.ДополнительныйОбъектАдресации = Неопределено)";
		ВыгрузкаИсполнителей = ВыгрузитьИсполнителей(ТекстЗапроса, Неопределено, Неопределено);
	КонецЕсли;
	
	Для Каждого ЭлементВыгрузки Из ВыгрузкаИсполнителей Цикл
		СписокПользователей.Добавить(ЭлементВыгрузки.Исполнитель);
	КонецЦикла;
	
	Возврат СписокПользователей;
	
КонецФункции

Функция НайтиОтветственныхЗаНазначениеРолей(Знач Задача)
	
	БазовыйТекстЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ ИсполнителиЗадач.Исполнитель
	                      |ИЗ
	                      |	РегистрСведений.ИсполнителиЗадач Как ИсполнителиЗадач, Справочник.РолиИсполнителей Как РолиИсполнителей
	                      |Где
	                      |	ИсполнителиЗадач.РольИсполнителя = РолиИсполнителей.Ссылка
	                      |И
	                      |	РолиИсполнителей.Ссылка = ЗНАЧЕНИЕ(Справочник.РолиИсполнителей.ОтветственныйЗаКонтрольИсполнения)";
						  
	Ответственные = НайтиИсполнителейПоРолям(Задача, БазовыйТекстЗапроса);
	Возврат Ответственные;
	
КонецФункции

Функция ВыбратьИсполнителейЗадач(Знач Задача)
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
				  |	ИсполнителиЗадач.Исполнитель КАК Исполнитель
				  |ИЗ
				  |	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
				  |ГДЕ
				  |	ИсполнителиЗадач.РольИсполнителя = &РольИсполнителя
				  |	И ИсполнителиЗадач.ОсновнойОбъектАдресации = &ОсновнойОбъектАдресации
				  |	И ИсполнителиЗадач.ДополнительныйОбъектАдресации = &ДополнительныйОбъектАдресации";
				  
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.Параметры.Вставить("РольИсполнителя", Задача.РольИсполнителя);
	Запрос.Параметры.Вставить("ОсновнойОбъектАдресации", Задача.ОсновнойОбъектАдресации);
	Запрос.Параметры.Вставить("ДополнительныйОбъектАдресации", Задача.ДополнительныйОбъектАдресации);
	Исполнители = Запрос.Выполнить().Выгрузить();
	Возврат Исполнители;
	
КонецФункции

Процедура НайтиПисьмоИДобавитьТекст(Знач НаборПисемПоАдресатам,
                                  Знач ПолучательПисьма,
                                  Знач ПредставлениеПолучателяПисьма,
                                  Знач ТекстПисьма,
                                  Знач ТипПисьма)
	
	ПараметрыОтбора = Новый Структура("ТипПисьма, ПочтовыйАдрес", ТипПисьма, ПолучательПисьма);
	СтрокаПараметрыПисьма = НаборПисемПоАдресатам.НайтиСтроки(ПараметрыОтбора);
	Если СтрокаПараметрыПисьма.Количество() = 0 Тогда
		СтрокаПараметрыПисьма = Неопределено;
	Иначе
		СтрокаПараметрыПисьма = СтрокаПараметрыПисьма[0];
	КонецЕсли;
	
	Если СтрокаПараметрыПисьма = Неопределено Тогда
		СтрокаПараметрыПисьма = НаборПисемПоАдресатам.Добавить();
		СтрокаПараметрыПисьма.ПочтовыйАдрес = ПолучательПисьма;
		СтрокаПараметрыПисьма.ТекстПисьма = "";
		СтрокаПараметрыПисьма.КоличествоЗадач = 0;
		СтрокаПараметрыПисьма.ТипПисьма = ТипПисьма;
		СтрокаПараметрыПисьма.Получатель = ПредставлениеПолучателяПисьма;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтрокаПараметрыПисьма.ТекстПисьма) Тогда
		СтрокаПараметрыПисьма.ТекстПисьма =
		        СтрокаПараметрыПисьма.ТекстПисьма + Символы.ПС
		        + "------------------------------------"  + Символы.ПС;
	КонецЕсли;
	
	СтрокаПараметрыПисьма.КоличествоЗадач = СтрокаПараметрыПисьма.КоличествоЗадач + 1;
	СтрокаПараметрыПисьма.ТекстПисьма = СтрокаПараметрыПисьма.ТекстПисьма + ТекстПисьма;
	
КонецПроцедуры

Функция ВыбратьПросроченныеЗадачи()
	
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗадачаИсполнителя.Ссылка КАК Ссылка,
		|	ЗадачаИсполнителя.СрокИсполнения КАК СрокИсполнения,
		|	ЗадачаИсполнителя.Исполнитель КАК Исполнитель,
		|	ЗадачаИсполнителя.РольИсполнителя КАК РольИсполнителя,
		|	ЗадачаИсполнителя.ОсновнойОбъектАдресации КАК ОсновнойОбъектАдресации,
		|	ЗадачаИсполнителя.ДополнительныйОбъектАдресации КАК ДополнительныйОбъектАдресации,
		|	ЗадачаИсполнителя.Автор КАК Автор,
		|	ЗадачаИсполнителя.Описание КАК Описание
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|ГДЕ
		|	ЗадачаИсполнителя.ПометкаУдаления = ЛОЖЬ
		|	И ЗадачаИсполнителя.Выполнена = ЛОЖЬ
		|	И ЗадачаИсполнителя.СрокИсполнения <= &Дата
		|	И ЗадачаИсполнителя.СостояниеБизнесПроцесса <> ЗНАЧЕНИЕ(Перечисление.СостоянияБизнесПроцессов.Остановлен)";
	
	СрокИсполнения = КонецДня(ТекущаяДатаСеанса());

	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Дата", СрокИсполнения);
	
	ПросроченныеЗадачи = Запрос.Выполнить().Выгрузить();
	Возврат ПросроченныеЗадачи;
	
КонецФункции

Функция СоздатьЗадачуПоНастройкеРолей(ЗадачаСсылка, Ответственные)
	
	Для Каждого Ответственный Из Ответственные Цикл
		ЗадачаОбъект = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
		ЗадачаОбъект.Дата = ТекущаяДатаСеанса();
		ЗадачаОбъект.Важность = Перечисления.ВариантыВажностиЗадачи.Высокая;
		ЗадачаОбъект.Исполнитель = Ответственный;
		ЗадачаОбъект.Предмет = ЗадачаСсылка;

		ЗадачаОбъект.Описание =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		  НСтр("ru = 'Задача не может быть исполнена, так как у роли не задано ни одного исполнителя:
		             |%1'"), Строка(ЗадачаСсылка));
		
		ЗадачаОбъект.Наименование =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		  НСтр("ru = 'Назначить исполнителей: задача не может быть исполнена %1'"), Строка(ЗадачаСсылка));
		
		ЗадачаОбъект.Записать();
	КонецЦикла;
	
КонецФункции

Функция ВыбратьНовыеЗадачиПоИсполнителям(Знач ДатаВремяОт, Знач ДатаВремяПо)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗадачаИсполнителя.Ссылка КАК Ссылка,
		|	ЗадачаИсполнителя.Номер КАК Номер,
		|	ЗадачаИсполнителя.Дата КАК Дата,
		|	ЗадачаИсполнителя.Наименование КАК Наименование,
		|	ЗадачаИсполнителя.СрокИсполнения КАК СрокИсполнения,
		|	ЗадачаИсполнителя.Автор КАК Автор,
		|	ПОДСТРОКА(ЗадачаИсполнителя.Описание, 1, 250) КАК Описание,
		|	ВЫБОР
		|		КОГДА ЗадачаИсполнителя.Исполнитель ЕСТЬ НЕ NULL 
		|				И ЗадачаИсполнителя.Исполнитель <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
		|			ТОГДА ЗадачаИсполнителя.Исполнитель
		|		ИНАЧЕ ИсполнителиЗадач.Исполнитель
		|	КОНЕЦ КАК Исполнитель,
		|	ЗадачаИсполнителя.РольИсполнителя КАК РольИсполнителя,
		|	ЗадачаИсполнителя.ОсновнойОбъектАдресации КАК ОсновнойОбъектАдресации,
		|	ЗадачаИсполнителя.ДополнительныйОбъектАдресации КАК ДополнительныйОбъектАдресации
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
		|		ПО ЗадачаИсполнителя.РольИсполнителя = ИсполнителиЗадач.РольИсполнителя
		|			И ЗадачаИсполнителя.ОсновнойОбъектАдресации = ИсполнителиЗадач.ОсновнойОбъектАдресации
		|			И ЗадачаИсполнителя.ДополнительныйОбъектАдресации = ИсполнителиЗадач.ДополнительныйОбъектАдресации
		|ГДЕ
		|	ЗадачаИсполнителя.ПометкаУдаления = ЛОЖЬ
		|	И ЗадачаИсполнителя.Дата > &ДатаВремяОт
		|	И ЗадачаИсполнителя.Дата <= &ДатаВремяПо
		|	И (ЗадачаИсполнителя.Исполнитель ЕСТЬ НЕ NULL 
		|				И ЗадачаИсполнителя.Исполнитель <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
		|			ИЛИ ИсполнителиЗадач.Исполнитель ЕСТЬ НЕ NULL 
		|				И ИсполнителиЗадач.Исполнитель <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка))
		|	И ЗадачаИсполнителя.Выполнена = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Исполнитель,
		|	СрокИсполнения УБЫВ
		|ИТОГИ ПО
		|	Исполнитель");
	Запрос.Параметры.Вставить("ДатаВремяОт", ДатаВремяОт);
	Запрос.Параметры.Вставить("ДатаВремяПо", ДатаВремяПо);
	Результат = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	Возврат Результат;
	
КонецФункции

Функция ОтправитьУведомлениеОНовыхЗадачах(Исполнитель, ЗадачиПоИсполнителю)
	
	ПочтовыйАдресПолучателя = "";
	СтандартныеПодсистемыПереопределяемый.ПолучитьАдресЭлектроннойПочты(Исполнитель, ПочтовыйАдресПолучателя);
	Если ПустаяСтрока(ПочтовыйАдресПолучателя) Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Бизнес-процессы и задачи.Уведомление о новых задачах'"), 
			УровеньЖурналаРегистрации.Информация,,,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Уведомление не отправлено, так как не указан почтовый адрес у пользователя %1.'"), Строка(Исполнитель)));
		Возврат Ложь;
	КонецЕсли;
	
	ТекстПисьма = "";
	Для Каждого СтрокаЗадача Из ЗадачиПоИсполнителю.Строки Цикл
		Для Каждого Задача Из СтрокаЗадача.Строки Цикл
			ТекстПисьма = ТекстПисьма + СформироватьПредставлениеЗадачи(Задача);
		КонецЦикла;
	КонецЦикла;
	ТемаПисьма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		  НСтр("ru = 'Вам направлены задачи - %1'"), Метаданные.КраткаяИнформация);
	
	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Тема", ТемаПисьма);
	ПараметрыПисьма.Вставить("Тело", ТекстПисьма);
	ПараметрыПисьма.Вставить("Кому", ПочтовыйАдресПолучателя);
	
	Попытка 
		РаботаСПочтовымиСообщениями.ОтправитьСообщение(
			РаботаСПочтовымиСообщениями.ПолучитьСистемнуюУчетнуюЗапись(), ПараметрыПисьма);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Бизнес-процессы и задачи.Уведомление о новых задачах'"), 
			УровеньЖурналаРегистрации.Ошибка,,,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			   НСтр("ru = 'Ошибка при отправке уведомления о новых задачах: %1'"), 
			   ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
		Возврат Ложь;
	КонецПопытки;

	ЗаписьЖурналаРегистрации(НСтр("ru = 'Бизнес-процессы и задачи.Уведомление о новых задачах'"), 
		УровеньЖурналаРегистрации.Информация,,,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Уведомления успешно отправлены на адрес %1.'"), ПочтовыйАдресПолучателя));
	Возврат Истина;	
		
КонецФункции

Функция СформироватьПредставлениеЗадачи(ЗадачаСтруктура)
	
	ШаблонСтроки = 
		НСтр("ru = '%1
		|
		|Крайний срок: %2'") + Символы.ПС;
	Если ЗначениеЗаполнено(ЗадачаСтруктура.Исполнитель) Тогда
		ШаблонСтроки = ШаблонСтроки + НСтр("ru = 'Исполнитель: %3'") + Символы.ПС;
	КонецЕсли;
	Если ЗначениеЗаполнено(ЗадачаСтруктура.РольИсполнителя) Тогда
		ШаблонСтроки = ШаблонСтроки + НСтр("ru = 'Роль: %4'") + Символы.ПС;
	КонецЕсли;
	Если ЗначениеЗаполнено(ЗадачаСтруктура.ОсновнойОбъектАдресации) Тогда
		ШаблонСтроки = ШаблонСтроки + НСтр("ru = 'Основной объект адресации: %5'") + Символы.ПС;
	КонецЕсли;
	Если ЗначениеЗаполнено(ЗадачаСтруктура.ДополнительныйОбъектАдресации) Тогда
		ШаблонСтроки = ШаблонСтроки + НСтр("ru = 'Доп. объект адресации: %6'") + Символы.ПС;
	КонецЕсли;
	Если ЗначениеЗаполнено(ЗадачаСтруктура.Автор) Тогда
		ШаблонСтроки = ШаблонСтроки + НСтр("ru = 'Автор: %7'") + Символы.ПС;
	КонецЕсли;
	Если ЗначениеЗаполнено(ЗадачаСтруктура.Описание) Тогда
		ШаблонСтроки = ШаблонСтроки + Символы.ПС + НСтр("ru = '%8'") + Символы.ПС;
	КонецЕсли;
	ШаблонСтроки = ШаблонСтроки + Символы.ПС;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСтроки,
		ЗадачаСтруктура.Ссылка, 
		Формат(ЗадачаСтруктура.СрокИсполнения, "ДЛФ=DD; ДП='не указан'"), ЗадачаСтруктура.Исполнитель,
		ЗадачаСтруктура.РольИсполнителя, ЗадачаСтруктура.ОсновнойОбъектАдресации, 
		ЗадачаСтруктура.ДополнительныйОбъектАдресации, ЗадачаСтруктура.Автор,
		ЗадачаСтруктура.Описание);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Прочие служебные процедуры и функции

// Возвращает число невыполненных задач по указанным бизнес-процессам
//
Функция КоличествоНевыполненныхЗадачБизнесПроцессов(БизнесПроцессы) Экспорт
	
	КоличествоЗадач = 0;
	
	Для каждого БизнесПроцесс Из БизнесПроцессы Цикл
		
		Если ТипЗнч(БизнесПроцесс) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		КоличествоЗадач = КоличествоЗадач + КоличествоНевыполненныхЗадачБизнесПроцесса(БизнесПроцесс);
		
	КонецЦикла;
		
	Возврат КоличествоЗадач;
	
КонецФункции	

// Возвращает число невыполненных задач по указанному бизнес-процессу
//
Функция КоличествоНевыполненныхЗадачБизнесПроцесса(БизнесПроцесс) Экспорт
	
	Если ТипЗнч(БизнесПроцесс) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат 0;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	КОЛИЧЕСТВО(*) КАК Количество
	               |ИЗ
	               |	Задача.ЗадачаИсполнителя КАК Задачи
	               |ГДЕ
	               |	Задачи.БизнесПроцесс = &БизнесПроцесс
	               |	И Задачи.Выполнена = Ложь";
				   
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс);			   
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Количество;
	
КонецФункции

// Помечает на удаление указанные бизнес-процессы
//
Функция ПометитьНаУдалениеБизнесПроцессы(ВыделенныеСтроки) Экспорт
	Количество = 0;
	Для Каждого СтрокаТаблицы Из ВыделенныеСтроки Цикл
		БизнесПроцессСсылка = СтрокаТаблицы.БизнесПроцесс;
		Если БизнесПроцессСсылка = Неопределено ИЛИ БизнесПроцессСсылка.Пустая() Тогда
			Продолжить;
		КонецЕсли;	
		БизнесПроцессОбъект = БизнесПроцессСсылка.ПолучитьОбъект();
		БизнесПроцессОбъект.УстановитьПометкуУдаления(НЕ БизнесПроцессОбъект.ПометкаУдаления);
		Количество = Количество + 1;
	КонецЦикла;
	Возврат ?(Количество = 1, ВыделенныеСтроки[0].БизнесПроцесс, Неопределено);
КонецФункции

Процедура ПриПеренаправленииЗадачи(ЗадачаОбъект, НоваяЗадачаОбъект) 
	
	Если ЗадачаОбъект.БизнесПроцесс = Неопределено ИЛИ ЗадачаОбъект.БизнесПроцесс.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ТипБизнесПроцесса = ЗадачаОбъект.БизнесПроцесс.Метаданные();
	Попытка
		БизнесПроцессы[ТипБизнесПроцесса.Имя].ПриПеренаправленииЗадачи(ЗадачаОбъект.Ссылка, НоваяЗадачаОбъект.Ссылка);
	Исключение
		// метод не определен
	КонецПопытки;
	
КонецПроцедуры

// Возвращает Истина, если задача соответствует указанной точке маршрута
Функция ПроверитьТипЗадачи(ЗадачаОбъект, ТочкаМаршрута) Экспорт
	
	Возврат ЗадачаОбъект.ТочкаМаршрута = ТочкаМаршрута;
	
КонецФункции

