﻿#Область ПеременныеФормы

&НаКлиенте
Перем ТекущийЭлементЦвета;

#КонецОбласти

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоОрганизациям") Тогда
		ИспользоватьУчетПоОрганизациям = Истина;
	Иначе
		ИспользоватьУчетПоОрганизациям = Ложь;
	КонецЕсли;
	УстановитьЗначенияПараметров();
	
	Элементы.ФормаВсеКалендари.Видимость			= Пользователи.ЭтоПолноправныйПользователь();
	Элементы.ФормаСписокЗаписейКалендаря.Видимость	= Элементы.ФормаВсеКалендари.Видимость;
	
	ВосстановитьНастройки();
	ПрочитатьДоступныеКалендари();
	ОбновитьДанныеПланировщикаСервер();

КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	Элементы.ОткрытыеЗаявкиОрганизация.Видимость = ИспользоватьУчетПоОрганизациям;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 600);
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжидания()
	ОбновитьСписок();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок()
	УстановитьЗначенияПараметров();
	Элементы.ОткрытыеЗаявки.Обновить();
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	Отказ = Ложь;
	Если не ЗначениеЗаполнено(ЭтотОбъект.ГруппаПользователей) Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Не указана группа пользователей!";
		Сообщение.Поле = "ГруппаПользователей";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	Если не Отказ Тогда
		ОбновитьСписок();
		
		ПрочитатьДоступныеКалендари();
		
		ОбновитьДанныеПланировщикаСервер();

	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытыеЗаявкиПриАктивизацииСтроки(Элемент)
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПараметров()
	ОткрытыеЗаявки.Параметры.УстановитьЗначениеПараметра("ГруппаПользователей", ГруппаПользователей);
КонецПроцедуры

&НаКлиенте
Процедура ГруппаПользователейПриИзменении(Элемент)
	ОбновитьСписок();
	
	ПрочитатьДоступныеКалендари();
	ОбновитьДанныеПланировщикаСервер();
КонецПроцедуры

/////////////////////////////////////////РАБОТА С КАЛЕНДАРЕМ ПЛАНИРОВЩИКА

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ЗаписиКалендаряСотрудника.Форма.НастройкиКалендаря" Тогда
		
		Если ВыбранноеЗначение <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(НастройкиОтображения, ВыбранноеЗначение);
			СохранитьНастройкиИОбновитьДанныеПланировщикаСервер();
		КонецЕсли;
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ВыборЦветаКалендаря" Тогда
		
		Если ТекущийЭлементЦвета <> Неопределено Тогда
			
			ТекущийЭлементЦвета.Картинка = РаботаСЦветомКлиентСервер.КартинкаЦветаПоНомеруКартинки(ВыбранноеЗначение);
			Индекс = Число(Сред(ТекущийЭлементЦвета.Имя, СтрДлина("ЦветКалендарь_")+1));
			ТекКалендарь = ДоступныеКалендари[Индекс];
			ТекКалендарь.ВариантЦвета = ВыбранноеЗначение;
			
			Если ТекКалендарь.Выбран Тогда
				СохранитьНастройкиИОбновитьДанныеПланировщикаСервер();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ИсточникЗаписейКалендаряСотрудника" Тогда
		
		ОбновитьДанныеПланировщикаСервер();
		
	ИначеЕсли ИмяСобытия = "Запись_КалендарьСотрудника" Тогда
		
		ОбработатьЗаписьКалендаряСервер();
				
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВариантПериодаПриИзменении(Элемент)
	
	ВыделитьДатыОтображения(ЭтотОбъект);
	УстановитьПредставлениеПериода(ЭтотОбъект);
	Элементы.ДатаОтображения.Обновить();
	
	СохранитьНастройкиИОбновитьДанныеПланировщикаСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОтображенияПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("ОбновитьДанныеПланировщикаКлиент", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОтображенияПриАктивизацииДаты(Элемент)
	
	ВыделитьДатыОтображения(ЭтотОбъект);
	УстановитьПредставлениеПериода(ЭтотОбъект);
	Элементы.ДатаОтображения.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПередСозданием(Элемент, Начало, Конец, Значения, Текст, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбранныеКалендари = ДоступныеКалендари.НайтиСтроки(Новый Структура("Выбран", Истина));
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Начало", Начало);
	ЗначенияЗаполнения.Вставить("Окончание", Конец);
	Если ВыбранныеКалендари.Количество() = 1 Тогда
		ЗначенияЗаполнения.Вставить("Календарь", ВыбранныеКалендари[0].Календарь);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Справочник.ЗаписиКалендаряСотрудника.Форма.ФормаЭлемента", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПриОкончанииРедактирования(Элемент, НовыйЭлемент, ОтменаРедактирования)
	
	ОбрабатываемыеЭлементы = Новый Массив;
	
	СтруктураПоиска = Новый Структура();
	
	Для Каждого ВыделенныйЭлемент Из Элемент.ВыделенныеЭлементы Цикл
		
		Если ВыделенныйЭлемент.Значение.РедактированиеЗапрещено Тогда
			ОтменаРедактирования = Истина;
			Возврат;
		КонецЕсли;
		
		ОбрабатываемыйЭлемент = Новый Структура;
		ОбрабатываемыйЭлемент.Вставить("ЗаписьКалендаря",		ВыделенныйЭлемент.Значение.ЗаписьКалендаря);
		ОбрабатываемыйЭлемент.Вставить("Источник",				ВыделенныйЭлемент.Значение.Источник);
		ОбрабатываемыйЭлемент.Вставить("НомерСтрокиИсточника",	ВыделенныйЭлемент.Значение.НомерСтрокиИсточника);
		ОбрабатываемыйЭлемент.Вставить("Начало",				ВыделенныйЭлемент.Начало);
		ОбрабатываемыйЭлемент.Вставить("Конец",					ВыделенныйЭлемент.Конец);
		ОбрабатываемыйЭлемент.Вставить("Исполнитель",			ВыделенныйЭлемент.ЗначенияИзмерений.Получить("Сотрудники"));
		
		СтруктураПоиска.Вставить("Сотрудник",ВыделенныйЭлемент.ЗначенияИзмерений.Получить("Сотрудники"));
		МассивСтрок = ДоступныеКалендари.НайтиСтроки(СтруктураПоиска);
		Если МассивСтрок.Количество() > 0 Тогда
			ТекПользователь = МассивСтрок.Получить(0).Пользователь;
		Иначе
			ТекПользователь = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
		КонецЕсли;
		
		ОбрабатываемыйЭлемент.Вставить("Пользователь",			ТекПользователь);
		
		ПользовательКалендаря = ОбрабатываемыйЭлемент.Пользователь;
		Если НЕ ЗначениеЗаполнено(ПользовательКалендаря) Тогда
			Сообщить("Для сотрудника "+ОбрабатываемыйЭлемент.исполнитель+" не удалось определить пользователя!");
			ОтменаРедактирования = Истина;
			Возврат;
		КонецЕсли;					
		 
		ОбрабатываемыеЭлементы.Добавить(ОбрабатываемыйЭлемент);
		
	КонецЦикла;
	
	ОтменаРедактирования = Не СохранитьИзмененияВБазу(ОбрабатываемыеЭлементы);
	Если Не ОтменаРедактирования Тогда
		ОбновитьДанныеПланировщикаСервер();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПередНачаломРедактирования(Элемент, НовыйЭлемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	//Если Не НовыйЭлемент Тогда
	//	Для Каждого ВыделенныйЭлемент Из Элемент.ВыделенныеЭлементы Цикл
	//		Если ВыделенныйЭлемент.Значение.РедактированиеЗапрещено Тогда
	//			Возврат;
	//		КонецЕсли;
	//	КонецЦикла;
	//КонецЕсли;
	
	ОткрытьФормуТекущегоЭлементаПланировщика();
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПередУдалением(Элемент, Отказ)
	
	ОбрабатываемыеЭлементы = Новый Массив;
	ЗаписаноИзменениеЗаявки = Ложь;

	Для Каждого ВыделенныйЭлемент Из Элемент.ВыделенныеЭлементы Цикл
		
		Если ВыделенныйЭлемент.Значение.РедактированиеЗапрещено Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ОбрабатываемыйЭлемент = Новый Структура;
		ОбрабатываемыйЭлемент.Вставить("ЗаписьКалендаря",		ВыделенныйЭлемент.Значение.ЗаписьКалендаря);
		ОбрабатываемыйЭлемент.Вставить("Источник",				ВыделенныйЭлемент.Значение.Источник);
		ОбрабатываемыйЭлемент.Вставить("НомерСтрокиИсточника",	ВыделенныйЭлемент.Значение.НомерСтрокиИсточника);
		ОбрабатываемыйЭлемент.Вставить("ПометкаУдаления",		Истина);
		
		ОбрабатываемыеЭлементы.Добавить(ОбрабатываемыйЭлемент);
			
		Если ТипЗнч(ВыделенныйЭлемент.Значение.Источник) = Тип("ДокументСсылка.Заявка") Тогда
			ЕстьЗаписиПоЗаявкам = истина;
		КонецЕсли;
	КонецЦикла;
	
	Отказ = Не СохранитьИзмененияВБазу(ОбрабатываемыеЭлементы);
	
	Если Не Отказ Тогда
		ОбновитьДанныеПланировщикаСервер();
		Если ЕстьЗаписиПоЗаявкам Тогда
			Оповестить("ЗаписаноИзменениеЗаявки");
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПриСменеТекущегоПериодаОтображения(Элемент, ТекущиеПериодыОтображения, СтандартнаяОбработка)
	
	Если ВариантПериода = "Месяц" Тогда
		
		СтандартнаяОбработка = Ложь;
		ТекущаяДатаСеанса = ОбщегоНазначенияКлиент.ДатаСеанса();
		
		Если ТекущиеПериодыОтображения[0].Начало = НачалоДня(ТекущаяДатаСеанса) Тогда
			ДатаОтображения = ТекущаяДатаСеанса;
		ИначеЕсли ТекущиеПериодыОтображения[0].Начало < Планировщик.ТекущиеПериодыОтображения[0].Начало Тогда
			ДатаОтображения = ДобавитьМесяц(ДатаОтображения, -1);
		ИначеЕсли ТекущиеПериодыОтображения[0].Начало > Планировщик.ТекущиеПериодыОтображения[0].Начало Тогда
			ДатаОтображения = ДобавитьМесяц(ДатаОтображения, 1);
		КонецЕсли;
		
		ПериодДанных = ПолучитьПериодДанных(ВариантПериода, ДатаОтображения);
		Планировщик.ТекущиеПериодыОтображения.Очистить();
		Планировщик.ТекущиеПериодыОтображения.Добавить(ПериодДанных.ДатаНачала, ПериодДанных.ДатаОкончания);
		
		Планировщик.ИнтервалыФона.Очистить();
		Интервал = Планировщик.ИнтервалыФона.Добавить(НачалоМесяца(ДатаОтображения), КонецМесяца(ДатаОтображения));
		Интервал.Цвет = Новый Цвет(250, 250, 250);
		Если НастройкиОтображения.ОтображатьТекущуюДату Тогда
			Интервал = Планировщик.ИнтервалыФона.Добавить(НачалоДня(ТекущаяДатаСеанса), КонецДня(ТекущаяДатаСеанса));
			Интервал.Цвет = Новый Цвет(223, 255, 223);
		КонецЕсли;
		
	Иначе
		
		ДатаОтображения = ТекущиеПериодыОтображения[0].Начало;
		
	КонецЕсли;
	
	ВыделитьДатыОтображения(ЭтотОбъект);
	УстановитьПредставлениеПериода(ЭтотОбъект);
	Элементы.ДатаОтображения.Обновить();
	ПодключитьОбработчикОжидания("ОбновитьДанныеПланировщикаКлиент", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПередНачаломБыстрогоРедактирования(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	//Для Каждого ВыделенныйЭлемент Из Элемент.ВыделенныеЭлементы Цикл
	//	Если ВыделенныйЭлемент.Значение.РедактированиеЗапрещено Тогда
	//		Возврат;
	//	КонецЕсли;
	//КонецЦикла;
	
	ОткрытьФормуТекущегоЭлементаПланировщика();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыбранКалендарьПриИзменении(Элемент)
	
	СохранитьНастройкиИОбновитьДанныеПланировщикаСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЦветКалендарьНажатие(Элемент)
	
	ТекущийЭлементЦвета = Элемент;
	ОткрытьФорму("ОбщаяФорма.ВыборЦветаКалендаря", , ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьДанныеПланировщика(Команда)
	
	ОбновитьДанныеПланировщикаСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура Настроить(Команда)
	
	ОткрытьФорму("Справочник.ЗаписиКалендаряСотрудника.Форма.НастройкиКалендаря", Новый Структура("НастройкиОтображения", НастройкиОтображения), ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьФормуТекущегоЭлементаПланировщика()
	
	ЗначениеЭлемента = Элементы.Планировщик.ВыделенныеЭлементы[0].Значение;
	
	Если ЗначениеЗаполнено(ЗначениеЭлемента.Источник) Тогда
		
		ПоказатьЗначение(,ЗначениеЭлемента.Источник);
		
	ИначеЕсли Не ЗначениеЗаполнено(ЗначениеЭлемента.Источник) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", ЗначениеЭлемента.ЗаписьКалендаря);
		ОткрытьФорму("Справочник.ЗаписиКалендаряСотрудника.Форма.ФормаЭлемента", ПараметрыФормы, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеФормыЗадачи(ЗаписьКалендаряНалоговойОтчетности)
	
	//Результат = Новый Структура("ИмяФормы, ПараметрыФормы", "", Новый Структура);
	//
	//ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗаписьКалендаряНалоговойОтчетности, "Состояние,Организация,СобытиеКалендаря");
	//
	//Если Не ЗначениеЗаполнено(ЗначенияРеквизитов.СобытиеКалендаря) Тогда
	//	Возврат Результат;
	//КонецЕсли;
	
	//Результат.ПараметрыФормы.Вставить("Состояние", ЗначенияРеквизитов.Состояние);
	//Результат.ПараметрыФормы.Вставить("Организация", ЗначенияРеквизитов.Организация);
	//Результат.ПараметрыФормы.Вставить("СобытиеКалендаря", ЗначенияРеквизитов.СобытиеКалендаря);
	//
	//Задача = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначенияРеквизитов.СобытиеКалендаря, "Задача");
	//Если Не ЗначениеЗаполнено(Задача) Тогда
	//	Возврат Результат;
	//КонецЕсли;
	
	//Результат.ИмяФормы = Справочники.ЗаписиКалендаряПодготовкиОтчетности.ПолучитьИмяФормыПоЗадачеИСостоянию(Задача, ЗначенияРеквизитов.Состояние);
	
	//Возврат Результат;
	
	Возврат Неопределено;
КонецФункции

&НаСервере
Процедура ВосстановитьНастройки()
	
	ВариантПериода = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПланировщикаКалендариСотрудников",
		"ВариантПериода",
		Элементы.ВариантПериода.СписокВыбора[0].Значение
	);
	
	НастройкиОтображения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПланировщикаКалендариСотрудников",
		"Отображение",
		Неопределено
	);
	
	Если НастройкиОтображения = Неопределено Тогда
		
		НастройкиОтображения = Новый Структура;
		НастройкиОтображения.Вставить("НачалоРабочегоДня",		8);
		НастройкиОтображения.Вставить("ОкончаниеРабочегоДня",	23);
		НастройкиОтображения.Вставить("ОтображатьТекущуюДату",	Истина);
		
	КонецЕсли;
	
	Планировщик.ШкалаВремени.Элементы[0].ФорматДня = ФорматДняШкалыВремени.ДеньМесяцаДеньНедели;
	
	ДатаОтображения = ТекущаяДатаСеанса();
	ВыделитьДатыОтображения(ЭтотОбъект);
	УстановитьПредставлениеПериода(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиИОбновитьДанныеПланировщикаСервер()
	
	СохранитьНастройки();
	ОбновитьДанныеПланировщикаСервер();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиПланировщикаКалендариСотрудников",
		"ВариантПериода",
		ВариантПериода
	);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиПланировщикаКалендариСотрудников",
		"Отображение",
		НастройкиОтображения
	);
	
	СохранитьНастройкиДоступныхКалендарей();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиДоступныхКалендарей()
	
	НастройкиДоступныхКалендарей = РеквизитФормыВЗначение("ДоступныеКалендари");
	НастройкиДоступныхКалендарей.Колонки.Удалить("Наименование");
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиПланировщикаКалендариСотрудников",
		"ДоступныеКалендари",
		НастройкиДоступныхКалендарей
	);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеПланировщикаСервер()
	
	Планировщик.Элементы.Очистить();
	Планировщик.ИнтервалыФона.Очистить();
	
	ИзмеренияПланировщика   = Планировщик.Измерения;
    ИзмеренияПланировщика.Очистить();
	
	УстановитьОтображениеПланировщика();
	
	ПериодДанных = ПолучитьПериодДанных(ВариантПериода, ДатаОтображения);
	
	Планировщик.ТекущиеПериодыОтображения.Очистить();
	Планировщик.ТекущиеПериодыОтображения.Добавить(ПериодДанных.ДатаНачала, ПериодДанных.ДатаОкончания);
	
	ИзмерениеСотрудники = ИзмеренияПланировщика.Добавить("Сотрудники");
	ИзмерениеСотрудники.ЦветТекста = WebЦвета.ЗеленыйЛес;
	ТаблицаСотрудников = ДоступныеКалендари.Выгрузить();
	ТаблицаСотрудников.Свернуть("Сотрудник");
	Для Каждого Стр Из ТаблицаСотрудников Цикл

        // Добавление элементов в группу сотрудники
        НовыйСотрудник = ИзмерениеСотрудники.Элементы.Добавить(Стр.Сотрудник);
        НовыйСотрудник.Текст = Стр.Сотрудник.Наименование;
	
    КонецЦикла;

	ВыбранныеКалендари = Новый Массив;
	Для Каждого СтрокаКалендаря Из ДоступныеКалендари Цикл
		Если СтрокаКалендаря.Выбран Тогда
			ВыбранныеКалендари.Добавить(СтрокаКалендаря.Календарь);
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаписиКалендаря.Ссылка КАК ЗаписьКалендаря,
		|	ЗаписиКалендаря.Наименование КАК Наименование,
		|	ЗаписиКалендаря.Начало КАК Начало,
		|	ЗаписиКалендаря.Окончание КАК Конец,
		|	ЗаписиКалендаря.Описание КАК Описание,
		|	ЗаписиКалендаря.Источник КАК Источник,
		|	ЗаписиКалендаря.НомерСтрокиИсточника КАК НомерСтрокиИсточника,
		|	ЗаписиКалендаря.Календарь КАК Календарь,
		|	ЗаписиКалендаря.РедактированиеЗапрещено КАК РедактированиеЗапрещено,
		|	ЗаписиКалендаря.Календарь.ВладелецКалендаря КАК Сотрудник,
		|	ЗаписиКалендаря.Выполнено КАК Выполнено
		|ИЗ
		|	Справочник.ЗаписиКалендаряСотрудника КАК ЗаписиКалендаря
		|ГДЕ
		|	ЗаписиКалендаря.ПометкаУдаления = ЛОЖЬ
		|	И ЗаписиКалендаря.Начало < &ДатаОкончания
		|	И ЗаписиКалендаря.Окончание > &ДатаНачала
		|	И ЗаписиКалендаря.Календарь В(&ВыбранныеКалендари)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Начало
		|ИТОГИ ПО
		|	Сотрудник";
	
	Запрос.УстановитьПараметр("ДатаНачала", ПериодДанных.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ПериодДанных.ДатаОкончания);
	Запрос.УстановитьПараметр("ВыбранныеКалендари", ВыбранныеКалендари);
	
	ВыборкаСотрудников = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Отбор = Новый Структура("Календарь");
	Пока ВыборкаСотрудников.Следующий() Цикл
		ТекущийСотрудник = ВыборкаСотрудников.Сотрудник;
		Выборка = ВыборкаСотрудников.Выбрать();
		Пока Выборка.Следующий() Цикл
			СоответствиеЗначений = Новый Соответствие;
			СоответствиеЗначений.Вставить("Сотрудники",ТекущийСотрудник);
			
			ЭлементПланировщика = Планировщик.Элементы.Добавить(Выборка.Начало, Выборка.Конец);
			ЭлементПланировщика.Значение = Новый Структура;
			ЭлементПланировщика.Значение.Вставить("Календарь", Выборка.Календарь);
			ЭлементПланировщика.Значение.Вставить("ЗаписьКалендаря", Выборка.ЗаписьКалендаря);
			ЭлементПланировщика.Значение.Вставить("Источник", Выборка.Источник);
			ЭлементПланировщика.Значение.Вставить("РедактированиеЗапрещено", Выборка.РедактированиеЗапрещено);
			ЭлементПланировщика.Значение.Вставить("НомерСтрокиИсточника", Выборка.НомерСтрокиИсточника);
			ЭлементПланировщика.Текст		= Выборка.Наименование;
			ЭлементПланировщика.Подсказка	= Выборка.Описание;
			
			ЭлементПланировщика.ЗначенияИзмерений  = Новый ФиксированноеСоответствие(СоответствиеЗначений);
			
			Если ЗначениеЗаполнено(Выборка.Источник) Тогда
				МенеджерИсточника = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Выборка.Источник);
				ЭлементПланировщика.Картинка = МенеджерИсточника.КартинкаЗаписиКалендаря(Выборка.Источник);
				ЭлементПланировщика.ЦветТекста = МенеджерИсточника.ЦветТекстаЗаписиКалендаря(Выборка.Источник);
				ЭлементПланировщика.Шрифт = МенеджерИсточника.ШрифтТекстаЗаписиКалендаря(Выборка.Источник);
			Иначе
				ЭлементПланировщика.Шрифт = Новый Шрифт(,,,,,Выборка.Выполнено);	
			КонецЕсли;
			
			Отбор.Календарь = Выборка.Календарь;
			НайденныеСтроки = ДоступныеКалендари.НайтиСтроки(Отбор);
			Если НайденныеСтроки.Количество() > 0 Тогда
				ЭлементПланировщика.ЦветФона = РаботаСЦветомКлиентСервер.ЦветПоНомеруКартинки(НайденныеСтроки[0].ВариантЦвета);
			КонецЕсли;
		КонецЦикла;	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеПланировщика()
	
	Если ВариантПериода = "День" Тогда
		
		Планировщик.ОтображатьТекущуюДату = НастройкиОтображения.ОтображатьТекущуюДату;
		Планировщик.ЕдиницаПериодическогоВарианта = ТипЕдиницыШкалыВремени.Час;
		Планировщик.КратностьПериодическогоВарианта = 24;
		Планировщик.ОтступСНачалаПереносаШкалыВремени = НастройкиОтображения.НачалоРабочегоДня;
		Планировщик.ОтступСКонцаПереносаШкалыВремени = ?(НастройкиОтображения.ОкончаниеРабочегоДня = 0, 0, 24 - НастройкиОтображения.ОкончаниеРабочегоДня);
		Планировщик.ОтображатьПеренесенныеЗаголовки = Истина;
		Планировщик.ОтображатьПеренесенныеЗаголовкиШкалыВремени = Ложь;
		Планировщик.ОтображениеВремениЭлементов = ОтображениеВремениЭлементовПланировщика.ВремяНачалаИКонца;
		Планировщик.ФорматПеренесенныхЗаголовковШкалыВремени = "ДФ='dddd, d MMMM yyyy'";
		Планировщик.ШкалаВремени.Положение = ПоложениеШкалыВремени.Лево;
		Планировщик.ШкалаВремени.Элементы[0].Формат = "ДФ=ЧЧ:мм";
		Планировщик.ШкалаВремени.Элементы[0].Кратность = 1;
		Планировщик.ШкалаВремени.Элементы[0].Единица = ТипЕдиницыШкалыВремени.Час;
		
		ТаблПользователей = ДоступныеКалендари.Выгрузить();
		ТаблПользователей.Свернуть("Сотрудник,Пользователь");
		
		Для Каждого СтрокаПользователя Из ТаблПользователей Цикл
			ГрафикРаботы = ГрафикиРаботы.ПолучитьОсновнойГрафикРаботы(СтрокаПользователя.Пользователь);
			СоответствиеЗначений = Новый Соответствие;
			СоответствиеЗначений.Вставить("Сотрудники",СтрокаПользователя.Сотрудник);			
			
			Интервал = Планировщик.ИнтервалыФона.Добавить(НачалоДня(ДатаОтображения), КонецДня(ДатаОтображения));
			Интервал.Цвет = WebЦвета.СеребристоСерый;
			Интервал.ЗначенияИзмерений  = Новый ФиксированноеСоответствие(СоответствиеЗначений);
	
			ТаблицаРабочегоВремени = ГрафикиРаботы.СформироватьТаблицуРабочегоВремени(ГрафикРаботы,НачалоДня(ДатаОтображения),КонецДня(ДатаОтображения));
			Для Каждого Стр Из ТаблицаРабочегоВремени Цикл	
				Интервал = Планировщик.ИнтервалыФона.Добавить(Стр.ДатаНачала, Стр.ДатаОкончания);
				Интервал.Цвет = Новый Цвет();
				Интервал.ЗначенияИзмерений  = Новый ФиксированноеСоответствие(СоответствиеЗначений);
			КонецЦикла;
		КонецЦикла;
		
	ИначеЕсли ВариантПериода = "Неделя" Тогда
		
		Планировщик.ОтображатьТекущуюДату = НастройкиОтображения.ОтображатьТекущуюДату;
		Планировщик.ЕдиницаПериодическогоВарианта = ТипЕдиницыШкалыВремени.Час;
		Планировщик.КратностьПериодическогоВарианта = 24;
		Планировщик.ОтступСНачалаПереносаШкалыВремени = НастройкиОтображения.НачалоРабочегоДня;
		Планировщик.ОтступСКонцаПереносаШкалыВремени = ?(НастройкиОтображения.ОкончаниеРабочегоДня = 0, 0, 24 - НастройкиОтображения.ОкончаниеРабочегоДня);
		Планировщик.ОтображатьПеренесенныеЗаголовки = Истина;
		Планировщик.ОтображатьПеренесенныеЗаголовкиШкалыВремени = Ложь;
		Планировщик.ОтображениеВремениЭлементов = ОтображениеВремениЭлементовПланировщика.НеОтображать;
		Планировщик.ФорматПеренесенныхЗаголовковШкалыВремени = "ДФ='ddd, d MMMM'";
		Планировщик.ШкалаВремени.Положение = ПоложениеШкалыВремени.Лево;
		Планировщик.ШкалаВремени.Элементы[0].Формат = "ДФ=ЧЧ:мм";
		Планировщик.ШкалаВремени.Элементы[0].Кратность = 1;
		Планировщик.ШкалаВремени.Элементы[0].Единица = ТипЕдиницыШкалыВремени.Час;
		
		ТаблПользователей = ДоступныеКалендари.Выгрузить();
		ТаблПользователей.Свернуть("Сотрудник,Пользователь");
		
		Для Каждого СтрокаПользователя Из ТаблПользователей Цикл
			ГрафикРаботы = ГрафикиРаботы.ПолучитьОсновнойГрафикРаботы(СтрокаПользователя.Пользователь);
			СоответствиеЗначений = Новый Соответствие;
			СоответствиеЗначений.Вставить("Сотрудники",СтрокаПользователя.Сотрудник);			
			
			Интервал = Планировщик.ИнтервалыФона.Добавить(НачалоНедели(ДатаОтображения), КонецНедели(ДатаОтображения));
			Интервал.Цвет = WebЦвета.СеребристоСерый;
			Интервал.ЗначенияИзмерений  = Новый ФиксированноеСоответствие(СоответствиеЗначений);
			
			ТаблицаРабочегоВремени = ГрафикиРаботы.СформироватьТаблицуРабочегоВремени(ГрафикРаботы,НачалоНедели(ДатаОтображения),КонецНедели(ДатаОтображения));
			Для Каждого Стр Из ТаблицаРабочегоВремени Цикл	
				Интервал = Планировщик.ИнтервалыФона.Добавить(Стр.ДатаНачала, Стр.ДатаОкончания);
				Интервал.Цвет = Новый Цвет();
				Интервал.ЗначенияИзмерений  = Новый ФиксированноеСоответствие(СоответствиеЗначений);
			КонецЦикла;	
			
			ТекДень = НачалоНедели(ДатаОтображения);
			Пока ТекДень < КонецНедели(ДатаОтображения) Цикл
				Если ГрафикиРаботы.ЭтоРабочийДень(ТекДень, ГрафикРаботы) Тогда
					ТекДень = ТекДень + 86400;
					Продолжить;
				КонецЕсли;
				Интервал = Планировщик.ИнтервалыФона.Добавить(НачалоДня(ТекДень), КонецДня(ТекДень));
				Интервал.Цвет = WebЦвета.Розовый;
				Интервал.ЗначенияИзмерений  = Новый ФиксированноеСоответствие(СоответствиеЗначений);
				ТекДень = ТекДень + 86400;
			КонецЦикла;
		КонецЦикла;
		
	ИначеЕсли ВариантПериода = "Месяц" Тогда
		
		Планировщик.ОтображатьТекущуюДату = Ложь;
		Планировщик.ЕдиницаПериодическогоВарианта = ТипЕдиницыШкалыВремени.День;
		Планировщик.КратностьПериодическогоВарианта = 7;
		Планировщик.ОтступСНачалаПереносаШкалыВремени = 0;
		Планировщик.ОтступСКонцаПереносаШкалыВремени = 0;
		Планировщик.ОтображатьПеренесенныеЗаголовки = Ложь;
		Планировщик.ОтображатьПеренесенныеЗаголовкиШкалыВремени = Истина;
		Планировщик.ОтображениеВремениЭлементов = ОтображениеВремениЭлементовПланировщика.НеОтображать;
		Планировщик.ФорматПеренесенныхЗаголовковШкалыВремени = "ДФ='ddd, d MMM yyyy'";
		Планировщик.ШкалаВремени.Положение = ПоложениеШкалыВремени.Верх;
		Планировщик.ШкалаВремени.Элементы[0].Формат = "ДФ='ddd, d MMM yyyy'";
		Планировщик.ШкалаВремени.Элементы[0].Кратность = 1;
		Планировщик.ШкалаВремени.Элементы[0].Единица = ТипЕдиницыШкалыВремени.День;
		
		Интервал = Планировщик.ИнтервалыФона.Добавить(НачалоМесяца(ДатаОтображения), КонецМесяца(ДатаОтображения));
		Интервал.Цвет = Новый Цвет(250, 250, 250);
		Если НастройкиОтображения.ОтображатьТекущуюДату Тогда
			ТекущаяДатаСеанса = ТекущаяДатаСеанса();
			Интервал = Планировщик.ИнтервалыФона.Добавить(НачалоДня(ТекущаяДатаСеанса), КонецДня(ТекущаяДатаСеанса));
			Интервал.Цвет = Новый Цвет(223, 255, 223);
		КонецЕсли;
		
		ТаблПользователей = ДоступныеКалендари.Выгрузить();
		ТаблПользователей.Свернуть("Сотрудник,Пользователь");
		
		Для Каждого СтрокаПользователя Из ТаблПользователей Цикл
			ГрафикРаботы = ГрафикиРаботы.ПолучитьОсновнойГрафикРаботы(СтрокаПользователя.Пользователь);
			СоответствиеЗначений = Новый Соответствие;
			СоответствиеЗначений.Вставить("Сотрудники",СтрокаПользователя.Сотрудник);			
			
			ТекДень = НачалоМесяца(ДатаОтображения);
			Пока ТекДень < КонецМесяца(ДатаОтображения) Цикл
				Если ГрафикиРаботы.ЭтоРабочийДень(ТекДень, ГрафикРаботы) Тогда
					ТекДень = ТекДень + 86400;
					Продолжить;
				КонецЕсли;
				Интервал = Планировщик.ИнтервалыФона.Добавить(НачалоДня(ТекДень), КонецДня(ТекДень));
				Интервал.Цвет = WebЦвета.Розовый;
				Интервал.ЗначенияИзмерений  = Новый ФиксированноеСоответствие(СоответствиеЗначений);
				ТекДень = ТекДень + 86400;
			КонецЦикла;
		КонецЦикла;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПериодДанных(ВариантПериода, ДатаОтображения)
	
	Результат = Новый Структура("ДатаНачала, ДатаОкончания");
	
	Если ВариантПериода = "День" Тогда
		Результат.ДатаНачала	= НачалоДня(ДатаОтображения);
		Результат.ДатаОкончания	= КонецДня(ДатаОтображения);
	ИначеЕсли ВариантПериода = "Неделя" Тогда
		Результат.ДатаНачала	= НачалоНедели(ДатаОтображения);
		Результат.ДатаОкончания	= КонецНедели(ДатаОтображения);
	ИначеЕсли ВариантПериода = "Месяц" Тогда
		Результат.ДатаНачала	= НачалоНедели(НачалоМесяца(ДатаОтображения));
		Результат.ДатаОкончания	= КонецНедели(КонецМесяца(ДатаОтображения));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция СохранитьИзмененияВБазу(ОбрабатываемыеЭлементы)
	//Сохраним изменения в базу
	Возврат Справочники.ЗаписиКалендаряСотрудника.СохранитьИзмененияЗаписейКалендарей(ОбрабатываемыеЭлементы);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ВыделитьДатыОтображения(Форма)
	
	ПолеКалендаря = Форма.Элементы.ДатаОтображения;
	
	ПолеКалендаря.ВыделенныеДаты.Очистить();
	ПериодДанных = ПолучитьПериодДанных(Форма.ВариантПериода, Форма.ДатаОтображения);
	
	ТекДата = ПериодДанных.ДатаНачала;
	
	Пока ТекДата < ПериодДанных.ДатаОкончания Цикл
		ПолеКалендаря.ВыделенныеДаты.Добавить(ТекДата);
		ТекДата = ТекДата + 86400;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеПланировщикаКлиент()
	
	ОбновитьДанныеПланировщикаСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДоступныхКалендарей()
	
	УдаляемыеЭлементы = Новый Массив;
	
	Для Каждого ГруппаЭлементов Из Элементы.ДоступныеКалендари.ПодчиненныеЭлементы Цикл
		УдаляемыеЭлементы.Добавить(ГруппаЭлементов);
	КонецЦикла;
	
	Для Каждого УдаляемыйЭлемент Из УдаляемыеЭлементы Цикл
		Элементы.Удалить(УдаляемыйЭлемент);
	КонецЦикла;
	
	СтруктураПоиска = Новый Структура();
	
	ТаблицаПользователей = ДоступныеКалендари.Выгрузить();
	ТаблицаПользователей.Свернуть("Сотрудник");
	
	ГруппаСтраницПользователя = Элементы.Добавить("ГруппаСтраницПользователя", Тип("ГруппаФормы"), Элементы.ДоступныеКалендари);
	ГруппаСтраницПользователя.Вид = ВидГруппыФормы.Страницы;	
	ГруппаСтраницПользователя.РастягиватьПоГоризонтали = Истина;
	
	Для Каждого Стр Из ТаблицаПользователей Цикл
		ИндексПользователя = ТаблицаПользователей.Индекс(Стр);
		
		ГруппаПользователя = Элементы.Добавить("ГруппаПользователя_" + ИндексПользователя, Тип("ГруппаФормы"), Элементы.ГруппаСтраницПользователя);
		ГруппаПользователя.Вид = ВидГруппыФормы.Страница;
		ГруппаПользователя.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		ГруппаПользователя.ОтображатьЗаголовок = Истина;
		ГруппаПользователя.Заголовок = Стр.Сотрудник.Наименование;
		
		СтруктураПоиска.Очистить();
		СтруктураПоиска.Вставить("Сотрудник",Стр.Сотрудник);
		МассивСтрокКалендаря = ДоступныеКалендари.НайтиСтроки(СтруктураПоиска);
		
		Для Каждого СтрокаКалендаря Из МассивСтрокКалендаря Цикл
			
			Индекс = ДоступныеКалендари.Индекс(СтрокаКалендаря);
			
			ГруппаКалендаря = Элементы.Добавить("ГруппаКалендарь_" + Индекс, Тип("ГруппаФормы"), Элементы["ГруппаПользователя_" + ИндексПользователя]);
			ГруппаКалендаря.Вид = ВидГруппыФормы.ОбычнаяГруппа;
			ГруппаКалендаря.Отображение = ОтображениеОбычнойГруппы.Нет;
			ГруппаКалендаря.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
			ГруппаКалендаря.ОтображатьЗаголовок = Ложь;
			
			ФлагВыбран = Элементы.Добавить("ВыбранКалендарь_" + Индекс, Тип("ПолеФормы"), ГруппаКалендаря);
			ФлагВыбран.Вид = ВидПоляФормы.ПолеФлажка;
			ФлагВыбран.ПутьКДанным = "ДоступныеКалендари[" + Индекс + "].Выбран";
			ФлагВыбран.Заголовок = СтрокаКалендаря.Наименование;
			ФлагВыбран.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
			ФлагВыбран.УстановитьДействие("ПриИзменении", "Подключаемый_ВыбранКалендарьПриИзменении");
			
			ДекорацияОтступ = Элементы.Добавить("ОтступКалендарь_" + Индекс, Тип("ДекорацияФормы"), ГруппаКалендаря);
			ДекорацияОтступ.РастягиватьПоГоризонтали = Истина;
			
			КартинкаЦвета = Элементы.Добавить("ЦветКалендарь_" + Индекс, Тип("ДекорацияФормы"), ГруппаКалендаря);
			КартинкаЦвета.Вид = ВидДекорацииФормы.Картинка;
			КартинкаЦвета.Картинка = РаботаСЦветомКлиентСервер.КартинкаЦветаПоНомеруКартинки(СтрокаКалендаря.ВариантЦвета);
			КартинкаЦвета.Гиперссылка = Истина;
			КартинкаЦвета.Ширина = 2;
			КартинкаЦвета.Высота = 1;
			КартинкаЦвета.УстановитьДействие("Нажатие", "Подключаемый_ЦветКалендарьНажатие");
			
		КонецЦикла;
	КонецЦикла;	

КонецПроцедуры

&НаСервере
Процедура ОбработатьЗаписьКалендаряСервер()
	
	ПрочитатьДоступныеКалендари();
	ОбновитьДанныеПланировщикаСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДоступныеКалендари()
	
	ДоступныеКалендари.Очистить();
	
	НастройкиДоступныхКалендарей = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПланировщикаКалендариСотрудников",
		"ДоступныеКалендари",
		Новый ТаблицаЗначений
	);
	
	ЗанятыеЦвета = ?(НастройкиДоступныхКалендарей.Количество() = 0, Новый Массив, НастройкиДоступныхКалендарей.ВыгрузитьКолонку("ВариантЦвета"));
	ЕстьНеНазначенныеЦвета = Ложь;
	
	ТаблицаКалендарей = Справочники.КалендариСотрудников.ДоступныеКалендариГруппеСотрудников(ГруппаПользователей);
	
	Для Каждого СтрокаТаблицы Из ТаблицаКалендарей Цикл
		
		НоваяСтрока = ДоступныеКалендари.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы, "Календарь,Наименование");
		НоваяСтрока.Сотрудник = СтрокаТаблицы.Календарь.ВладелецКалендаря;
		НоваяСтрока.Пользователь = ЗаполнениеОбъектовCRM.ПолучитьПользователяПоСотруднику(НоваяСтрока.Сотрудник);

		НайденнаяСтрока = НастройкиДоступныхКалендарей.Найти(СтрокаТаблицы.Календарь);
		Если НайденнаяСтрока <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(НоваяСтрока, НайденнаяСтрока, "ВариантЦвета,Выбран");
		КонецЕсли;
		
		Если НоваяСтрока.ВариантЦвета = 0 Тогда
			ПроверяемыйЦвет = 14;
			Пока Истина Цикл
				Если ЗанятыеЦвета.Найти(ПроверяемыйЦвет) = Неопределено Тогда
					НоваяСтрока.ВариантЦвета = ПроверяемыйЦвет;
					ЕстьНеНазначенныеЦвета = Истина;
					Прервать;
				КонецЕсли;
				ПроверяемыйЦвет = ?(ПроверяемыйЦвет = 24, 1, ПроверяемыйЦвет+1);
			КонецЦикла;
		КонецЕсли;
		
		ЗанятыеЦвета.Добавить(НоваяСтрока.ВариантЦвета);
		Если ЗанятыеЦвета.Количество() = 24 Тогда
			ЗанятыеЦвета.Очистить();
		КонецЕсли;
		
	КонецЦикла;
	
	Отбор = Новый Структура("Выбран", Истина);
	Если ДоступныеКалендари.НайтиСтроки(Отбор).Количество() = 0 Тогда
		
		Отбор.Удалить("Выбран");
		Отбор.Вставить("Календарь");
		Для Каждого СтрокаКалендаря Из ДоступныеКалендари Цикл
			Отбор.Календарь = СтрокаКалендаря.Календарь;
			СтрокаКалендаря.Выбран = ТаблицаКалендарей.НайтиСтроки(Отбор)[0].ЯвляетсяВладельцем;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЕстьНеНазначенныеЦвета Тогда
		СохранитьНастройкиДоступныхКалендарей();
	КонецЕсли;
	
	ОбновитьЭлементыДоступныхКалендарей();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеПериода(Форма)
	
	Если Форма.ВариантПериода = "День" Тогда
		
		Форма.ПредставлениеПериода = Формат(Форма.ДатаОтображения, "ДФ='дддд, д МММ'");
		
	ИначеЕсли Форма.ВариантПериода = "Неделя" Тогда
		
		ПериодДанных = ПолучитьПериодДанных(Форма.ВариантПериода, Форма.ДатаОтображения);
		Форма.ПредставлениеПериода = СтрШаблон(
			"%1 - %2",
			Формат(ПериодДанных.ДатаНачала, "ДФ='д МММ'"),
			Формат(ПериодДанных.ДатаОкончания, "ДФ='д МММ гггг'")
		);
		
	ИначеЕсли Форма.ВариантПериода = "Месяц" Тогда
		
		Форма.ПредставлениеПериода = ПредставлениеПериода(НачалоМесяца(Форма.ДатаОтображения), КонецМесяца(Форма.ДатаОтображения));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти



