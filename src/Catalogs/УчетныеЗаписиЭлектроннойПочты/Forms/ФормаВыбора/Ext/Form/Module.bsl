﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор") Тогда
		Для каждого ПараметрОтбора Из Параметры.Отбор Цикл
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, ПараметрОтбора.Ключ, ПараметрОтбора.Значение);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры
