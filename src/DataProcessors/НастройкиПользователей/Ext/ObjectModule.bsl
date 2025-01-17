﻿////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции, отвечающие за копирование и удаление настроек

// Копирует пользовательские настройки отчетов 
// 
// Параметры
// ПользовательИсточник - Строка - Имя пользователя информационной базы, от которого берутся настройки для копирования
// ПользователиПриемник - Массив элементов ПользовательСсылка - Пользователи, которым необходимо скопировать выбранные настройки
// МассивНастроекДляКопирования - Массив - элемент массива - СписокЗначений, в котором содержатся ключи выбранных настроек
//
Процедура СкопироватьНастройкиОтчетовИПерсональныеНастройки(МенеджерНастроек, ПользовательИсточник,
			ПользователиПриемник, МассивНастроекДляКопирования) Экспорт
	
	Для Каждого Элемент Из МассивНастроекДляКопирования Цикл
		
		Для Каждого ЭлементНастроек Из Элемент Цикл
			КлючНастроек = ЭлементНастроек.Представление;
			КлючОбъекта = ЭлементНастроек.Значение;
			Настройка = МенеджерНастроек.Загрузить(КлючОбъекта, КлючНастроек, , ПользовательИсточник);
			ОписаниеНастройки = МенеджерНастроек.ПолучитьОписание(КлючОбъекта, КлючНастроек, ПользовательИсточник);
			
			Если Настройка <> Неопределено Тогда
				
				Для Каждого ПользовательПриемник Из ПользователиПриемник Цикл
					ПользовательПриемникИБ = Обработки.НастройкиПользователей.ИмяПользователяИБ(ПользовательПриемник);
					МенеджерНастроек.Сохранить(КлючОбъекта, КлючНастроек, Настройка, ОписаниеНастройки, ПользовательПриемникИБ);
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Копирует настройки внешнего вида 
// 
// Параметры
// ПользовательИсточник - Строка - Имя пользователя информационной базы, от которого берутся настройки для копирования
// ПользователиПриемник - Массив элементов ПользовательСсылка - Пользователи, которым необходимо скопировать выбранные настройки
// МассивНастроекДляКопирования - Массив - элемент массива - СписокЗначений, в котором содержатся ключи выбранных настроек
//
Процедура СкопироватьНастройкиВнешнегоВида(ПользовательИсточник, ПользователиПриемник, МассивНастроекДляКопирования) Экспорт
	МассивНастроекФорм = ПредопределенныеНастройки();
	
	Для Каждого Элемент Из МассивНастроекДляКопирования Цикл
		Для Каждого ЭлементНастроек Из Элемент Цикл
			КлючНастроек = ЭлементНастроек.Представление;
			КлючОбъекта = ЭлементНастроек.Значение;
			Если КлючНастроек = "Интерфейс"
				Или КлючНастроек = "Прочие" Тогда
				СкопироватьНастройкиРабочегоСтола(КлючОбъекта, ПользовательИсточник, ПользователиПриемник);
				Продолжить;
			КонецЕсли;
			
			Для Каждого Элемент Из МассивНастроекФорм Цикл
				Настройка = ХранилищеСистемныхНастроек.Загрузить(КлючОбъекта + Элемент, КлючНастроек, , ПользовательИсточник);
				Если Настройка <> Неопределено Тогда
					Для Каждого ПользовательПриемник Из ПользователиПриемник Цикл
						ПользовательПриемникИБ = Обработки.НастройкиПользователей.ИмяПользователяИБ(ПользовательПриемник);
						ХранилищеСистемныхНастроек.Сохранить(КлючОбъекта + Элемент, КлючНастроек, Настройка, , ПользовательПриемникИБ);
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура СкопироватьНастройкиРабочегоСтола(КлючОбъекта, ПользовательИсточник, ПользователиПриемник)
	
	Настройка = ХранилищеСистемныхНастроек.Загрузить(КлючОбъекта, "", , ПользовательИсточник);
	Если Настройка <> Неопределено Тогда
		Для Каждого ПользовательПриемник Из ПользователиПриемник Цикл
			ПользовательПриемникИБ = Обработки.НастройкиПользователей.ИмяПользователяИБ(ПользовательПриемник);
			ХранилищеСистемныхНастроек.Сохранить(КлючОбъекта, "", Настройка, , ПользовательПриемникИБ);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьНастройкиВыбраннымПользователям(Пользователи, МассивНастроекДляУдаления, НазваниеХранилища) Экспорт
	
	Для Каждого Пользователь Из Пользователи Цикл
		Пользователь = Обработки.НастройкиПользователей.ИмяПользователяИБ(Пользователь);
		УдалитьНастройки(Пользователь, МассивНастроекДляУдаления, НазваниеХранилища);
	КонецЦикла;
	
КонецПроцедуры

// Удаляет выбранные настройки 
// 
// Параметры
// Пользователь - Строка - Имя пользователя информационной базы, у которого необходимо удалить настройки
// МассивНастроекДляУдаления - Массив - элемент массива - СписокЗначений, в котором содержатся ключи выбранных настроек
// НазваниеХранилища - Строка - название хранилища, из которого необходимо удалить настройки
//
Процедура УдалитьНастройки(Пользователь, МассивНастроекДляУдаления, НазваниеХранилища) Экспорт
	
	МенеджерНастроек = ХранилищеНастроекПоИмени(НазваниеХранилища);
	Если НазваниеХранилища = "ХранилищеПользовательскихНастроекОтчетов"
		Или НазваниеХранилища = "ХранилищеОбщихНастроек" Тогда
		
		Для Каждого Элемент Из МассивНастроекДляУдаления Цикл
			
			Для Каждого Настройка Из Элемент Цикл
				МенеджерНастроек.Удалить(Настройка.Значение, Настройка.Представление, Пользователь);
			КонецЦикла;
			
		КонецЦикла;
		
	ИначеЕсли НазваниеХранилища = "ХранилищеСистемныхНастроек" Тогда
		МассивНастроекФорм = ПредопределенныеНастройки();
		Для Каждого Элемент Из МассивНастроекДляУдаления Цикл
			
			Для Каждого Настройка Из Элемент Цикл
				
				Если Настройка.Представление = "Интерфейс" 
					Или Настройка.Представление = "Прочие" Тогда
					МенеджерНастроек.Удалить(Настройка.Значение, , Пользователь);
				Иначе
					Для Каждого ЭлементФорм Из МассивНастроекФорм Цикл
						МенеджерНастроек.Удалить(Настройка.Значение + ЭлементФорм, Настройка.Представление, Пользователь);
					КонецЦикла;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для получения списка пользователей и групп пользователей

// Получает список пользователей из справочника Пользователи, отсеивая недействительных пользователей, неразделенных
// пользователей при включенном разделителе, а так же пользователей с пустым идентификатором
// 
// Параметры
// ПользовательИсточник - СправочникСсылка - Пользователь, которого необходимо убрать из итоговой таблицы пользователей
// ТаблицаПользователей - ТаблицаЗначений - Таблица, в которую записываются отобранные пользователи
// ПользовательВнешний - Булево - Если Истина, то отбираются пользователи из справочника ВнешниеПользователи
//
Функция ПользователиДляКопирования(ПользовательИсточник, ТаблицаПользователей, ПользовательВнешний) Экспорт
	
	СписокПользователей = ?(ПользовательВнешний, СписокВсехВнешнихПользователей(ПользовательИсточник), 
		СписокВсехПользователей(ПользовательИсточник)); 
	Для Каждого ПользовательСсылка Из СписокПользователей Цикл
		СтрокаТаблицыПользователей = ТаблицаПользователей.Добавить();
		СтрокаТаблицыПользователей.Пользователь = ПользовательСсылка.Пользователь;
	КонецЦикла;
	ТаблицаПользователей.Сортировать("Пользователь Возр");
	
	Возврат ТаблицаПользователей;
	
КонецФункции

Функция СписокВсехПользователей(ПользовательИсточник)
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Пользователь
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	НЕ Пользователи.Недействителен
	|	И НЕ Пользователи.Служебный
	|	И НЕ Пользователи.ПометкаУдаления
	|	И Пользователи.Ссылка <> &ПользовательИсточник
	|	И Пользователи.ИдентификаторПользователяИБ <> &ПустойИдентификаторПользователяИБ";
	Запрос.Параметры.Вставить("ПользовательИсточник", ПользовательИсточник);
	Запрос.Параметры.Вставить("ПустойИдентификаторПользователяИБ", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция СписокВсехВнешнихПользователей(ПользовательИсточник)
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Пользователь
	|ИЗ
	|	Справочник.ВнешниеПользователи КАК Пользователи
	|ГДЕ
	|	НЕ Пользователи.Недействителен
	|	И НЕ Пользователи.ПометкаУдаления
	|	И Пользователи.Ссылка <> &ПользовательИсточник
	|	И Пользователи.ИдентификаторПользователяИБ <> &ПустойИдентификаторПользователяИБ";
	Запрос.Параметры.Вставить("ПользовательИсточник", ПользовательИсточник);
	Запрос.Параметры.Вставить("ПустойИдентификаторПользователяИБ", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Формирует дерево значений групп пользователей
// 
// Параметры
// ДеревоГрупп - ДеревоЗначений - Дерево, которое заполняется группами пользователей
// ПользовательВнешний - Булево - Если Истина, то отбираются пользователи из справочника ГруппыВнешнихПользователей
Процедура ЗаполнитьДеревоГрупп(ДеревоГрупп, ПользовательВнешний) Экспорт
	ГруппыМассив = Новый Массив;
	МассивГруппРодителей = Новый Массив;
	СписокГруппИПолныйСостав = ГруппыПользователей(ПользовательВнешний);
	ГруппыПользователейСписок = СписокГруппИПолныйСостав.ГруппыПользователейСписок;
	ТаблицаГруппыИСостав = СписокГруппИПолныйСостав.ТаблицаГруппыИСостав;
	
	ПустаяГруппа = Справочники.ГруппыПользователей.ПустаяСсылка();
	СформироватьОтбор(ГруппыПользователейСписок, ПустаяГруппа, ГруппыМассив);
	
	Пока ГруппыМассив.Количество() > 0 Цикл
		МассивГруппРодителей.Очистить();
		Для Каждого Группа Из ГруппыМассив Цикл
			Если Группа.Родитель = ПустаяГруппа Тогда
				НоваяСтрокаГрупп = ДеревоГрупп.Строки.Добавить();
				НоваяСтрокаГрупп.Группа = Группа.Ссылка;
				СоставГруппы = СоставГруппыПользователей(Группа.Ссылка);
				ПолныйСоставГруппы = ПолныйСоставГруппыПользователей(ТаблицаГруппыИСостав, Группа.Ссылка);
				НоваяСтрокаГрупп.Состав = СоставГруппы;
				НоваяСтрокаГрупп.ПолныйСостав = ПолныйСоставГруппы;
				НоваяСтрокаГрупп.Картинка = 3;
			Иначе
				ГруппаРодитель = ДеревоГрупп.Строки.НайтиСтроки(Новый Структура("Группа", Группа.Родитель), Истина);
				НоваяСтрокаПодчиненныхГрупп = ГруппаРодитель[0].Строки.Добавить();
				НоваяСтрокаПодчиненныхГрупп.Группа = Группа.Ссылка;
				СоставГруппы = СоставГруппыПользователей(Группа.Ссылка);
				ПолныйСоставГруппы = ПолныйСоставГруппыПользователей(ТаблицаГруппыИСостав, Группа.Ссылка);
				НоваяСтрокаПодчиненныхГрупп.Состав = СоставГруппы;
				НоваяСтрокаПодчиненныхГрупп.ПолныйСостав = ПолныйСоставГруппы;
				НоваяСтрокаПодчиненныхГрупп.Картинка = 3;
			КонецЕсли;
			МассивГруппРодителей.Добавить(Группа.Ссылка);
		КонецЦикла;
		ГруппыМассив.Очистить();
		Для Каждого Элемент Из МассивГруппРодителей Цикл
			СформироватьОтбор(ГруппыПользователейСписок, Элемент, ГруппыМассив);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Функция ГруппыПользователей(ПользовательВнешний)
	ГруппыПользователейСписок = Новый ТаблицаЗначений;
	ГруппыПользователейСписок.Колонки.Добавить("Ссылка");
	ГруппыПользователейСписок.Колонки.Добавить("Родитель");
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 	
	"ВЫБРАТЬ
	|	СправочникГруппыПользователей.Ссылка КАК Ссылка,
	|	СправочникГруппыПользователей.Родитель КАК Родитель
	|ИЗ
	|	Справочник.ГруппыПользователей КАК СправочникГруппыПользователей";
	Если ПользовательВнешний Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Справочник.ГруппыПользователей", "Справочник.ГруппыВнешнихПользователей");
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаГруппыПользователей = ГруппыПользователейСписок.Добавить();
		СтрокаГруппыПользователей.Ссылка = Выборка.Ссылка;
		СтрокаГруппыПользователей.Родитель = Выборка.Родитель;
	КонецЦикла; 
	
	ГруппыПользователейСостав = Новый ТаблицаЗначений;
	ГруппыПользователейСостав.Колонки.Добавить("Группа");
	ГруппыПользователейСостав.Колонки.Добавить("Пользователь");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 	
	"ВЫБРАТЬ
	|	СоставыГруппПользователей.ГруппаПользователей КАК ГруппаПользователей,
	|	СоставыГруппПользователей.Пользователь КАК Пользователь
	|ИЗ
	|	РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГруппаПользователей";

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаГруппыПользователейСостав = ГруппыПользователейСостав.Добавить();
		СтрокаГруппыПользователейСостав.Группа = Выборка.ГруппаПользователей;
		СтрокаГруппыПользователейСостав.Пользователь= Выборка.Пользователь;
	КонецЦикла;
	
	ТаблицаГруппыИСостав = СформироватьПолныйСоставГруппПользователей(ГруппыПользователейСостав);
	
	Возврат Новый Структура("ГруппыПользователейСписок, ТаблицаГруппыИСостав", 
							ГруппыПользователейСписок, ТаблицаГруппыИСостав);
КонецФункции

Функция СформироватьПолныйСоставГруппПользователей(ГруппыПользователейСостав)
	ТаблицаГруппыИСостав = Новый ТаблицаЗначений;
	ТаблицаГруппыИСостав.Колонки.Добавить("Группа");
	ТаблицаГруппыИСостав.Колонки.Добавить("Состав");
	СоставГруппы = Новый СписокЗначений;
	ТекущаяГруппа = Неопределено;
	Для Каждого СтрокаСостава Из ГруппыПользователейСостав Цикл
		Если ТипЗнч(СтрокаСостава.Группа) = Тип("СправочникСсылка.ГруппыПользователей")
			Или ТипЗнч(СтрокаСостава.Группа) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") Тогда
			
			Если Не ТекущаяГруппа = СтрокаСостава.Группа 
				И Не ТекущаяГруппа = Неопределено Тогда
				СтрокаТаблицаГруппыИСостав = ТаблицаГруппыИСостав.Добавить();
				СтрокаТаблицаГруппыИСостав.Группа = ТекущаяГруппа;
				СтрокаТаблицаГруппыИСостав.Состав = СоставГруппы.Скопировать();
				СоставГруппы.Очистить();
			КонецЕсли;
			СоставГруппы.Добавить(СтрокаСостава.Пользователь);
			
		ТекущаяГруппа = СтрокаСостава.Группа;
		КонецЕсли;
	КонецЦикла;
	
	СтрокаТаблицаГруппыИСостав = ТаблицаГруппыИСостав.Добавить();
	СтрокаТаблицаГруппыИСостав.Группа = ТекущаяГруппа;
	СтрокаТаблицаГруппыИСостав.Состав = СоставГруппы.Скопировать();
	
	Возврат ТаблицаГруппыИСостав;
КонецФункции

Функция СоставГруппыПользователей(ГруппаСсылка)
	СоставГруппы = Новый СписокЗначений;
	Для Каждого Элемент Из ГруппаСсылка.Состав Цикл
		СоставГруппы.Добавить(Элемент.Пользователь);
	КонецЦикла;
	
	Возврат СоставГруппы;
КонецФункции

Функция ПолныйСоставГруппыПользователей(ТаблицаГруппыИСостав, ГруппаСсылка)
	ПолныйСоставГруппы = ТаблицаГруппыИСостав.НайтиСтроки(Новый Структура("Группа", ГруппаСсылка));
	Если Не ПолныйСоставГруппы.Количество() = 0 Тогда
		Возврат ПолныйСоставГруппы[0].Состав;
	КонецЕсли;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

Функция ПредопределенныеНастройки()
	
	МассивНастроекФорм = Новый Массив;
	МассивНастроекФорм.Добавить("/НастройкиФормы");
	МассивНастроекФорм.Добавить("/НастройкиОкна");
	МассивНастроекФорм.Добавить("/ТекущиеДанные");
	МассивНастроекФорм.Добавить("/НастройкиОкнаВебКлиента");
	
	Возврат МассивНастроекФорм;
КонецФункции

Функция ХранилищеНастроекПоИмени(НазваниеХранилища)
	
	Если НазваниеХранилища = "ХранилищеПользовательскихНастроекОтчетов" Тогда
		Возврат ХранилищеПользовательскихНастроекОтчетов;
	ИначеЕсли НазваниеХранилища = "ХранилищеОбщихНастроек" Тогда
		Возврат ХранилищеОбщихНастроек;
	Иначе
		Возврат ХранилищеСистемныхНастроек;
	КонецЕсли;
	
КонецФункции

Процедура СформироватьОтбор(ГруппыПользователейСписок, ГруппаСсылка, ГруппыМассив)
	ПараметрыОтбора = Новый Структура("Родитель", ГруппаСсылка);
	ОтобранныеСтроки = ГруппыПользователейСписок.НайтиСтроки(ПараметрыОтбора);
	Для Каждого Элемент Из ОтобранныеСтроки Цикл 
		ГруппыМассив.Добавить(Элемент);
	КонецЦикла;
КонецПроцедуры
