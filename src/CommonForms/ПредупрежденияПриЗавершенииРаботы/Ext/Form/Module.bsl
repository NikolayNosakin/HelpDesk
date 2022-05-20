﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
		
	ИнициализироватьЭлементыВФорме(Параметры.Предупреждения);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

// Обработчик нажатия на гиперссылку.
//
&НаКлиенте
Процедура НажатиеНаГиперСсылку(Элемент)
	Для каждого СтрокаВопроса из МассивСоотношенияЭлементовИПараметров Цикл
		Если Элемент.Имя = СтрокаВопроса.Значение.Имя Тогда 
			Форма = Неопределено;
			Если СтрокаВопроса.Значение.Свойство("Форма", Форма) Тогда 
				ПараметрыФормы = Неопределено;
				Если СтрокаВопроса.Значение.Свойство("ПараметрыФормы", ПараметрыФормы) Тогда 
				КонецЕсли;
				ОткрытьФорму(Форма, ПараметрыФормы,,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
			КонецЕсли;	
			Прервать;
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры

// Инициализирует массив будущих задач, которые необходимо выполнить при закрытии.
//
&НаКлиенте 
Процедура ИзменитьМассивБудущихЗадач(Элемент)
	ИмяЭлемента 		= Элемент.Имя;
	НайденныйЭлемент 	= Элементы.Найти(ИмяЭлемента);
	
	Если НайденныйЭлемент = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	ЗначениеЭлемента = ЭтотОбъект[ИмяЭлемента];
	Если ТипЗнч(ЗначениеЭлемента) <> Тип("Булево") Тогда
		Возврат;
	КонецЕсли;	
		

	ИдентификаторМассива = ИдентификаторМассиваЗадачПоИмени(ИмяЭлемента);
	Если ИдентификаторМассива = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	ЭлементМассива = МассивЗадачНаВыполнениеПослеЗакрытия.НайтиПоИдентификатору(ИдентификаторМассива);
	Использование = Неопределено;
	Если ЭлементМассива.Значение.Свойство("Использование", Использование) Тогда 
		Если ТипЗнч(Использование) = Тип("Булево") Тогда 
			ЭлементМассива.Значение.Использование = ЗначениеЭлемента;
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры	


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Завершить(Команда)
	
	ВыполнениеЗадачПриЗакрытии();
	Закрыть(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура НеЗавершать(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Создает элементы формы по передаваемым вопросам пользователю.
//
// Параметры:
//	Вопросы - список значений вопросов.
//
&НаСервере
Процедура ИнициализироватьЭлементыВФорме(Предупреждения)
	Для каждого ТекущееПредупреждение из Предупреждения Цикл 
		// Пропускаем чтение текущей структуры, если имеется текст для флага и для структуры одновременно.
		ТекстФлажка 		= "";
		ТекстГиперСсылки 	= "";
		Если ТекущееПредупреждение.Свойство("ТекстФлажка", ТекстФлажка) 
			и ТекущееПредупреждение.Свойство("ТекстГиперСсылки", ТекстГиперСсылки) Тогда 
			Продолжить;
		КонецЕсли;	
		
		// Формирование гипперссылки на форме.
		Если ТекущееПредупреждение.Свойство("ТекстГиперСсылки", ТекстГиперСсылки) Тогда
			Если Не ПустаяСтрока(ТекстГиперСсылки) Тогда 
				СоздатьГипперссылкуНаФорме(ТекущееПредупреждение);
			КонецЕсли;	
		КонецЕсли;	
		
		// Формирование флажка на форме.
		Если ТекущееПредупреждение.Свойство("ТекстФлажка", ТекстФлажка) Тогда
			Если Не ПустаяСтрока(ТекстФлажка) Тогда 
				СоздатьФлажокНаФорме(ТекущееПредупреждение);
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;	
	
	// Формирование окончательного впороса на форме.
	СоздатьОкончательныйВопрос();
КонецПроцедуры

// Формирует на форме группу и возвращает её.
// Является дочерней группой для "ОсновнойГруппы".
//
&НаСервере
Функция СформироватьГруппуЭлементовФормы()
	ИмяГруппы 		= ОпределитьИмяНадписиВФорме("ГруппаВФорме");
	ТипГруппы 		= Тип("ГруппаФормы");
	РодительГруппы 	= Элементы.ОсновнаяГруппа;
	
	Группа 						= Элементы.Добавить(ИмяГруппы, ТипГруппы, РодительГруппы);
	Группа.Вид					= ВидГруппыФормы.ОбычнаяГруппа;
	Группа.Отображение			= ОтображениеОбычнойГруппы.Нет;
	Группа.ОтображатьЗаголовок  = Ложь;
	Группа.РастягиватьПоГоризонтали = Истина;
	
	Возврат Группа; 
КонецФункции

// Формирует на форме гиперссылку с поясняющим текстом.
//
// Параметры:
//	СтруктураВопроса - структура передаваемого вопроса.
//
&НаСервере
Процедура СоздатьГипперссылкуНаФорме(СтруктураВопроса)
	Группа = СформироватьГруппуЭлементовФормы();
	
	ПоясняющийТекст = "";
	Если СтруктураВопроса.Свойство("ПоясняющийТекст", ПоясняющийТекст) Тогда
		Если Не ПустаяСтрока(ПоясняющийТекст) Тогда 
			ИмяНадписи 		= ОпределитьИмяНадписиВФорме("НадписьВопроса");
			ТипНадписи		= Тип("ДекорацияФормы");
			РодительНадписи	= Группа;
			
			ЭлементПоясняющегоТекста = Элементы.Добавить(ИмяНадписи, ТипНадписи, РодительНадписи);
			ЭлементПоясняющегоТекста.Заголовок = ПоясняющийТекст;
		КонецЕсли;	
	КонецЕсли;
	
	ТекстГиперСсылки = "";
	Если СтруктураВопроса.Свойство("ТекстГиперСсылки", ТекстГиперСсылки) Тогда 
		Если Не ПустаяСтрока(ТекстГиперСсылки) Тогда
			ИмяГиперсылки		= ОпределитьИмяНадписиВФорме("НадписьВопроса");
			ТипГиперсылки		= Тип("ДекорацияФормы");
			РодительГиперсылки	= Группа;

			ЭлементГиперСсылки = Элементы.Добавить(ИмяГиперсылки, ТипГиперсылки, РодительГиперсылки);
			ЭлементГиперСсылки.Гиперссылка 	= Истина;
			ЭлементГиперСсылки.Заголовок 	= ТекстГиперСсылки;
			ЭлементГиперСсылки.УстановитьДействие("Нажатие", "НажатиеНаГиперСсылку");
			
			ФормаГиперссылки 	= Неопределено;
			ДействиеГиперссылки = Неопределено;
			Если СтруктураВопроса.Свойство("ДействиеПриНажатииГипперссылки", ДействиеГиперссылки) Тогда
				СтруктураОбработки = СтруктураВопроса.ДействиеПриНажатииГипперссылки;
				Если СтруктураОбработки.Свойство("Форма", ФормаГиперссылки) Тогда 
					СтруктураМассива = Новый Структура;
					СтруктураМассива.Вставить("Имя", 	ИмяГиперсылки);
					СтруктураМассива.Вставить("Форма", 	ФормаГиперссылки);
					
					ПараметрыФормы = Неопределено;
					Если СтруктураОбработки.Свойство("ПараметрыФормы", ПараметрыФормы) Тогда
						Если ТипЗнч(ПараметрыФормы) = Тип("Структура") Тогда 
							ПараметрыФормы.Вставить("ЗавершениеРаботыПрограммы", Истина);
						ИначеЕсли ПараметрыФормы = Неопределено Тогда 
							ПараметрыФормы = Новый Структура;
							ПараметрыФормы.Вставить("ЗавершениеРаботыПрограммы", Истина);
						КонецЕсли;	
						СтруктураМассива.Вставить("ПараметрыФормы", ПараметрыФормы);
					КонецЕсли;	
					
					МассивСоотношенияЭлементовИПараметров.Добавить(СтруктураМассива);
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры	

// Формирует на форме флажок с поясняющим текстом.
//
// Параметры:
//	СтруктураВопроса - труктура передаваемого вопроса.
//
&НаСервере
Процедура СоздатьФлажокНаФорме(СтруктураВопроса)
	ЗначениеПоУмолчанию = Истина;
	Группа 				= СформироватьГруппуЭлементовФормы();
	
	ПоясняющийТекст = "";
	Если СтруктураВопроса.Свойство("ПоясняющийТекст", ПоясняющийТекст) Тогда	
		Если Не ПустаяСтрока(ПоясняющийТекст) Тогда 
			ИмяНадписи 		= ОпределитьИмяНадписиВФорме("НадписьВопроса");
			ТипНадписи		= Тип("ДекорацияФормы");
			РодительНадписи	= Группа;
			
			ЭлементПоясняющегоТекста = Элементы.Добавить(ИмяНадписи, ТипНадписи, РодительНадписи);
			ЭлементПоясняющегоТекста.Заголовок = ПоясняющийТекст;
		КонецЕсли;	
	КонецЕсли;
	
	ТекстФлажка = "";
	Если СтруктураВопроса.Свойство("ТекстФлажка", ТекстФлажка) Тогда	
		Если Не ПустаяСтрока(ТекстФлажка) Тогда 
			// Добавление реквизита в форму.
			ИмяФлажка 		= ОпределитьИмяНадписиВФорме("НадписьВопроса");
			ТипФлажка		= Тип("ПолеФормы");
			РодительФлажка	= Группа;
			
			МассивТипов = Новый Массив;
			МассивТипов.Добавить(Тип("Булево"));
			Описание = Новый ОписаниеТипов(МассивТипов);
			
			ДобавляемыеРеквизиты = Новый Массив;
			НовыйРеквизит 	= Новый РеквизитФормы(ИмяФлажка, Описание, , ИмяФлажка, Ложь);
			ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
			ИзменитьРеквизиты(ДобавляемыеРеквизиты);
			ЭтотОбъект[ИмяФлажка] = ЗначениеПоУмолчанию;
			
			НовоеПолеФормы 						= Элементы.Добавить(ИмяФлажка, ТипФлажка, РодительФлажка);
			НовоеПолеФормы.ПутьКДанным			= ИмяФлажка;
			НовоеПолеФормы.Заголовок   			= ТекстФлажка;
			НовоеПолеФормы.Вид					= ВидПоляФормы.ПолеФлажка;
			НовоеПолеФормы.ПоложениеЗаголовка	= ПоложениеЗаголовкаЭлементаФормы.Право;
			
			// Инициализация элемента в массиве.
			ФормаЭлемента 		= Неопределено;
			СтруктураДействия 	= Неопределено;
			Если СтруктураВопроса.Свойство("ДействиеПриУстановленномФлажке", СтруктураДействия) Тогда 
				Если СтруктураДействия.Свойство("Форма", ФормаЭлемента) Тогда 
					НовоеПолеФормы.УстановитьДействие("ПриИзменении", "ИзменитьМассивБудущихЗадач");
					
					СтруктураМассива = Новый Структура;
					СтруктураМассива.Вставить("Имя", 			ИмяФлажка);
					СтруктураМассива.Вставить("Форма", 			ФормаЭлемента);
					СтруктураМассива.Вставить("Использование", 	ЗначениеПоУмолчанию);
					
					ПараметрыФормы = Неопределено;
					Если СтруктураДействия.Свойство("ПараметрыФормы", ПараметрыФормы) Тогда
						СтруктураМассива.Вставить("ПараметрыФормы", ПараметрыФормы);
					КонецЕсли;	
					
					МассивЗадачНаВыполнениеПослеЗакрытия.Добавить(СтруктураМассива);
				КонецЕсли;
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Процедура СоздатьОкончательныйВопрос()
	Группа 				= СформироватьГруппуЭлементовФормы();
	ОкончательныйВопрос = НСтр("ru = 'Завершить работу с программой?'");
	
	ИмяНадписи 		= ОпределитьИмяНадписиВФорме("НадписьВопроса");
	ТипНадписи		= Тип("ДекорацияФормы");
	РодительНадписи	= Группа;
	
	ЭлементПоясняющегоТекста = Элементы.Добавить(ИмяНадписи, ТипНадписи, РодительНадписи);
	ЭлементПоясняющегоТекста.Заголовок = ОкончательныйВопрос;
КонецПроцедуры	

// Формирует имя надписи в форме по заголовку.
// 
// Параметры:
//	ЗаголовокЭлемента - заголовок.
//
&НаСервере
Функция ОпределитьИмяНадписиВФорме(ЗаголовокЭлемента)
	Индекс = 0;
	ФлагПоиска = Истина;
	
	Пока ФлагПоиска Цикл 
		ИндексСтрока = Строка(Формат(Индекс, "ЧН=-"));
		ИндексСтрока = СтрЗаменить(ИндексСтрока, "-", "");
		Имя = ЗаголовокЭлемента + ИндексСтрока;
		
		НайденныйЭлемент = Элементы.Найти(Имя);
		Если НайденныйЭлемент = Неопределено Тогда 
			Возврат Имя;	
		КонецЕсли;	
		
		Индекс = Индекс + 1;
	КонецЦикла;	
КонецФункции	

&НаКлиенте
Функция ИдентификаторМассиваЗадачПоИмени(ИмяЭлемента)
	Для каждого ЭлементМассива из МассивЗадачНаВыполнениеПослеЗакрытия цикл
		Наименование = "";
		Если ЭлементМассива.Значение.Свойство("Имя", Наименование) Тогда 
			Если Не ПустаяСтрока(Наименование) и Наименование = ИмяЭлемента тогда
				Возврат ЭлементМассива.ПолучитьИдентификатор();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

// Выполняет необходимые задачи.
//
&НаКлиенте
Процедура ВыполнениеЗадачПриЗакрытии()
	Для каждого ЭлементМассива из МассивЗадачНаВыполнениеПослеЗакрытия цикл
		Использование = Неопределено;
		Если ЭлементМассива.Значение.Свойство("Использование", Использование) Тогда 
			Если ТипЗнч(Использование) = Тип("Булево") Тогда 
				Если Использование = Истина Тогда 
					Форма = Неопределено;
					Если ЭлементМассива.Значение.Свойство("Форма", Форма) Тогда 
						ПараметрыФормы = Неопределено;
						Если ЭлементМассива.Значение.Свойство("ПараметрыФормы", ПараметрыФормы) Тогда 
							ОткрытьФормуМодально(Форма, ПараметрыФормы); 
						КонецЕсли;	
					КонецЕсли;	
				КонецЕсли;	
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры	
 

