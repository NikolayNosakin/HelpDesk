﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастроитьВидПросмотра();
	
	Если Не Параметры.Свойство("Заголовок", Заголовок) Тогда
		Заголовок = НСтр("ru = 'Подбор исполнителей'");
	КонецЕсли;
	
	Если Не Параметры.Свойство("ВыбранныеЗаголовок", Элементы.Выбранные.Заголовок) Тогда
		Элементы.Выбранные.Заголовок = НСтр("ru = 'Выбранные пользователи и роли'");
	КонецЕсли;
	
	Если Не Параметры.Свойство("ПодбиратьГруппыПользователей", ПодбиратьГруппыПользователей) Тогда
		ПодбиратьГруппыПользователей = Ложь;
	КонецЕсли;
	
	ПоказыватьФункции = Истина;
	Если Не Параметры.Свойство("ПоказыватьФункции", ПоказыватьФункции) Тогда
		ПоказыватьФункции = Истина;
	КонецЕсли;
	//Если ПоказыватьФункции Тогда
	//	Элементы.Функции.Видимость = Истина;
	//	Если Параметры.Свойство("ПоказыватьФункцииДокумента") И Параметры.ПоказыватьФункцииДокумента = Истина Тогда
	//		СписокФункций = ШаблоныДокументов.ПолучитьСписокДоступныхФункций();
	//	Иначе
	//		СписокФункций = ШаблоныБизнесПроцессов.ПолучитьСписокДоступныхФункций();
	//	КонецЕсли;
	//Иначе
		Элементы.Функции.Видимость = Ложь;
	//КонецЕсли;
	
	Если Не Параметры.Свойство("ПоказыватьРоли", ПоказыватьРоли) Тогда
		ПоказыватьРоли = Истина;
	КонецЕсли;
	Элементы.Роли.Видимость = ПоказыватьРоли;
	Если ПоказыватьРоли Тогда
		ТолькоПростыеРоли = Ложь;
		Если Параметры.Свойство("ТолькоПростыеРоли", ТолькоПростыеРоли) И ТолькоПростыеРоли = Истина Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокРоли.Отбор, "ИспользуетсяБезОбъектовАдресации", Истина);
		КонецЕсли;
		БезВнешнихРолей = Ложь;
		Если Параметры.Свойство("БезВнешнихРолей", БезВнешнихРолей) И БезВнешнихРолей = Истина Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокРоли.Отбор, "ВнешняяРоль", Ложь);
		КонецЕсли;
	КонецЕсли;
	
	ПоказыватьКорреспондентов = Ложь;
	Если Не Параметры.Свойство("ПоказыватьКорреспондентов", ПоказыватьКорреспондентов) Тогда
		ПоказыватьКорреспондентов = Ложь;
	КонецЕсли;
	Если ПоказыватьКорреспондентов Тогда
		ЗаполнитьДеревоКорреспондентов();
		Элементы.Корреспонденты.Видимость = Истина;
	Иначе
		Элементы.Корреспонденты.Видимость = Ложь;
	КонецЕсли;
	
	ПоказыватьМоиКонтакты = Ложь;
	Если Не Параметры.Свойство("ПоказыватьМоиКонтакты", ПоказыватьМоиКонтакты) Тогда
		ПоказыватьМоиКонтакты = Ложь;
	КонецЕсли;
	Если ПоказыватьМоиКонтакты Тогда
		ЗаполнитьМоиКонтакты();
		Элементы.МоиКонтакты.Видимость = Истина;
	Иначе
		Элементы.МоиКонтакты.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("Выбранные") Тогда
		Если ТипЗнч(Параметры.Выбранные) = Тип("Массив") Тогда
			Для каждого Элемент Из Параметры.Выбранные Цикл
				Если ТипЗнч(Элемент) = Тип("Структура") Тогда
					ЗаполнитьЗначенияСвойств(Выбранные.Добавить(), Элемент);
				Иначе
					Выбранные.Добавить().Исполнитель = Элемент;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("АдресВременногоХранилища") И ЭтоАдресВременногоХранилища(Параметры.АдресВременногоХранилища) Тогда
		АдресВременногоХранилища = Параметры.АдресВременногоХранилища;
		Выбранные.Загрузить(ПолучитьИзВременногоХранилища(АдресВременногоХранилища));
	КонецЕсли;
	
	ВыбранныеКоличество = Выбранные.Количество();
	Для Инд = 1 По ВыбранныеКоличество Цикл
		СтрокаВыбранные = Выбранные[ВыбранныеКоличество - Инд];
		Если Не ЗначениеЗаполнено(СтрокаВыбранные.Исполнитель) И 
			 Не ЗначениеЗаполнено(СтрокаВыбранные.ОсновнойОбъектАдресации) И
			 Не ЗначениеЗаполнено(СтрокаВыбранные.ДополнительныйОбъектАдресации) Тогда 
		Выбранные.Удалить(СтрокаВыбранные);
		КонецЕсли;
	КонецЦикла;	
	
	Если Не ПоказыватьРоли И Не ПоказыватьФункции Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.Пользователи;
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	ТекущееПодразделение = Элементы.СтруктураПредприятия.ТекущаяСтрока;
	ТекущаяГруппаПользователей = Элементы.ГруппыПользователей.ТекущаяСтрока;
	
	//АбисСофт-Кострицын Олег-Старт  17 января 2014 г.
	Если Не Параметры.Свойство("ПоказыватьПользователей", ПоказыватьПользователей) Тогда
		ПоказыватьПользователей = Истина;
	КонецЕсли;
	Элементы.Пользователи.Видимость = ПоказыватьПользователей;
	//АбисСофт-Кострицын Олег-финиш  17 января 2014 г.
	
	ОтобразитьИерархию();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВидПросмотра()
	
	Элементы.ВидПросмотра.СписокВыбора.Очистить();
	Элементы.ВидПросмотра.СписокВыбора.Добавить(НСтр("ru = 'Списком'"));
	Элементы.ВидПросмотра.СписокВыбора.Добавить(НСтр("ru = 'По подразделениям'"));
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей") = Истина Тогда
		Элементы.ВидПросмотра.СписокВыбора.Добавить(НСтр("ru = 'По группам пользователей'"));
	КонецЕсли;
	
	ВидПросмотра = ХранилищеСистемныхНастроек.Загрузить(ИмяФормы, "ВидПросмотра");
	Если Элементы.ВидПросмотра.СписокВыбора.НайтиПоЗначению(ВидПросмотра) = Неопределено Тогда
		ВидПросмотра = ?(ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей"),НСтр("ru = 'По группам пользователей'"),НСтр("ru = 'По подразделениям'"));
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбработкаОжидания()
	
	Если ВидПросмотра = НСтр("ru = 'По подразделениям'") Тогда
		Если Элементы.СтруктураПредприятия.ТекущаяСтрока <> Неопределено Тогда 
			Если ТекущееПодразделение <> Элементы.СтруктураПредприятия.ТекущаяСтрока Тогда
				ТекущееПодразделение = Элементы.СтруктураПредприятия.ТекущаяСтрока;
				ЗаполнитьСписокПользователей();
			КонецЕсли;
		КонецЕсли;	
	ИначеЕсли ВидПросмотра = НСтр("ru = 'По группам пользователей'") Тогда
		Если Элементы.ГруппыПользователей.ТекущаяСтрока <> Неопределено Тогда 
			Если ТекущаяГруппаПользователей <> Элементы.ГруппыПользователей.ТекущаяСтрока Тогда
				ТекущаяГруппаПользователей = Элементы.ГруппыПользователей.ТекущаяСтрока;
				ЗаполнитьСписокПользователей();
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Включить(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Пользователи Тогда 
		Если ТекущийЭлемент.Имя = "ГруппыПользователей" И ПодбиратьГруппыПользователей Тогда
			Если Элементы.ГруппыПользователей.ТекущаяСтрока <> Неопределено Тогда
				ВыборГруппыПользователей(Элементы.ГруппыПользователей.ТекущиеДанные.Ссылка);
			КонецЕсли;	
		Иначе
			Если Элементы.СписокПользователи.ТекущаяСтрока <> Неопределено Тогда
				ВыборПользователя(Элементы.СписокПользователи.ТекущиеДанные.Ссылка);
			КонецЕсли;
		КонецЕсли;	
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Роли Тогда 
		ВыборРоли(Элементы.СписокРоли.ТекущаяСтрока);
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Функции Тогда 
		ВыборФункции(Элементы.СписокФункций.ТекущаяСтрока);
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Корреспонденты Тогда 	
		ВыборКорреспондента(Элементы.СписокКорреспонденты.ТекущиеДанные);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Исключить(Команда)
	
	ТекущаяСтрока = Элементы.Выбранные.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	СтрокаПоИдентификатору = Выбранные.НайтиПоИдентификатору(ТекущаяСтрока);
	Выбранные.Удалить(СтрокаПоИдентификатору);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборПользователя(ВыбранноеЗначение)
	
	ПараметрыОтбора = Новый Структура("Исполнитель", ВыбранноеЗначение);
	Если Выбранные.НайтиСтроки(ПараметрыОтбора).Количество() > 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Пользователь ""%1"" уже выбран!'"),
			Строка(ВыбранноеЗначение));
		
		ПоказатьПредупреждение(Неопределено, ТекстСообщения);
		
	Иначе
		НоваяСтрока = Выбранные.Добавить();
		НоваяСтрока.Исполнитель = ВыбранноеЗначение;
		Элементы.Выбранные.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборГруппыПользователей(ВыбранноеЗначение)
	
	Если Не ПодбиратьГруппыПользователей Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура("Исполнитель", ВыбранноеЗначение);
	Если Выбранные.НайтиСтроки(ПараметрыОтбора).Количество() > 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Группа пользователей ""%1"" уже выбрана!'"),
			Строка(ВыбранноеЗначение));
		
		ПоказатьПредупреждение(Неопределено, ТекстСообщения);
		
	Иначе
		НоваяСтрока = Выбранные.Добавить();
		НоваяСтрока.Исполнитель = ВыбранноеЗначение;
		Элементы.Выбранные.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборРоли(ВыбранноеЗначение, СтруктураПредприятияТекущаяСтрока = Неопределено)
	
	ПараметрыРоли = РаботаСПользователями.ПолучитьПараметрыРоли(ВыбранноеЗначение, СтруктураПредприятияТекущаяСтрока);
	РезультатВыбора = Неопределено;
	
	Если Не ПараметрыРоли.ИспользуетсяСОбъектамиАдресации Тогда 
		РезультатВыбора = Новый Структура("РольИсполнителя, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации", ВыбранноеЗначение, Неопределено, Неопределено);
	Иначе	
		
		Если СтруктураПредприятияТекущаяСтрока <> Неопределено Тогда
			
			ЕстьНезаполненныйТип = Ложь;
			
			Если ПараметрыРоли.ТипыОсновногоОбъектаАдресации <> Неопределено
				И ПараметрыРоли.ТипыОсновногоОбъектаАдресации.Количество() > 0 Тогда
				
				Если ПараметрыРоли.ОсновнойОбъектАдресации = Неопределено Тогда
					ЕстьНезаполненныйТип = Истина;
				КонецЕсли;	
					
			КонецЕсли;	
			
			Если ПараметрыРоли.ТипыДополнительногоОбъектаАдресации <> Неопределено
				И ПараметрыРоли.ТипыДополнительногоОбъектаАдресации.Количество() > 0 Тогда
				
				Если ПараметрыРоли.ДополнительныйОбъектАдресации = Неопределено Тогда
					ЕстьНезаполненныйТип = Истина;
				КонецЕсли;	
				
			КонецЕсли;	
			
			Если Не ЕстьНезаполненныйТип Тогда
				РезультатВыбора = Новый Структура("РольИсполнителя, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации", 
					ВыбранноеЗначение, ПараметрыРоли.ОсновнойОбъектАдресации, ПараметрыРоли.ДополнительныйОбъектАдресации);
			КонецЕсли;		
			
		КонецЕсли;	
		
		Если ТипЗнч(РезультатВыбора) <> Тип("Структура") Тогда
			ОткрытьФорму("ОбщаяФорма.ВыборРолиИсполнителя", 
				Новый Структура("РольИсполнителя, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации", 
				ВыбранноеЗначение, ПараметрыРоли.ОсновнойОбъектАдресации, ПараметрыРоли.ДополнительныйОбъектАдресации), ЭтотОбъект,,,, Новый ОписаниеОповещения("ВыборРолиЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
            Возврат;
		КонецЕсли;
	
	КонецЕсли;	
	
	ВыборРолиФрагмент(РезультатВыбора);
КонецПроцедуры

&НаКлиенте
Процедура ВыборРолиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	РезультатВыбора = Результат;
	
	ВыборРолиФрагмент(РезультатВыбора);

КонецПроцедуры

&НаКлиенте
Процедура ВыборРолиФрагмент(Знач РезультатВыбора)
	
	Перем НоваяСтрока, ПараметрыОтбора, ТекстСообщения;
	
	Если ТипЗнч(РезультатВыбора) = Тип("Структура") Тогда
		
		ПараметрыОтбора = Новый Структура("Исполнитель, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации", 
		РезультатВыбора.РольИсполнителя, 
		РезультатВыбора.ОсновнойОбъектАдресации, 
		РезультатВыбора.ДополнительныйОбъектАдресации);
		
		Если Выбранные.НайтиСтроки(ПараметрыОтбора).Количество() > 0 Тогда
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Роль ""%1"" с указанными параметрами адресации уже выбрана!'"), 
			Строка(РезультатВыбора.РольИсполнителя));
			
			ПоказатьПредупреждение(Неопределено, ТекстСообщения);
			
		Иначе
			НоваяСтрока = Выбранные.Добавить();
			НоваяСтрока.Исполнитель = РезультатВыбора.РольИсполнителя;
			НоваяСтрока.ОсновнойОбъектАдресации = РезультатВыбора.ОсновнойОбъектАдресации;
			НоваяСтрока.ДополнительныйОбъектАдресации = РезультатВыбора.ДополнительныйОбъектАдресации;
			Элементы.Выбранные.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыборФункции(ВыбраннаяСтрока)
	
	ВыбранноеЗначение = СписокФункций.НайтиПоИдентификатору(ВыбраннаяСтрока).Представление;
	ПараметрыОтбора = Новый Структура("Исполнитель", ВыбранноеЗначение);
	
	Если Выбранные.НайтиСтроки(ПараметрыОтбора).Количество() > 0 Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Автоподстановка ""%1"" уже выбрана!'"),
			Строка(ВыбранноеЗначение));
		
		ПоказатьПредупреждение(Неопределено, ТекстСообщения);
		
	Иначе
		НоваяСтрока = Выбранные.Добавить();
		НоваяСтрока.Исполнитель = ВыбранноеЗначение;
		Элементы.Выбранные.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ВыборКорреспондента(ТекущиеДанные)
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ТекущиеДанные.ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;	
	
	ВыбранноеЗначение = ТекущиеДанные.Ссылка;
	ПараметрыОтбора = Новый Структура("Исполнитель", ВыбранноеЗначение);
	
	Если Выбранные.НайтиСтроки(ПараметрыОтбора).Количество() > 0 Тогда
		
		Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Контрагенты") Тогда 
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Контрагент ""%1"" уже выбран!'"),
				Строка(ВыбранноеЗначение));
				
			ПоказатьПредупреждение(Неопределено, ТекстСообщения);	
				
		ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.КонтактныеЛица") Тогда 
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Контактное лицо ""%1"" уже выбрано!'"),
				Строка(ВыбранноеЗначение));
				
			ПоказатьПредупреждение(Неопределено, ТекстСообщения);
			
		КонецЕсли;	
		
	Иначе
		
		НоваяСтрока = Выбранные.Добавить();
		НоваяСтрока.Исполнитель = ВыбранноеЗначение;
		Элементы.Выбранные.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура ОтобразитьИерархию()
	
	Если ПустаяСтрока(ВидПросмотра) Тогда
		ВидПросмотра = НСтр("ru = 'По подразделениям'");
	КонецЕсли;
	Если ВидПросмотра = НСтр("ru = 'Списком'") Тогда
		Элементы.СтраницыГруппировкаПользователей.Видимость = Ложь;
	Иначе
		Элементы.СтраницыГруппировкаПользователей.Видимость = Истина;
		Если ВидПросмотра = НСтр("ru = 'По подразделениям'") Тогда
			Элементы.СтраницыГруппировкаПользователей.ТекущаяСтраница = Элементы.СтраницаСтруктураПредприятия;
		ИначеЕсли ВидПросмотра = НСтр("ru = 'По группам пользователей'") Тогда
			Элементы.СтраницыГруппировкаПользователей.ТекущаяСтраница = Элементы.СтраницаГруппыПользователей;
		Иначе
			ВызватьИсключение НСтр("ru = 'Некорректный вид просмотра'");
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьСписокПользователей();
	ХранилищеСистемныхНастроек.Сохранить(ИмяФормы, "ВидПросмотра", ВидПросмотра);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПользователей()	
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	СправочникПользователи.Ссылка,
	|	СправочникПользователи.ПометкаУдаления,
	|	СправочникПользователи.Предопределенный,
	|	СправочникПользователи.Наименование,
	|	СведенияОПользователях.Должность,
	|	СведенияОПользователях.Подразделение,
	|	ВЫБОР
	|		КОГДА СправочникПользователи.Ссылка = СведенияОПользователях.Подразделение.Руководитель
	|				И НЕ &ИспользоватьГруппыПользователей
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоРуководитель,
	|	ЛОЖЬ КАК ЭтоРоль
	|ИЗ
	|	Справочник.Пользователи КАК СправочникПользователи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
	|		ПО СправочникПользователи.Ссылка = СведенияОПользователях.Пользователь
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыПользователей.Состав КАК ГруппыПользователейСостав
	|		ПО СправочникПользователи.Ссылка = ГруппыПользователейСостав.Пользователь
	|ГДЕ
	|	(НЕ &ИспользоватьИерархию
	|			ИЛИ СведенияОПользователях.Подразделение = &Подразделение)
	|	И (НЕ &ИспользоватьГруппыПользователей
	|			ИЛИ &ГруппаПользователей = ЗНАЧЕНИЕ(Справочник.ГруппыПользователей.ВсеПользователи)
	|			ИЛИ ГруппыПользователейСостав.Ссылка = &ГруппаПользователей)
	|	И СправочникПользователи.Недействителен = ЛОЖЬ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ИсполнителиЗадач.РольИсполнителя,
	|	ИсполнителиЗадач.РольИсполнителя.ПометкаУдаления,
	|	ИсполнителиЗадач.РольИсполнителя.Предопределенный,
	|	ИсполнителиЗадач.РольИсполнителя.Наименование,
	|	NULL,
	|	NULL,
	|	ЛОЖЬ,
	|	ИСТИНА
	|ИЗ
	|	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
	|ГДЕ
	|	&ПоказыватьРоли
	|	И (НЕ &ИспользоватьИерархию
	|			ИЛИ ИсполнителиЗадач.Исполнитель В
	|				(ВЫБРАТЬ
	|					СправочникПользователи.Ссылка
	|				ИЗ
	|					Справочник.Пользователи КАК СправочникПользователи
	|						ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
	|						ПО
	|							СправочникПользователи.Ссылка = СведенияОПользователях.Пользователь
	|								И СведенияОПользователях.Подразделение = &Подразделение
	|				ГДЕ
	|					СправочникПользователи.Недействителен = ЛОЖЬ))
	|	И (НЕ &ИспользоватьГруппыПользователей
	|			ИЛИ &ГруппаПользователей = ЗНАЧЕНИЕ(Справочник.ГруппыПользователей.ВсеПользователи)
	|			ИЛИ ИсполнителиЗадач.Исполнитель В
	|				(ВЫБРАТЬ
	|					СправочникПользователи.Ссылка
	|				ИЗ
	|					Справочник.Пользователи КАК СправочникПользователи
	|						ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыПользователей.Состав КАК ГруппыПользователейСостав
	|						ПО
	|							СправочникПользователи.Ссылка = ГруппыПользователейСостав.Пользователь
	|								И ГруппыПользователейСостав.Ссылка = &ГруппаПользователей))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СправочникПользователи.Ссылка,
	|	СправочникПользователи.ПометкаУдаления,
	|	СправочникПользователи.Предопределенный,
	|	СправочникПользователи.Наименование,
	|	NULL,
	|	NULL,
	|	ИСТИНА,
	|	ЛОЖЬ
	|ИЗ
	|	Справочник.ГруппыПользователей КАК ГруппыПользователей
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК СправочникПользователи
	|		ПО ГруппыПользователей.ПриемникЗадач = СправочникПользователи.Ссылка
	|ГДЕ
	|	ГруппыПользователей.Ссылка = &ГруппаПользователей");
				   
	Запрос.УстановитьПараметр("Подразделение", ТекущееПодразделение);
	Запрос.УстановитьПараметр("ГруппаПользователей", ТекущаяГруппаПользователей);
	Запрос.УстановитьПараметр("ПоказыватьРоли", ПоказыватьРоли);
	Если ВидПросмотра = НСтр("ru = 'Списком'") Тогда
		Запрос.УстановитьПараметр("ИспользоватьИерархию", Ложь);
		Запрос.УстановитьПараметр("ИспользоватьГруппыПользователей", Ложь);
	ИначеЕсли ВидПросмотра = НСтр("ru = 'По подразделениям'") Тогда
		Запрос.УстановитьПараметр("ИспользоватьИерархию", Истина);
		Запрос.УстановитьПараметр("ИспользоватьГруппыПользователей", Ложь);
	ИначеЕсли ВидПросмотра = НСтр("ru = 'По группам пользователей'") Тогда
		Запрос.УстановитьПараметр("ИспользоватьИерархию", Ложь);
		Запрос.УстановитьПараметр("ИспользоватьГруппыПользователей", Истина);
	Иначе
		ВызватьИсключение "Некорректный вид просмотра";
	КонецЕсли;
	Результат = Запрос.Выполнить();
	СписокВыгрузки = Результат.Выгрузить();
	
	ТекПользователь = Неопределено;
	Если Элементы.СписокПользователи.ТекущаяСтрока <> Неопределено Тогда
		ТекПользователь = СписокПользователи.НайтиПоИдентификатору(Элементы.СписокПользователи.ТекущаяСтрока).Ссылка;
	КонецЕсли;
	СписокПользователи.Очистить();
	СписокПользователи.Загрузить(СписокВыгрузки);
	Если ЗначениеЗаполнено(ТекПользователь) Тогда
		МассивСтрок = СписокПользователи.НайтиСтроки(Новый Структура("Ссылка", ТекПользователь));
		Если МассивСтрок.Количество() > 0 Тогда
			Элементы.СписокПользователи.ТекущаяСтрока = МассивСтрок[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьДеревоКорреспондентов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА ИСТИНА
	|			ТОГДА КонтактныеЛица.Ссылка
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	КОНЕЦ КАК Ссылка,
	|	КонтактныеЛица.Наименование,
	|	КонтактныеЛица.Владелец КАК Владелец,
	|	КонтактныеЛица.Должность,
	|	ЛОЖЬ КАК ЭтоГруппа,
	|	КонтактныеЛица.Владелец.ПометкаУдаления КАК ВладелецПометкаУдаления,
	|	КонтактныеЛица.Владелец.ЭтоГруппа КАК ВладелецЭтоГруппа,
	|	ВЫБОР
	|		КОГДА КонтактныеЛица.ПометкаУдаления
	|			ТОГДА 3
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК ИндексКартинки
	|ИЗ
	|	Справочник.КонтактныеЛица КАК КонтактныеЛица
	|ИТОГИ ПО
	|	Владелец ИЕРАРХИЯ";
	
	ДеревоКорреспонденты = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	Для Каждого Строка Из ДеревоКорреспонденты.Строки Цикл
		ЗаполнитьСтрокуДереваКорреспонтов(Строка);
	КонецЦикла;	
	
	ДеревоКорреспонденты.Колонки.Удалить(ДеревоКорреспонденты.Колонки.Владелец);
	ДеревоКорреспонденты.Колонки.Удалить(ДеревоКорреспонденты.Колонки.ВладелецПометкаУдаления);
	ДеревоКорреспонденты.Колонки.Удалить(ДеревоКорреспонденты.Колонки.ВладелецЭтоГруппа);
	
	ЗначениеВРеквизитФормы(ДеревоКорреспонденты, "СписокКорреспонденты");
	
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьСтрокуДереваКорреспонтов(СтрокаДерева)
	
	Если Не ЗначениеЗаполнено(СтрокаДерева.Ссылка) Тогда 
		СтрокаДерева.Ссылка = СтрокаДерева.Владелец;
		СтрокаДерева.Наименование = Строка(СтрокаДерева.Владелец);
		СтрокаДерева.ЭтоГруппа = СтрокаДерева.ВладелецЭтоГруппа;
		Если СтрокаДерева.ВладелецЭтоГруппа Тогда 
			Если СтрокаДерева.ВладелецПометкаУдаления Тогда 
				СтрокаДерева.ИндексКартинки = 1;
			Иначе	
			    СтрокаДерева.ИндексКартинки = 0;
			КонецЕсли;	
		Иначе
			Если СтрокаДерева.ВладелецПометкаУдаления Тогда 
				СтрокаДерева.ИндексКартинки = 3;
			Иначе	
			    СтрокаДерева.ИндексКартинки = 2;
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;	
	
	Для каждого Строка Из СтрокаДерева.Строки цикл
		ЗаполнитьСтрокуДереваКорреспонтов(Строка);
	КонецЦикла;	
	
КонецПроцедуры	


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура СтруктураПредприятияПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
КонецПроцедуры


&НаКлиенте
Процедура СписокПользователиВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(Элемент.ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.Пользователи") Тогда
		ВыборПользователя(Элемент.ТекущиеДанные.Ссылка);
	Иначе	
		ВыборРоли(Элемент.ТекущиеДанные.Ссылка, Элементы.СтруктураПредприятия.ТекущаяСтрока);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыборГруппыПользователей(Значение);
КонецПроцедуры

&НаКлиенте
Процедура СписокРолиВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыборРоли(Значение);
КонецПроцедуры

&НаКлиенте
Процедура СписокФункцийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборФункции(ВыбраннаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	Если ПустаяСтрока(АдресВременногоХранилища) Тогда
		Результат = Новый Массив;
		Для каждого ВыбранныеСтрока Из Выбранные Цикл
			Участник = Новый Структура("Исполнитель, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации");
			ЗаполнитьЗначенияСвойств(Участник, ВыбранныеСтрока);
			Результат.Добавить(Участник);
		КонецЦикла;
		ОповеститьОВыборе(Результат);
		Возврат;
	КонецЕсли;
	ПоместитьИсполнителейВоВременноеХранилище();
	ОповеститьОВыборе(АдресВременногоХранилища);
КонецПроцедуры

&НаСервере
Процедура ПоместитьИсполнителейВоВременноеХранилище()
	ПоместитьВоВременноеХранилище(Выбранные.Выгрузить(), АдресВременногоХранилища);
КонецПроцедуры	

&НаКлиенте
Процедура ВыбранныеПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение)=Тип("ДанныеФормыЭлементКоллекции")
		И ПараметрыПеретаскивания.Значение.Свойство("Ссылка") Тогда
		Если ТипЗнч(ПараметрыПеретаскивания.Значение.Ссылка) = Тип("СправочникСсылка.Пользователи") Тогда 
			ВыборПользователя(ПараметрыПеретаскивания.Значение.Ссылка); 
		ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение.Ссылка) = Тип("СправочникСсылка.РолиИсполнителей") Тогда 
			ВыборРоли(ПараметрыПеретаскивания.Значение.Ссылка);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("СправочникСсылка.ГруппыПользователей") Тогда 
		ВыборГруппыПользователей(ПараметрыПеретаскивания.Значение); 

	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("СправочникСсылка.РолиИсполнителей") Тогда 
		ВыборРоли(ПараметрыПеретаскивания.Значение);
		
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Число") Тогда 
		ВыборФункции(ПараметрыПеретаскивания.Значение);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура СписокПользователиПередНачаломИзменения(Элемент, Отказ)
	ПоказатьЗначение(Неопределено, Элементы.СписокПользователи.ТекущиеДанные.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ВидПросмотраПриИзменении(Элемент)
	
	Если ВидПросмотра = НСтр("ru = 'Списком'") Тогда
		ТекущаяГруппаПользователей = Неопределено;
		ТекущееПодразделение = Неопределено;
	ИначеЕсли ВидПросмотра = НСтр("ru = 'По подразделениям'") Тогда
		ТекущаяГруппаПользователей = Неопределено;
		Если ЗначениеЗаполнено(Элементы.СписокПользователи.ТекущаяСтрока) Тогда
			ВрПодразделение = СписокПользователи.НайтиПоИдентификатору(Элементы.СписокПользователи.ТекущаяСтрока).Подразделение;
		Иначе
			ВрПодразделение = Неопределено;
		КонецЕсли;
		Элементы.СтруктураПредприятия.ТекущаяСтрока = ВрПодразделение;
		ТекущееПодразделение = Элементы.СтруктураПредприятия.ТекущаяСтрока;
	ИначеЕсли ВидПросмотра = НСтр("ru = 'По группам пользователей'") Тогда
		ТекущееПодразделение = Неопределено;
		Элементы.ГруппыПользователей.ТекущаяСтрока = ПредопределенноеЗначение("Справочник.ГруппыПользователей.ВсеПользователи");
		ТекущаяГруппаПользователей = Элементы.ГруппыПользователей.ТекущаяСтрока;
	Иначе
		ВызватьИсключение "Некорректный вид просмотра";
	КонецЕсли;
	
	ОтобразитьИерархию();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокКорреспондентыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	ВыборКорреспондента(ТекущиеДанные);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьМоиКонтакты()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СправочникГруппыЛичныхАдресатов.Ссылка КАК ГруппаСсылка,
		|	СправочникГруппыЛичныхАдресатов.ПометкаУдаления КАК ГруппаПометкаУдаления,
		|	СправочникГруппыЛичныхАдресатов.Предопределенный КАК ГруппаПредопределенный,
		|	СправочникГруппыЛичныхАдресатов.Наименование КАК ГруппаНаименование,
		|	ЛичныеАдресаты.Ссылка КАК ЛичныеАдресатыСсылка,
		|	ЛичныеАдресаты.ПометкаУдаления КАК ЛичныеАдресатыПометкаУдаления,
		|	ЛичныеАдресаты.Наименование КАК ЛичныеАдресатыНаименование,
		|	ЛичныеАдресаты.КонтактнаяИнформация.(
		|		Тип,
		|		АдресЭП
		|	)
		|ИЗ
		|	Справочник.ГруппыЛичныхАдресатов КАК СправочникГруппыЛичныхАдресатов
		|		ПОЛНОЕ СОЕДИНЕНИЕ Справочник.ЛичныеАдресаты КАК ЛичныеАдресаты
		|		ПО СправочникГруппыЛичныхАдресатов.Ссылка = ЛичныеАдресаты.Группа
		|ГДЕ
		|	ЕСТЬNULL(СправочникГруппыЛичныхАдресатов.Пользователь, ЛичныеАдресаты.Пользователь) = &Пользователь
		|	И ЕСТЬNULL(ЛичныеАдресаты.Пользователь, СправочникГруппыЛичныхАдресатов.Пользователь) = &Пользователь
		|	И ЛичныеАдресаты.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ГруппаСсылка ИЕРАРХИЯ,
		|	ЛичныеАдресатыНаименование";
		
	Запрос.УстановитьПараметр("Пользователь", ПользователиКлиентСервер.ТекущийПользователь());
	ВыборкаДерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	ДеревоКонтактов.ПолучитьЭлементы().Очистить();
	КореньДерева = ДеревоКонтактов.ПолучитьЭлементы();
	ВеткиДереваДляГрупп = Новый Соответствие;
	
	ВыборкаДерево.Строки.Сортировать("ГруппаНаименование, ЛичныеАдресатыНаименование");
	Для Каждого СтрокаВыборкиДерево Из ВыборкаДерево.Строки Цикл
		
		ЗаполнитьЛистДереваМоиКонтакты(СтрокаВыборкиДерево, КореньДерева, ВеткиДереваДляГрупп);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЛистДереваМоиКонтакты(Выборка, КореньДерева, ВеткиДереваДляГрупп);
	
	СтрокаДереваГруппы = Неопределено;
	ЭлементыДляДобавленияПользователей = КореньДерева;
	
	Если ЗначениеЗаполнено(Выборка.ГруппаСсылка) Тогда
	
		СтрокаДереваГруппы = ВеткиДереваДляГрупп.Получить(Выборка.ГруппаСсылка);
		Если СтрокаДереваГруппы = Неопределено Тогда
			
			СтрокаДереваГруппы = КореньДерева.Добавить();
			ВеткиДереваДляГрупп.Вставить(Выборка.ГруппаСсылка, СтрокаДереваГруппы);
			
			СтрокаДереваГруппы.Наименование = Выборка.ГруппаНаименование;
			СтрокаДереваГруппы.Группа = Выборка.ГруппаСсылка;
			СтрокаДереваГруппы.Ссылка = Выборка.ГруппаСсылка;
			СтрокаДереваГруппы.НомерКартинки = ?(Выборка.ГруппаПометкаУдаления, 2, 3);
			СтрокаДереваГруппы.Представление = СтрокаДереваГруппы.Наименование;
			
		КонецЕсли;
		
		ЭлементыДляДобавленияПользователей = СтрокаДереваГруппы.ПолучитьЭлементы();
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Выборка.ЛичныеАдресатыСсылка) Тогда
		
		СтрокаДереваПользователь = ЭлементыДляДобавленияПользователей.Добавить();
		
		СтрокаДереваПользователь.Наименование = Выборка.ЛичныеАдресатыНаименование;
		СтрокаДереваПользователь.Группа = Выборка.ГруппаСсылка;
		СтрокаДереваПользователь.Ссылка = Выборка.ЛичныеАдресатыСсылка;
		СтрокаДереваПользователь.НомерКартинки = ?(Выборка.ЛичныеАдресатыПометкаУдаления = Истина, 0, 1);
		СтрокаДереваПользователь.ЭтоАдресат = Истина;
		
		Для Каждого СтрокаКонтактнойИнформации Из Выборка.КонтактнаяИнформация Цикл
			Если СтрокаКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
				СтрокаДереваПользователь.АдресEmail = СтрокаКонтактнойИнформации.АдресЭП;
				Прервать;
			КонецЕсли;	
		КонецЦикла;
		
		Если Не ЗначениеЗаполнено(СтрокаДереваПользователь.АдресEmail) Тогда
			СтрокаДереваПользователь.НомерКартинки = 4;
		КонецЕсли;	
		
		СтрокаДереваПользователь.Представление = РаботаСоСтроками.ПолучитьПредставлениеАдресаЭлектроннойПочты(
				Строка(СтрокаДереваПользователь.Наименование),
				СтрокаДереваПользователь.АдресEmail);
		
	КонецЕсли;	
	
	Выборка.Строки.Сортировать("ГруппаНаименование, ЛичныеАдресатыНаименование");
	Для Каждого СтрокаВыборкиДерево Из Выборка.Строки Цикл
		
		ЗаполнитьЛистДереваМоиКонтакты(СтрокаВыборкиДерево, 
			СтрокаДереваГруппы.ПолучитьЭлементы(), ВеткиДереваДляГрупп);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКонтактовПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ПоказатьЗначение(Неопределено, Элементы.ДеревоКонтактов.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКонтактовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	ВыборЛичногоАдресата(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборЛичногоАдресата(ВыбранноеЗначение)
	
	ПараметрыОтбора = Новый Структура("Исполнитель", ВыбранноеЗначение);
	Если Выбранные.НайтиСтроки(ПараметрыОтбора).Количество() > 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Личный адресат ""%1"" уже выбран!'"),
			Строка(ВыбранноеЗначение));
		
		ПоказатьПредупреждение(Неопределено, ТекстСообщения);
		
	Иначе
		НоваяСтрока = Выбранные.Добавить();
		НоваяСтрока.Исполнитель = ВыбранноеЗначение;
		Элементы.Выбранные.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	КонецЕсли;	
	
КонецПроцедуры
