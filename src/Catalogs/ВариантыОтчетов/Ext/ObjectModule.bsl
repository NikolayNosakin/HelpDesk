﻿
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ИсключаемыеРеквизиты = Новый Массив;
	
	Если ТипВариантаОтчета = Перечисления.ТипыВариантовОтчетов.Отчет
		ИЛИ ТипВариантаОтчета = Перечисления.ТипыВариантовОтчетов.Предопределенный Тогда
		ИсключаемыеРеквизиты.Добавить("Администратор");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
КонецПроцедуры
