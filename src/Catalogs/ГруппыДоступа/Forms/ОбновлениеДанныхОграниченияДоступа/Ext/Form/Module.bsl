﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = НЕ УправлениеДоступом.ОграничиватьДоступНаУровнеЗаписей();
	ВыполнитьПроверкуПравДоступа("АдминистрированиеДанных", Метаданные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ВыполнитьОбновление", 0.1, Истина);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ВыполнитьОбновление()
	
	Пока ОбновлениеТребуется() Цикл
		ОбработкаПрерыванияПользователя();
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ОбновлениеТребуется()
	
	УстановитьПривилегированныйРежим(Истина);
	
	КоличествоДанных = 0;
	УправлениеДоступомСлужебный.ЗаполнениеДанныхДляОграниченияДоступа(КоличествоДанных);
	Если КоличествоДанных > 0 Тогда
		ВыполненоШаговОбновления = 1;
	КонецЕсли;
	Начало = ТекущаяДатаСеанса();
	
	МетаданныеЗадания = Метаданные.РегламентныеЗадания.ЗаполнениеДанныхДляОграниченияДоступа;
	
	Пока РегламентныеЗадания.НайтиПредопределенное(МетаданныеЗадания).Использование
	   И Начало + 15 > ТекущаяДатаСеанса() Цикл
		
		ВыполненоШаговОбновления = ВыполненоШаговОбновления + 1;
		УправлениеДоступомСлужебный.ЗаполнениеДанныхДляОграниченияДоступа();
		
	КонецЦикла;
	
	ОбновлениеТребуется = РегламентныеЗадания.НайтиПредопределенное(МетаданныеЗадания).Использование;
	Элементы.ВыполнениеЗавершено.Видимость = НЕ ОбновлениеТребуется;
	
	Возврат ОбновлениеТребуется;
	
КонецФункции

