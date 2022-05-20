﻿
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РольИсполнителя) Тогда
		
		Наименование = Строка(РольИсполнителя);
		
		Если ЗначениеЗаполнено(ОсновнойОбъектАдресации) Тогда
			Наименование = Наименование + ", " + Строка(ОсновнойОбъектАдресации);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДополнительныйОбъектАдресации) Тогда
			Наименование = Наименование + ", " + Строка(ДополнительныйОбъектАдресации);
		КонецЕсли;
	Иначе
		Наименование = "<Без ролевой адресации>";
	КонецЕсли;
	
	// Проверка дубля.
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ГруппыИсполнителейЗадач.Ссылка
		|ИЗ
		|	Справочник.ГруппыИсполнителейЗадач КАК ГруппыИсполнителейЗадач
		|ГДЕ
		|	ГруппыИсполнителейЗадач.РольИсполнителя = &РольИсполнителя
		|	И ГруппыИсполнителейЗадач.ОсновнойОбъектАдресации = &ОсновнойОбъектАдресации
		|	И ГруппыИсполнителейЗадач.ДополнительныйОбъектАдресации = &ДополнительныйОбъектАдресации
		|	И ГруппыИсполнителейЗадач.Ссылка <> &Ссылка");
	Запрос.УстановитьПараметр("РольИсполнителя", РольИсполнителя);
	Запрос.УстановитьПараметр("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
	Запрос.УстановитьПараметр("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		ВызватьИсключение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Уже есть группа исполнителей задач для которой
			           |Роль исполнителя = ""%1""
			           |Основной объект адресации = ""%2""
			           |Дополнительный объект адресации = ""%3""'"),
			Строка(РольИсполнителя),
			Строка(ОсновнойОбъектАдресации),
			Строка(ДополнительныйОбъектАдресации)));
	КонецЕсли;
	
КонецПроцедуры
