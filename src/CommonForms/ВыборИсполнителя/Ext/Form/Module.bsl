﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастроитьВидПросмотра();
	
	Если Не Параметры.Свойство("Заголовок", Заголовок) Тогда
		Заголовок = НСтр("ru = 'Выбор исполнителя'");
	КонецЕсли;
	
	Если Не Параметры.Свойство("ВыбиратьГруппуПользователей", ВыбиратьГруппуПользователей) Тогда
		ВыбиратьГруппуПользователей = Ложь;
	КонецЕсли;
	
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
	
	Если Параметры.Свойство("Исполнитель") И ЗначениеЗаполнено(Параметры.Исполнитель) Тогда
		УстановитьПозициюНаИсполнителя(Параметры.Исполнитель);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВидПросмотра()
	
	Элементы.ВидПросмотра.СписокВыбора.Очистить();
	Элементы.ВидПросмотра.СписокВыбора.Добавить(НСтр("ru = 'Списком'"));
	Элементы.ВидПросмотра.СписокВыбора.Добавить(НСтр("ru = 'По подразделениям'"));
	//Элементы.ВидПросмотра.СписокВыбора.Добавить(НСтр("ru = 'По группам пользователей'"));
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей") = Истина Тогда
		Элементы.ВидПросмотра.СписокВыбора.Добавить(НСтр("ru = 'По группам пользователей'"));
	КонецЕсли;

	//ВидПросмотра = ХранилищеСистемныхНастроек.Загрузить(ИмяФормы, "ВидПросмотра");
	Если Элементы.ВидПросмотра.СписокВыбора.НайтиПоЗначению(ВидПросмотра) = Неопределено Тогда
		ВидПросмотра = ?(ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей"),НСтр("ru = 'По группам пользователей'"),НСтр("ru = 'По подразделениям'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПозициюНаИсполнителя(Исполнитель)
	
	Если ТипЗнч(Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.Пользователи;
		Подразделение = РаботаСПользователями.ПолучитьПодразделение(Исполнитель);
		Если Не Подразделение.Пустая() И не ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей") Тогда
			ВидПросмотра = НСтр("ru = 'По подразделениям'");			
			Элементы.СтруктураПредприятия.ТекущаяСтрока = Подразделение;
			ТекущееПодразделение = Элементы.СтруктураПредприятия.ТекущаяСтрока;
			ОтобразитьИерархию();
			
			МассивСтрок = СписокПользователи.НайтиСтроки(Новый Структура("Ссылка", Исполнитель));
			Если МассивСтрок.Количество() = 1 Тогда
				Элементы.СписокПользователи.ТекущаяСтрока = МассивСтрок[0].ПолучитьИдентификатор();
			КонецЕсли;
		ИначеЕсли ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей") Тогда
			ВидПросмотра = НСтр("ru = 'По группам пользователей'");
			ТекущаяГруппаПользователей = Элементы.ГруппыПользователей.ТекущаяСтрока;
			
			МассивСтрок = СписокПользователи.НайтиСтроки(Новый Структура("Ссылка", Исполнитель));
			Если МассивСтрок.Количество() = 1 Тогда
				Элементы.СписокПользователи.ТекущаяСтрока = МассивСтрок[0].ПолучитьИдентификатор();
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Исполнитель) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.Пользователи;
		ВидПросмотра = НСтр("ru = 'По группам пользователей'");
		Элементы.ГруппыПользователей.ТекущаяСтрока = Исполнитель;
		ТекущаяГруппаПользователей = Элементы.ГруппыПользователей.ТекущаяСтрока;
		ОтобразитьИерархию();
		
	ИначеЕсли ТипЗнч(Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
		ОсновнойОбъектАдресации = Неопределено;
		Если Параметры.Свойство("ОсновнойОбъектАдресации") Тогда
			ОсновнойОбъектАдресации = Параметры.ОсновнойОбъектАдресации;
		КонецЕсли;
		
		ДополнительныйОбъектАдресации = Неопределено;
		Если Параметры.Свойство("ДополнительныйОбъектАдресации") Тогда
			ДополнительныйОбъектАдресации = Параметры.ДополнительныйОбъектАдресации;
		КонецЕсли;
		
		РольРазмещенаНаЗакладкеПользователи = Ложь;
		Если ОсновнойОбъектАдресации <> Неопределено Или ДополнительныйОбъектАдресации <> Неопределено Тогда
			ТаблицаПользователи = РаботаСПользователями.ПолучитьПользователейРоли(Исполнитель, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации);
			Если ТаблицаПользователи.Количество() = 1 Тогда
				Пользователь = ТаблицаПользователи[0].Исполнитель;
				Подразделение = РаботаСПользователями.ПолучитьПодразделение(Пользователь);
				Если Не Подразделение.Пустая() Тогда
					Элементы.Страницы.ТекущаяСтраница = Элементы.Пользователи;
					ВидПросмотра = НСтр("ru = 'По подразделениям'");
					Элементы.СтруктураПредприятия.ТекущаяСтрока = Подразделение;
					ТекущееПодразделение = Элементы.СтруктураПредприятия.ТекущаяСтрока;
					ОтобразитьИерархию();
					
					МассивСтрок = СписокПользователи.НайтиСтроки(Новый Структура("Ссылка", Исполнитель));
					Если МассивСтрок.Количество() = 1 Тогда
						Элементы.СписокПользователи.ТекущаяСтрока = МассивСтрок[0].ПолучитьИдентификатор();
					КонецЕсли;		
					
					РольРазмещенаНаЗакладкеПользователи = Истина;
					
				КонецЕсли;		
			
			КонецЕсли;		
			
		КонецЕсли;	
		
		Если Не РольРазмещенаНаЗакладкеПользователи Тогда
			Элементы.СписокРоли.ТекущаяСтрока = Исполнитель;
			Элементы.Страницы.ТекущаяСтраница = Элементы.Роли;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Исполнитель) = Тип("Строка") Тогда 
		Элементы.Страницы.ТекущаяСтраница = Элементы.Функции;
		Для Инд = 0 По СписокФункций.Количество() - 1 Цикл
			Если СписокФункций[Инд].Представление = Исполнитель Тогда 
				Элементы.СписокФункций.ТекущаяСтрока = Инд;
				Прервать;
			КонецЕсли;
		КонецЦикла;	
		
	ИначеЕсли ТипЗнч(Исполнитель) = Тип("СправочникСсылка.КонтактныеЛица")
		Или ТипЗнч(Исполнитель) = Тип("СправочникСсылка.Контрагенты") Тогда 
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.Корреспонденты;
		
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
Процедура Выбрать(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Пользователи Тогда
		Если ТекущийЭлемент.Имя = "ГруппыПользователей" И ВыбиратьГруппуПользователей Тогда
			Если Элементы.ГруппыПользователей.ТекущаяСтрока <> Неопределено Тогда
				ОповеститьОВыборе(Элементы.ГруппыПользователей.ТекущаяСтрока);
			КонецЕсли;
		Иначе
			Если Элементы.СписокПользователи.ТекущаяСтрока <> Неопределено Тогда
				Если ТипЗнч(Элементы.СписокПользователи.ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.Пользователи") Тогда
					ОповеститьОВыборе(Элементы.СписокПользователи.ТекущиеДанные.Ссылка);
				ИначеЕсли ТипЗнч(Элементы.СписокПользователи.ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
					ВыборРоли(Элементы.СписокПользователи.ТекущиеДанные.Ссылка, Элементы.СтруктураПредприятия.ТекущаяСтрока);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Роли Тогда
		ВыборРоли(Элементы.СписокРоли.ТекущаяСтрока);
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Функции Тогда
		ВыбраннаяСтрока = Элементы.СписокФункций.ТекущаяСтрока;
		ФункцияИсполнитель = СписокФункций[ВыбраннаяСтрока].Представление;
		ОповеститьОВыборе(ФункцияИсполнитель);
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппыПользователей Тогда
		ОповеститьОВыборе(Элементы.СписокГруппПользователей.ТекущаяСтрока);
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Корреспонденты Тогда 	
		
		ТекущиеДанные = Элементы.СписокКорреспонденты.ТекущиеДанные;
		
		Если ТекущиеДанные = Неопределено Тогда 
			Возврат;
		КонецЕсли;	
		
		Если ТекущиеДанные.ЭтоГруппа Тогда 
			Возврат;
		КонецЕсли;	
	
		ОповеститьОВыборе(ТекущиеДанные.Ссылка);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Функция ВыборРоли(ВыбранноеЗначение, СтруктураПредприятияТекущаяСтрока = Неопределено)
	
	ПараметрыРоли = РаботаСПользователями.ПолучитьПараметрыРоли(ВыбранноеЗначение, СтруктураПредприятияТекущаяСтрока);
	
	Результат = Неопределено;
	
	Если Не ПараметрыРоли.ИспользуетсяСОбъектамиАдресации Тогда 
		Результат = Новый Структура("РольИсполнителя, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации", ВыбранноеЗначение, Неопределено, Неопределено);
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
				Результат = Новый Структура("РольИсполнителя, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации", 
					ВыбранноеЗначение, ПараметрыРоли.ОсновнойОбъектАдресации, ПараметрыРоли.ДополнительныйОбъектАдресации);
			КонецЕсли;		
			
		КонецЕсли;	
		
		Если ТипЗнч(Результат) <> Тип("Структура") Тогда
			Результат = ОткрытьФормуМодально("ОбщаяФорма.ВыборРолиИсполнителя", 
				Новый Структура("РольИсполнителя, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации", 
				ВыбранноеЗначение, ПараметрыРоли.ОсновнойОбъектАдресации, ПараметрыРоли.ДополнительныйОбъектАдресации), ЭтотОбъект);
		КонецЕсли;
		
	КонецЕсли;	
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ОповеститьОВыборе(Результат);
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УстановитьИерархиюБезЗаполненияПользователей(Отметка)
	
	Если Отметка = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Элементы.ИспользоватьИерархию.Пометка = Отметка;
	Если Отметка = Истина Тогда
		Элементы.СтраницыГруппировкаПользователей.Видимость = Истина;
		Элементы.СтраницыГруппировкаПользователей.ТекущаяСтраница = Элементы.СтраницаСтруктураПредприятия;
	Иначе
		Элементы.СтраницыГруппировкаПользователей.Видимость = Ложь;
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
Процедура СписокПользователиВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(Элемент.ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.Пользователи") Тогда
		ОповеститьОВыборе(Элемент.ТекущиеДанные.Ссылка);
	Иначе	
		ВыборРоли(Элемент.ТекущиеДанные.Ссылка, Элементы.СтруктураПредприятия.ТекущаяСтрока);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРолиВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборРоли(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФункцийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ФункцияИсполнитель = СписокФункций[ВыбраннаяСтрока].Представление;
	ОповеститьОВыборе(ФункцияИсполнитель);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПользователиПередНачаломИзменения(Элемент, Отказ)
	ПоказатьЗначение(Неопределено, Элементы.СписокПользователи.ТекущиеДанные.Ссылка);
КонецПроцедуры


&НаКлиенте
Процедура ГруппыПользователейПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователейВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	Если ВыбиратьГруппуПользователей Тогда
		ОповеститьОВыборе(Элементы.ГруппыПользователей.ТекущаяСтрока);
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
	|	ЛОЖЬ КАК ЭтоРуководитель,
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
	|	ГруппыПользователей.Ссылка = &ГруппаПользователей
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
	|								И ГруппыПользователейСостав.Ссылка = &ГруппаПользователей))");
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
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ТекущиеДанные.ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;	
	
	ОповеститьОВыборе(ТекущиеДанные.Ссылка);
	
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
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Не ТекущиеДанные.ЭтоАдресат Тогда 
		Возврат;
	КонецЕсли;	
	
	ОповеститьОВыборе(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

