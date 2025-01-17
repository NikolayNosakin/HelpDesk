﻿Процедура ПередЗаписью(Отказ, Замещение)
	
	Если Количество() = 0 Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	СведенияОПользователях.Подразделение
			|ИЗ
			|	РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
			|ГДЕ
			|	СведенияОПользователях.Пользователь = &Пользователь";

		Запрос.УстановитьПараметр("Пользователь", Отбор.Пользователь.Значение);

		Результат = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = Результат.Выбрать();

		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			ДополнительныеСвойства.Вставить("Подразделение", ВыборкаДетальныеЗаписи.Подразделение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если Количество() = 0 Тогда			
		Возврат;
	КонецЕсли;
	
	Подразделения = Новый Массив();
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		Если Подразделения.Найти(Запись.Подразделение) = Неопределено Тогда	
			Подразделения.Добавить(Запись.Подразделение);	
		КонецЕсли;
			
	КонецЦикла;			
	
КонецПроцедуры

