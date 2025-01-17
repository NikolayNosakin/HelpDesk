﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-процессы и задачи"
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Вызывается для обновления данных бизнес-процесса в регистре сведений 
// ДанныеБизнесПроцессов.
// 
// Параметры
//  Запись       - РегистрСведенийЗапись.ДанныеБизнесПроцессов
//
Процедура ПриЗаписиСпискаБизнесПроцессов(Запись) Экспорт
	
КонецПроцедуры

// Вызывается для проверки прав на остановку и продолжение бизнес-процесса
// Параметры
//  БизнесПроцесс       - Ссылка на бизнес-процесс
//
Функция ЕстьПраваНаОстановкуБизнесПроцесса(БизнесПроцесс) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Вызывается для заполнения реквизита ГлавнаяЗадача из данных заполнения
// Параметры
//  БизнесПроцессОбъект       - бизнес-процесс
//  ДанныеЗаполнения		  - данные заполнения, которые передаются в обработчик заполнения	
//
Функция ЗаполнитьГлавнуюЗадачу(БизнесПроцессОбъект, ДанныеЗаполнения) Экспорт
	
	Возврат Ложь;
	
КонецФункции
