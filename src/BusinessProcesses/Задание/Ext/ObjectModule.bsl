﻿////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Актуализирует значения реквизит невыполненных задач 
// согласно реквизитам бизнес-процесса Задание:
//   Важность, СрокИсполнения, Наименование и Автор
//
Процедура ИзменитьРеквизитыНевыполненныхЗадач() Экспорт

	НачатьТранзакцию();
	Попытка
		Запрос = Новый Запрос( 
			"ВЫБРАТЬ
			|	Задачи.Ссылка КАК Ссылка
			|ИЗ
			|	Задача.ЗадачаИсполнителя КАК Задачи
			|ГДЕ
			|	Задачи.БизнесПроцесс = &БизнесПроцесс
			|	И Задачи.ПометкаУдаления = ЛОЖЬ
			|	И Задачи.Выполнена = ЛОЖЬ");
		Запрос.УстановитьПараметр("БизнесПроцесс", Ссылка);
		Результат = Запрос.Выполнить();
		
		Блокировка = Новый БлокировкаДанных;
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ЭлементБлокировки = Блокировка.Добавить("Задача.ЗадачаИсполнителя");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
		Блокировка.Заблокировать();
		
		ВыборкаДетальныеЗаписи.Сбросить();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ЗадачаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			ЗадачаОбъект.Важность = Важность;
			ЗадачаОбъект.СрокИсполнения = 
				?(ЗадачаОбъект.ТочкаМаршрута = БизнесПроцессы.Задание.ТочкиМаршрута.Выполнить, 
				СрокИсполненияЗадачиДляВыполнения(), СрокИсполненияЗадачиДляПроверки());
			ЗадачаОбъект.Наименование = 
				?(ЗадачаОбъект.ТочкаМаршрута = БизнесПроцессы.Задание.ТочкиМаршрута.Выполнить, 
				НаименованиеЗадачиДляВыполнения(), НаименованиеЗадачиДляПроверки());
			ЗадачаОбъект.Автор = Автор;
			// Не выполняем предварительную блокировку данных для редактирования, т.к.
			// это изменение имеет более высокий приоритет над открытыми формами задач.
			ЗадачаОбъект.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры 

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий бизнес-процесса

Процедура ПередЗаписью(Отказ)
	
	// Даже в случае обмена данными делаем проверку на запись завершенного
	Если Не ЗадачаИсточник.Пустая() Тогда
		БылЗавершен = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ЭтотОбъект.Ссылка, "Завершен");
		Если Завершен = Истина И БылЗавершен = Ложь Тогда
			СтандартныеПодсистемыПереопределяемый.ВыполнитьЗадачуИсточник(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Автор <> Неопределено И Не Автор.Пустая() Тогда
		АвторСтрокой = Строка(Автор);
	КонецЕсли;
	
	Если СтандартныеПодсистемыПереопределяемый.ИспользоватьВнешниеЗадачиИБизнесПроцессы() Тогда
		
		//shaman
		Для каждого ТекИсполнитель из Исполнители Цикл
			
			Если ТипЗнч(ТекИсполнитель.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") И Не ТекИсполнитель.Исполнитель.Пустая() 
				И ОбщегоНазначения.ПолучитьЗначениеРеквизита(ТекИсполнитель.Исполнитель, "ВнешняяРоль") = Истина Тогда
				
				Если НаПроверке = Истина Тогда
					// Проверяющий должен быть внешней ролью
					Если ТипЗнч(Проверяющий) = Тип("СправочникСсылка.РолиИсполнителей") И Не Проверяющий.Пустая() 
						И ОбщегоНазначения.ПолучитьЗначениеРеквизита(Проверяющий, "ВнешняяРоль") = Ложь Тогда
						Отказ = Истина;
					КонецЕсли;
					
					// Проверяющий не должен быть пользователем
					Если ТипЗнч(Проверяющий) = Тип("СправочникСсылка.Пользователи") И Не Проверяющий.Пустая() Тогда
						Отказ = Истина;
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		//shaman
		
	КонецЕсли;
	
	БизнесПроцессыИЗадачиСервер.ПроверитьПраваНаИзменениеСостоянияБизнесПроцесса(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(ГлавнаяЗадача) И 
		ОбщегоНазначения.ПолучитьЗначениеРеквизита(ГлавнаяЗадача, "БизнесПроцесс") = ЭтотОбъект.Ссылка Тогда
		
		ВызватьИсключение НСтр("ru = 'Собственная задача бизнес-процесса не может быть указана как главная задача.'");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоНовый() И ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "Предмет") <> Предмет Тогда
		ИзменитьПредметЗадач();	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоНовый() Тогда
		Автор = Пользователи.ТекущийПользователь();
		Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
		НаПроверке = Истина;
		Проверяющий = Пользователи.ТекущийПользователь();
		Состояние = Перечисления.СостоянияБизнесПроцессов.Активен;
		Исполнитель = Справочники.Пользователи.ПустаяСсылка(); // Для возможности автоподбора в незаполненном поле Исполнитель.
	КонецЕсли;
	
	Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") 
		И ДанныеЗаполнения <> Задачи.ЗадачаИсполнителя.ПустаяСсылка() Тогда
		
		Если ТипЗнч(ДанныеЗаполнения) <> Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
			Предмет = ДанныеЗаполнения;
		Иначе
			Предмет = ДанныеЗаполнения.Предмет;
		КонецЕсли;
		
	КонецЕсли;	
	
	БизнесПроцессыИЗадачиСервер.ЗаполнитьГлавнуюЗадачу(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	МассивНепроверяемыхРеквизитов = Новый Массив();
	Если Не НаПроверке Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Проверяющий");
	КонецЕсли;
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	НомерИтерации = 0;
	Выполнено = Ложь;
	Подтверждено = Ложь;
	РезультатВыполнения = "";
	ДатаЗавершения = '00010101000000';
	Состояние = Перечисления.СостоянияБизнесПроцессов.Активен;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий элементов карты маршрута

Процедура ВыполнитьПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	//shaman
	
	НомерИтерации = НомерИтерации + 1;
	Записать();
	
	//
	//// Устанавливаем реквизиты адресации и доп. реквизиты для каждой задачи
	//Для каждого Задача Из ФормируемыеЗадачи Цикл
	//	
	//	Задача.Автор = Автор;
	//	Задача.АвторСтрокой = Строка(Автор);
	//	Если ТипЗнч(Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
	//		Задача.РольИсполнителя = Исполнитель;
	//	Иначе	
	//		Задача.Исполнитель = Исполнитель;
	//	КонецЕсли;
	//	Задача.Наименование = НаименованиеЗадачиДляВыполнения();
	//	Задача.СрокИсполнения = СрокИсполненияЗадачиДляВыполнения();
	//	Задача.Важность = Важность;
	//	Задача.Предмет = Предмет;
	//	
	//КонецЦикла;
	
	//shaman

	
КонецПроцедуры

Процедура ВыполнитьПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	
	//shaman
	СтандартнаяОбработка = Ложь;
	
	Для Каждого Строка Из Исполнители Цикл
		
		Задача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
		Задача.Дата 	= ТекущаяДата();
		Задача.Автор 	= Автор;
		Задача.Описание = Содержание;
		Задача.Предмет 	= Предмет;
		Задача.Важность = Важность;
		Задача.АвторСтрокой = Строка(Автор);
		
		Задача.Наименование  = НаименованиеЗадачиДляВыполнения();
		Задача.БизнесПроцесс = ЭтотОбъект.Ссылка;
		Задача.ТочкаМаршрута = ТочкаМаршрутаБизнесПроцесса;
		
		Если ТипЗнч(Строка.Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда
			Задача.Исполнитель = Строка.Исполнитель;
			ГрафикРаботы = ГрафикиРаботы.ПолучитьГрафикРаботыПользователя(Задача.Исполнитель);
		Иначе	
			Задача.РольИсполнителя = Строка.Исполнитель;
			//Задача.ОсновнойОбъектАдресации = Строка.ОсновнойОбъектАдресации;
			//Задача.ДополнительныйОбъектАдресации = Строка.ДополнительныйОбъектАдресации;
			ГрафикРаботы = ГрафикиРаботы.ПолучитьОсновнойГрафикРаботы();
		КонецЕсли;	
		
		Задача.СрокИсполнения = '00010101';
		Если ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач") Тогда 
			
			Если ЗначениеЗаполнено(СрокИсполнения) Тогда 
			//	Если ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиРаботы") Тогда 
			//		Задача.СрокИсполнения = ГрафикиРаботы.ПолучитьДатуОкончанияПериода(ГрафикРаботы, Задача.Дата, СрокИсполнения, );
			//	Иначе
					Задача.СрокИсполнения = СрокИсполнения;//Задача.Дата + СрокИсполнения*24*3600 + СрокИсполненияЧас*3600;
			//	КонецЕсли;
			КонецЕсли;
			
		Иначе
			
			Если ЗначениеЗаполнено(СрокИсполнения) Тогда 
			//	Если ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиРаботы") Тогда 
			//		Задача.СрокИсполнения = ГрафикиРаботы.ПолучитьДатуОкончанияПериода(ГрафикРаботы, Задача.Дата, СрокИсполнения,);
			//	Иначе
					Задача.СрокИсполнения = СрокИсполнения;//Задача.Дата + Строка.СрокИсполнения*24*3600;
			//	КонецЕсли;	
				Задача.СрокИсполнения = КонецДня(Задача.СрокИсполнения);
			КонецЕсли;
			
		КонецЕсли;
		
		Задача.Записать();
		ФормируемыеЗадачи.Добавить(Задача);
		
		Строка.ЗадачаИсполнителя = Задача.Ссылка;
		
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	Записать();
	УстановитьПривилегированныйРежим(Ложь);
	//shaman
	
	Если Предмет = Неопределено Или Предмет.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Если СтандартныеПодсистемыПереопределяемый.ИспользоватьВнешниеЗадачиИБизнесПроцессы() Тогда
		
		//shaman
		Для каждого ТекИсполнитель из Исполнители Цикл
			
			Если ТипЗнч(ТекИсполнитель.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") 
				И ОбщегоНазначения.ПолучитьЗначениеРеквизита(ТекИсполнитель.Исполнитель, "ВнешняяРоль") = Истина Тогда
				
				СтрокаHTML = "";
				СтандартныеПодсистемыПереопределяемый.ПолучитьПредставлениеПредметаВнешнейЗадачи(Предмет, СтрокаHTML);
				СодержаниеПредмета = Новый ХранилищеЗначения(СтрокаHTML, Новый СжатиеДанных());
				
				// Заполняем список файлов
				МассивФайлов = Неопределено;
				СтандартныеПодсистемыПереопределяемый.ПолучитьСписокФайлов(Предмет, МассивФайлов);
				Если МассивФайлов <> Неопределено Тогда
					Для	каждого Элемент Из МассивФайлов Цикл
						НовыйФайл = РаботаСФайламиВызовСервера.СкопироватьФайл(Элемент, Ссылка);
					КонецЦикла;
				КонецЕсли;	
				
			КонецЕсли;
		КонецЦикла;
		//shaman
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	РезультатВыполнения = РезультатВыполненияТочкиВыполнить(Задача) + РезультатВыполнения;
	Записать();
	
КонецПроцедуры

Процедура ПроверитьПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	Если Проверяющий.Пустая() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Устанавливаем реквизиты адресации и доп. реквизиты для каждой задачи
	Для каждого Задача Из ФормируемыеЗадачи Цикл
		
		Задача.Автор = Автор;
		
		// shaman 
		//Если ТипЗнч(Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
		//	Задача.РольИсполнителя = Проверяющий;
		//Иначе	
		//	Задача.Исполнитель = Проверяющий;
		//КонецЕсли;
		
		Задача.Наименование = НаименованиеЗадачиДляПроверки();// + " (" + Задача.Исполнитель + ") ";

		Если ТипЗнч(Проверяющий) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
			Задача.РольИсполнителя = Проверяющий;
		Иначе	
			Задача.Исполнитель = Проверяющий;
		КонецЕсли;
		// shaman 
		
		Задача.СрокИсполнения = СрокИсполненияЗадачиДляПроверки();
		Задача.Важность = Важность;
		Задача.Предмет = Предмет;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)

	РезультатВыполнения = РезультатВыполненияТочкиПроверить(Задача) + РезультатВыполнения;
	Записать();
	
КонецПроцедуры

Процедура НужнаПроверкаПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = НаПроверке;

КонецПроцедуры

Процедура ВернутьИсполнителюПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = НЕ Подтверждено;
	
КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаЗавершения = БизнесПроцессыИЗадачиСервер.ДатаЗавершенияБизнесПроцесса(Ссылка);
	Записать();
	
КонецПроцедуры

Процедура СтартПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	Если СтандартныеПодсистемыПереопределяемый.ИспользоватьВнешниеЗадачиИБизнесПроцессы() Тогда
		
		//shaman
		Для каждого ТекИсполнитель из Исполнители Цикл
			
			Если ТипЗнч(ТекИсполнитель.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") И Не ТекИсполнитель.Исполнитель.Пустая() 
				И ОбщегоНазначения.ПолучитьЗначениеРеквизита(ТекИсполнитель.Исполнитель, "ВнешняяРоль") = Истина Тогда
				
				ВнешнееЗадание = Истина;
				
			КонецЕсли;
			
		КонецЦикла;
		//shaman
		
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ИзменитьПредметЗадач()

	УстановитьПривилегированныйРежим(Истина);
	НачатьТранзакцию();
	Попытка
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	Задачи.Ссылка КАК Ссылка
			|ИЗ
			|	Задача.ЗадачаИсполнителя КАК Задачи
			|ГДЕ
			|	Задачи.БизнесПроцесс = &БизнесПроцесс");

		Запрос.УстановитьПараметр("БизнесПроцесс", Ссылка);
		Результат = Запрос.Выполнить();
		
		Блокировка = Новый БлокировкаДанных;
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ЭлементБлокировки = Блокировка.Добавить("Задача.ЗадачаИсполнителя");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
		Блокировка.Заблокировать();
		
		ВыборкаДетальныеЗаписи.Сбросить();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ЗадачаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			ЗадачаОбъект.Предмет = Предмет;
			// Не выполняем предварительную блокировку данных для редактирования, т.к.
			// это изменение имеет более высокий приоритет над открытыми формами задач.
			ЗадачаОбъект.Записать();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры 

Функция НаименованиеЗадачиДляВыполнения()
	
	Возврат Наименование;	
	
КонецФункции

Функция СрокИсполненияЗадачиДляВыполнения()
	
	Возврат СрокИсполнения;	
КонецФункции

Функция НаименованиеЗадачиДляПроверки()
	
	Возврат БизнесПроцессы.Задание.ТочкиМаршрута.Проверить.НаименованиеЗадачи + ": " + Наименование;
	
КонецФункции

Функция СрокИсполненияЗадачиДляПроверки()
	
	Возврат СрокПроверки;	
	
КонецФункции

Функция РезультатВыполненияТочкиВыполнить(Знач ЗадачаСсылка)
	
	СтрокаФормат = ?(Выполнено,
	    НСтр("ru = '%1, %2 выполнил(а) задачу:
		           |%3
		           |'"),
		НСтр("ru = '%1, %2 отклонил(а) задачу:
		           |%3
		           |'"));
	ЗадачаДанные = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ЗадачаСсылка, 
		"РезультатВыполнения,ДатаИсполнения,Исполнитель");
	Комментарий = СокрЛП(ЗадачаДанные.РезультатВыполнения);
	Комментарий = ?(ПустаяСтрока(Комментарий), "", Комментарий + Символы.ПС);
	Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаФормат, 
	              ЗадачаДанные.ДатаИсполнения,
	              ЗадачаДанные.Исполнитель,
	              Комментарий);
	
	Возврат Результат;
	
КонецФункции

Функция РезультатВыполненияТочкиПроверить(Знач ЗадачаСсылка)  
	
	Если НЕ Подтверждено Тогда
		СтрокаФормат = НСтр("ru = '%1, %2 вернул(а) задачу на доработку:
			|%3
			|'");
	Иначе
		СтрокаФормат = ?(Выполнено,
			НСтр("ru = '%1, %2 подтвердил(а) выполнение задачи:
			           |%3
			           |'"),
			НСтр("ru = '%1, %2 подтвердил(а) отмену задачи:
			           |%3
			           |'"));
	КонецЕсли;
	
	ЗадачаДанные = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ЗадачаСсылка, 
		"РезультатВыполнения,ДатаИсполнения,Исполнитель");
	Комментарий = СокрЛП(ЗадачаДанные.РезультатВыполнения);
	Комментарий = ?(ПустаяСтрока(Комментарий), "", Комментарий + Символы.ПС);
	Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаФормат,
	              ЗадачаДанные.ДатаИсполнения,
	              ЗадачаДанные.Исполнитель,
	              Комментарий);
		
	Возврат Результат;

КонецФункции

Процедура ВыполнитьОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	Результат = Истина;
КонецПроцедуры

Процедура ВыполнитьПередВыполнением(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	// shaman
	УстановитьПривилегированныйРежим(Истина);
	НайденнаяСтрока = Исполнители.Найти(Задача, "ЗадачаИсполнителя");
	Если НайденнаяСтрока <> Неопределено Тогда 
		НайденнаяСтрока.Пройден = Истина;
		Записать();
		
		Если НЕ Исполнители.Найти(Ложь, "Пройден") = Неопределено Тогда 
			
			Задача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
			Задача.Дата 	= ТекущаяДата();
			Задача.Автор 	= Автор;
			Задача.Описание = Содержание;
			Задача.Предмет 	= Предмет;
			Задача.Важность = Важность;
			Задача.АвторСтрокой = Строка(Автор);
			
			Задача.Наименование  = НаименованиеЗадачиДляПроверки();// + " (" + НайденнаяСтрока.Исполнитель + ") ";
			Задача.БизнесПроцесс = ЭтотОбъект.Ссылка;
			Задача.ТочкаМаршрута = Бизнеспроцессы.Задание.ТочкиМаршрута.Проверить;
			
			Если ТипЗнч(Проверяющий) = Тип("СправочникСсылка.Пользователи") Тогда
				Задача.Исполнитель = Проверяющий;
				ГрафикРаботы = ГрафикиРаботы.ПолучитьГрафикРаботыПользователя(Задача.Исполнитель);
			Иначе	
				Задача.РольИсполнителя = Проверяющий;
			КонецЕсли;	
			
			Задача.Записать();
		КонецЕсли;

	КонецЕсли;	
	// shaman

КонецПроцедуры

Процедура ПроверитьПередВыполнением(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
КонецПроцедуры

Процедура ПроверитьПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
КонецПроцедуры

Процедура ПроверитьОбработкаПроверкиВыполнения(ТочкаМаршрутаБизнесПроцесса, Задача, Результат)
	
	// shaman
	Результат = Исполнители.Найти(Ложь, "Пройден") = Неопределено;
	// shaman
КонецПроцедуры
