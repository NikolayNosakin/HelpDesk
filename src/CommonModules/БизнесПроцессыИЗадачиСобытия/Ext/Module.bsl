﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-процессы и задачи"
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Обработчики подписок на события подсистемы.

// Обработчик подписки на событие ЗаписатьВСписокБизнесПроцессов.
//
Процедура ЗаписатьВСписокБизнесПроцессов(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда 
        Возврат;  
	КонецЕсли; 
	
	НаборЗаписей = РегистрыСведений.ДанныеБизнесПроцессов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.БизнесПроцесс.Значение = Источник.Ссылка;
	НаборЗаписей.Отбор.БизнесПроцесс.Использование = Истина;
	Запись = НаборЗаписей.Добавить();
	Запись.БизнесПроцесс = Источник.Ссылка;
	СписокПолей = "Номер,Дата,Завершен,Стартован,Автор,ДатаЗавершения,Наименование,ПометкаУдаления";
	ЗаполнитьЗначенияСвойств(Запись, Источник, СписокПолей);
	
	БизнесПроцессыИЗадачиПереопределяемый.ПриЗаписиСпискаБизнесПроцессов(Запись);
	
	УстановитьПривилегированныйРежим(Истина);
	НаборЗаписей.Записать();

КонецПроцедуры

// Обработчик подписки на событие УстановитьПометкуУдаленияЗадач.
//
Процедура УстановитьПометкуУдаленияЗадач(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда 
        Возврат;  
	КонецЕсли; 
	
	Если Источник.ЭтоНовый() Тогда 
        Возврат;  
	КонецЕсли; 
	
	ПредыдущаяПометкаУдаления = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Источник.Ссылка, "ПометкаУдаления");
	Если Источник.ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
		УстановитьПривилегированныйРежим(Истина);
		БизнесПроцессыИЗадачиСервер.УстановитьПометкуУдаленияЗадач(Источник.Ссылка, Источник.ПометкаУдаления);
	КонецЕсли;	
	
КонецПроцедуры

// Обработчик подписки на событие ОбновитьСостояниеБизнесПроцесса.
//
Процедура ОбновитьСостояниеБизнесПроцесса(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда 
        Возврат;  
	КонецЕсли; 
	
	Если Источник.Метаданные().Реквизиты.Найти("Состояние") = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Если Не Источник.ЭтоНовый() Тогда
		НовоеСостояние = Источник.Состояние;
		СтароеСостояние = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Источник.Ссылка, "Состояние");
		Если НовоеСостояние <> СтароеСостояние Тогда
			БизнесПроцессыИЗадачиСервер.ПриИзмененииСостоянияБизнесПроцесса(Источник, СтароеСостояние, НовоеСостояние);
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры
