﻿Процедура РассылкаОтчетовПользователям() Экспорт
	// Получатель отчета
	ТаблицаОтчетовКРассылке = ПолучитьОтчетыИПолучателейКРассылке();
	Если ТаблицаОтчетовКРассылке.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаОтчетовКРассылкеСвернуто = ТаблицаОтчетовКРассылке.Скопировать();
	ТаблицаОтчетовКРассылкеСвернуто.Свернуть("ИмяОтчета,ИмяВарианта");
	
	СтруктураПоиска = Новый Структура();
	
	Для Каждого Стр Из ТаблицаОтчетовКРассылкеСвернуто Цикл
		ИмяОтчета = Стр.ИмяОтчета.Имя;
		ВариантОтчета = Стр.ИмяВарианта;
		
		Попытка
			Отчет = Отчеты[ИмяОтчета].Создать();
			Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(ВариантОтчета.ХранилищеЗначений.Получить());	
		Исключение 
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при отправке письма по отчету %1 : Ошибка создания отчета по варианту %2 : '"+ОписаниеОшибки()), 
			ИмяОтчета,ВариантОтчета);
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Рассылка отчетов пользователю'"), 
			УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
			Продолжить;
		КонецПопытки;
		
		ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
		Результат = Новый ТабличныйДокумент;
			
		
		МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(Отчет.СхемаКомпоновкиДанных, Отчет.КомпоновщикНастроек.Настройки, ДанныеРасшифровки);
		
		ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных,,ДанныеРасшифровки);
		
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
		ПроцессорВывода.УстановитьДокумент(Результат);
		ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
		
		
		СтруктураПоиска.Очистить();
		СтруктураПоиска.Вставить("ИмяОтчета",Стр.ИмяОтчета);
		СтруктураПоиска.Вставить("ИмяВарианта",Стр.ИмяВарианта);
		ТаблПолучателей = ТаблицаОтчетовКРассылке.Скопировать(СтруктураПоиска);
		
		Для Каждого СтрПолучателя Из ТаблПолучателей Цикл
			СписокВложений = Новый СписокЗначений;			
			
			ИмяТемпФайлаОтчета = КаталогВременныхФайлов() + ИмяОтчета+ПолучитьФорматФайлаПоФорматуОтправки(СтрПолучателя.ФорматОтправки);
			Результат.Записать(ИмяТемпФайлаОтчета,ПолучитьФорматСохраненияФайлаПоФорматуОтправки(СтрПолучателя.ФорматОтправки));
						
			СписокВложений.Добавить(Новый ДвоичныеДанные(ИмяТемпФайлаОтчета),ИмяОтчета+ПолучитьФорматФайлаПоФорматуОтправки(СтрПолучателя.ФорматОтправки));
			АдресПолучателя = РаботаСЗаявкамиИПочтой.ПолучитьАдресПользователя(СтрПолучателя.Получатель);
			
			ОписаниеОшибки = "";
			СтатусОтправки = РаботаСЗаявкамиИПочтой.ОтправитьСервисноеСообщение(АдресПолучателя,СтрПолучателя.тема,СтрПолучателя.ТекстПисьма,СписокВложений,ОписаниеОшибки);
			Если СтатусОтправки = Ложь Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при отправке письма по отчету %1 пользователю %2:'"+ОписаниеОшибки), 
				ИмяОтчета,СтрПолучателя.Получатель);
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Рассылка отчетов пользователю'"), 
				УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
				Продолжить;
			КонецЕсли;	
		КонецЦикла;
	КонецЦикла;	
КонецПроцедуры

Функция ПолучитьФорматФайлаПоФорматуОтправки(ФорматОтправки)
	Индекс = Перечисления.ФорматыСохраненияОтчетов.Индекс(ФорматОтправки);	
	Возврат "."+нрег(Метаданные.Перечисления.ФорматыСохраненияОтчетов.ЗначенияПеречисления[Индекс].Имя);
КонецФункции

Функция ПолучитьФорматСохраненияФайлаПоФорматуОтправки(ФорматОтправки)
	Если ФорматОтправки= Перечисления.ФорматыСохраненияОтчетов.HTML Тогда
		Возврат ТипФайлаТабличногоДокумента.HTML5;
	ИначеЕсли ФорматОтправки= Перечисления.ФорматыСохраненияОтчетов.XLS Тогда
		Возврат ТипФайлаТабличногоДокумента.XLS;
	ИначеЕсли ФорматОтправки= Перечисления.ФорматыСохраненияОтчетов.XLSX Тогда
		Возврат ТипФайлаТабличногоДокумента.XLSX;
	ИначеЕсли ФорматОтправки= Перечисления.ФорматыСохраненияОтчетов.PDF Тогда
		Возврат ТипФайлаТабличногоДокумента.PDF;
	ИначеЕсли ФорматОтправки= Перечисления.ФорматыСохраненияОтчетов.MXL Тогда
		Возврат ТипФайлаТабличногоДокумента.MXL;
	КонецЕсли;
КонецФункции

Функция ПолучитьОтчетыИПолучателейКРассылке() Экспорт 
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПодписчикиОтчетовСрезПоследних.Получатель КАК Получатель,
		|	ПодписчикиОтчетовСрезПоследних.ИмяОтчета КАК ИмяОтчета,
		|	ПодписчикиОтчетовСрезПоследних.ИмяВарианта КАК ИмяВарианта,
		|	ПодписчикиОтчетовСрезПоследних.ФорматОтправки КАК ФорматОтправки,
		|	ПодписчикиОтчетовСрезПоследних.Тема КАК Тема,
		|	ПодписчикиОтчетовСрезПоследних.ТекстПисьма КАК ТекстПисьма
		|ИЗ
		|	РегистрСведений.НастройкаРассылкиОтчетов.СрезПоследних(, ) КАК ПодписчикиОтчетовСрезПоследних
		|ГДЕ
		|	ПодписчикиОтчетовСрезПоследних.Использовать = ИСТИНА";
		
	Возврат Запрос.Выполнить().Выгрузить();	
КонецФункции // ПолучитьПолучателейОтчетаПоЗаявкам()
