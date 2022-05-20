﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Изменение", Метаданные.Справочники.ГруппыДоступа)
	     
	 ИЛИ ПараметрыДоступа("Изменение", Метаданные.Справочники.ГруппыДоступа,
	         "Ссылка").ОграничениеУсловием Тогда
		
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущийОбъект.Ссылка = УправлениеДоступомСлужебный.РодительПерсональныхГруппДоступа(Истина) Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НаименованиеПерсональныхГруппДоступа = Неопределено;
	
	Если Объект.Ссылка <> УправлениеДоступомСлужебный.РодительПерсональныхГруппДоступа(
	         Истина, НаименованиеПерсональныхГруппДоступа)
	   И
	     Объект.Наименование = НаименованиеПерсональныхГруппДоступа Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Это наименование зарезервировано.'"),
			,
			"Объект.Наименование",
			,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

