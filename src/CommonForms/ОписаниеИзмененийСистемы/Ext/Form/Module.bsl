﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		НеПоказыватьОписаниеИзмененийСистемы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ОбновлениеИБ", 
			"НеПоказыватьОписаниеИзмененийСистемы");
		Если НеПоказыватьОписаниеИзмененийСистемы = Неопределено Тогда
			ПоказыватьПриСледующихОбновлениях = Истина;
		Иначе
			ПоказыватьПриСледующихОбновлениях = НЕ НеПоказыватьОписаниеИзмененийСистемы;
		КонецЕсли;
	КонецЕсли;
	
	ВыполненныеОбработчикиОбновления = Неопределено;
	Если ПустаяСтрока(Параметры.ВыполненныеОбработчикиОбновления) Тогда
		Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
			И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
			
			ВыполненныеОбработчикиОбновления = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ОбновлениеИБ", 
				"ВыполненныеОбработчики");
		КонецЕсли;
	Иначе
		ВыполненныеОбработчикиОбновления = ПолучитьИзВременногоХранилища(Параметры.ВыполненныеОбработчикиОбновления);
	КонецЕсли;
	
	Если ВыполненныеОбработчикиОбновления = Неопределено Тогда
		ДокументОписаниеОбновлений = Метаданные.ОбщиеМакеты.Найти("ОписаниеИзмененийСистемы");
		Если ДокументОписаниеОбновлений <> Неопределено Тогда
			ДокументОписаниеОбновлений = ПолучитьОбщийМакет(ДокументОписаниеОбновлений);
		Иначе	
			ДокументОписаниеОбновлений = Новый ТабличныйДокумент();
		КонецЕсли;
	Иначе
		ДокументОписаниеОбновлений = ОбновлениеИнформационнойБазы.ДокументОписаниеОбновлений(ВыполненныеОбработчикиОбновления);
	КонецЕсли;

	Если ДокументОписаниеОбновлений.ВысотаТаблицы = 0 Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Конфигурация успешно обновлена на версию %1'"), Метаданные.Версия);
		ДокументОписаниеОбновлений.Область("R1C1:R1C1").Текст = Текст;
	КонецЕсли;
	ОбновлениеИнформационнойБазыПереопределяемый.ПриПодготовкеМакетаОписанияОбновлений(ДокументОписаниеОбновлений);
	ОписаниеОбновлений.Очистить();
	ОписаниеОбновлений.Вывести(ДокументОписаниеОбновлений);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;

	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ЗаписатьТекущиеНастройки(ПоказыватьПриСледующихОбновлениях);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОписаниеОбновленийВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Если Найти(Область.Текст, "http://") = 1 Тогда
		ПерейтиПоНавигационнойСсылке(Область.Текст);
	КонецЕсли;
	ОбновлениеИнформационнойБазыКлиентПереопределяемый.ПриНажатииНаГиперссылкуВДокументеОписанияОбновлений(Область);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
Процедура ЗаписатьТекущиеНастройки(Знач ПоказыватьПриСледующихОбновлениях)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекУдалить("ОбновлениеИБ", "ВыполненныеОбработчики", ИмяПользователя());
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ОбновлениеИБ", "НеПоказыватьОписаниеИзмененийСистемы",
		НЕ ПоказыватьПриСледующихОбновлениях, НСтр("ru = 'Не показывать описание изменений системы при обновлении версии ИБ'"));
	
КонецПроцедуры
