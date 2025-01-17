﻿Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
		
	// Подсистема Свойства
	ПередЗаписьюВидаОбъекта(ЭтотОбъект, "Справочник_Проекты", "НаборСвойствПроектов");
	ПередЗаписьюВидаОбъекта(ЭтотОбъект, "Справочник_ПроектныеЗадачи", "НаборСвойствПроектныхЗадач");	
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	НаборСвойствПроектов = Неопределено;
	НаборСвойствПроектныхЗадач = Неопределено;
	
КонецПроцедуры

Процедура ПередЗаписьюВидаОбъекта(ВидОбъекта, ИмяОбъектаСоСвойствами, ИмяРеквизитаНабораСвойств) Экспорт
	
	Если Не ЗначениеЗаполнено(ВидОбъекта[ИмяРеквизитаНабораСвойств]) Тогда
		ОбъектНабора = Справочники.НаборыДополнительныхРеквизитовИСведений.СоздатьЭлемент();
	Иначе
		Если Не НаборСвойствНужноИзменить(ВидОбъекта, ИмяРеквизитаНабораСвойств) Тогда
			Возврат;
		КонецЕсли;
		
		ОбъектНабора = ВидОбъекта[ИмяРеквизитаНабораСвойств].ПолучитьОбъект();
		ЗаблокироватьДанныеДляРедактирования(ОбъектНабора.Ссылка);
	КонецЕсли;
	
	ОбъектНабора.Наименование    = ВидОбъекта.Наименование;
	ОбъектНабора.Родитель        = Справочники.НаборыДополнительныхРеквизитовИСведений[ИмяОбъектаСоСвойствами];
	ОбъектНабора.ПометкаУдаления = ВидОбъекта.ПометкаУдаления;
	ОбъектНабора.Записать();
	ВидОбъекта[ИмяРеквизитаНабораСвойств] = ОбъектНабора.Ссылка;
	
КонецПроцедуры

Функция НаборСвойствНужноИзменить(ВидОбъекта, ИмяРеквизитаНабораСвойств)
	
	Результат = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ВидОбъекта[ИмяРеквизитаНабораСвойств], "Наименование,ПометкаУдаления");
	Возврат (Результат.Наименование <> ВидОбъекта.Наименование) ИЛИ (Результат.ПометкаУдаления <> ВидОбъекта.ПометкаУдаления);
	
КонецФункции
